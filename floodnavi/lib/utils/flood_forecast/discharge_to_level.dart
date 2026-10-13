// lib/utils/flood_forecast/discharge_to_level.dart
// Tunables — start with these and refine when you get better site data.
const double kRiverWidthM = 28.0;
const double kMeanVelocity = 1.0; // m/s (0.8–1.3 typical)

// Elevation anchors
const double kAvgLevelM = 392.72; // “normal” water-surface elevation (m)
const double kBankLevelM = 397.59; // river bank elevation (m)

// Choose anchor discharges (m³/s).
const double kQAvg = 50.0; // discharge around when level ≈ 392.72 m
const double kQBank = 200.0; // discharge around when level ≈ 397.59 m

double _depthFromQ(double q) {
  // Rectangular section approximation: depth ≈ Q / (width * velocity)
  return q / (kRiverWidthM * kMeanVelocity);
}

/// Convert discharge (m³/s) → approximate water-surface elevation (m)
double dischargeToLevel(double q) {
  final dAvg = _depthFromQ(kQAvg);
  final dBank = _depthFromQ(kQBank);
  final dQ = _depthFromQ(q);

  final depthSpan = (dBank - dAvg).abs() < 1e-6 ? 1e-6 : (dBank - dAvg);
  final levelSpan = kBankLevelM - kAvgLevelM;

  return kAvgLevelM + (dQ - dAvg) * (levelSpan / depthSpan);
}
