enum RiskLevel { low, medium, high, severe }

class RiskResult {
  final RiskLevel level;
  final List<String> reasons;
  const RiskResult(this.level, this.reasons);
}

/// Daily model using discharge (m³/s) and precipitation (mm/day)
RiskResult computeFloodRiskDaily({
  required List<DateTime> tLevel, // daily timestamps
  required List<double> level, // daily discharge
  double? levelThreshold = 397.59, // null if unknown
  required List<DateTime>? tPrecip, // daily timestamps for precip (optional)
  required List<double>? precipPerDay, // daily precipitation_sum (mm)
  int lookbackDaysForSlope = 3, // trend window
  int antecedentDays = 6, // recent wetness
  int forecastDays = 1, // near-term precip

  final levelNormal = 392.72,
}) {
  final reasons = <String>[];
  if (tLevel.isEmpty || level.isEmpty) {
    return RiskResult(RiskLevel.low, ['No discharge data']);
  }
  // Align lengths just in case
  final n = level.length;
  final last = level[n - 1];
  final prev = n >= 2 ? level[n - 2] : last;
  final rise = last - prev;

  // Simple slope over last N days
  double slopePerDay = 0;
  if (n >= lookbackDaysForSlope + 1) {
    final start = n - 1 - lookbackDaysForSlope;
    final xs = <double>[];
    final ys = <double>[];
    for (var i = 0; i <= lookbackDaysForSlope; i++) {
      xs.add(i.toDouble());
      ys.add(level[start + i]);
    }
    // least squares slope
    final meanX = xs.reduce((a, b) => a + b) / xs.length;
    final meanY = ys.reduce((a, b) => a + b) / ys.length;
    double num = 0, den = 0;
    for (var i = 0; i < xs.length; i++) {
      final dx = xs[i] - meanX;
      num += dx * (ys[i] - meanY);
      den += dx * dx;
    }
    slopePerDay = den == 0 ? 0 : num / den;
  }

  // Antecedent wetness & near-term forecast
  double antecedentMm = 0, forecastMm = 0;
  if (tPrecip != null && precipPerDay != null && tPrecip.isNotEmpty) {
    // We assume same daily alignment or near-daily (keep it simple):
    // Sum last `antecedentDays` and next `forecastDays`
    final m = precipPerDay.length;
    if (m > 0) {
      // antecedent = last up to N days (bounded)
      final aTake = antecedentDays.clamp(0, m);
      antecedentMm = precipPerDay
          .sublist((m - aTake).clamp(0, m), m)
          .fold<double>(0, (s, v) => s + v);

      if (m >= forecastDays) {
        forecastMm = precipPerDay
            .sublist(m - forecastDays, m)
            .fold<double>(0, (s, v) => s + v);
      }
    }
  }

  // Typical signals:
  // - Level above threshold (or close)
  // - Positive slope / rising quickly
  // - Wet catchment recently + incoming rain
  final nearThresh = (levelThreshold != null)
      ? (last >= 0.9 * levelThreshold)
      : false;
  final aboveThresh = (levelThreshold != null)
      ? (last >= levelThreshold)
      : false;

  if (aboveThresh && (slopePerDay > 0 || forecastMm > 10)) {
    reasons.add('Discharge above threshold');
    if (slopePerDay > 0) reasons.add('Level rising');
    if (forecastMm > 10) reasons.add('Heavy rain forecast');
    return RiskResult(RiskLevel.severe, reasons);
  }

  if (nearThresh && (slopePerDay > 0 || antecedentMm > 30 || forecastMm > 20)) {
    if (nearThresh) reasons.add('Near flood threshold');
    if (slopePerDay > 0) reasons.add('Level rising');
    if (antecedentMm > 30) reasons.add('Wet catchment (7d)');
    if (forecastMm > 20) reasons.add('Very wet forecast');
    return RiskResult(RiskLevel.high, reasons);
  }

  if ((slopePerDay > 0 && rise > 0) ||
      (antecedentMm > 15) ||
      (forecastMm > 10)) {
    if (slopePerDay > 0) reasons.add('Rising trend');
    if (antecedentMm > 15) reasons.add('Recent rain');
    if (forecastMm > 10) reasons.add('Rain forecast');
    return RiskResult(RiskLevel.medium, reasons);
  }

  reasons.add('Stable / low discharge');
  return RiskResult(RiskLevel.low, reasons);
}
