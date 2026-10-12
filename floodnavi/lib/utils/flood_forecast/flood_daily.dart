// flood_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'discharge_to_level.dart' as conv;

class FloodDaily {
  final List<DateTime> time;
  final List<double> discharge; // prefer river_discharge if present

  FloodDaily({required this.time, required this.discharge});
}

Future<FloodDaily> fetchFloodDaily({
  required double lat,
  required double lon,
  int pastDays = 6,
  int forecastDays = 1,
}) async {
  final uri = Uri.parse(
    'https://flood-api.open-meteo.com/v1/flood'
    '?latitude=$lat&longitude=$lon'
    '&daily=river_discharge'
    '&past_days=$pastDays&forecast_days=$forecastDays'
    '&models=seamless_v4'
    '&timezone=UTC',
  );

  final r = await http.get(uri);
  if (r.statusCode != 200) {
    throw Exception('Flood API HTTP ${r.statusCode}: ${r.body}');
  }
  final j = jsonDecode(r.body) as Map<String, dynamic>;
  if (j['daily'] == null) {
    throw Exception('Flood API: missing "daily" in response: ${r.body}');
  }

  final daily = j['daily'] as Map<String, dynamic>;

  List<T> asList<T>(String key) {
    final v = daily[key];
    if (v is! List) throw Exception('"$key" not a List');
    return v.map((e) => e as T).toList();
  }

  final dates = asList<String>('time');
  // turn YYYY-MM-DD into midnight UTC DateTime (or any fixed time)
  final times = dates
      .map((d) => DateTime.parse('${d}T00:00:00Z').toUtc())
      .toList();

  // Some locations/models don’t return river_discharge, only *_mean
  List<double> toDoubleList(String key) =>
      asList<num>(key).map((n) => n.toDouble()).toList();

  final discharge = daily.containsKey('river_discharge')
      ? toDoubleList('river_discharge')
      : List<double>.filled(times.length, double.nan);

  final levelMetersSeries = discharge.map(conv.dischargeToLevel).toList();
  return FloodDaily(time: times, discharge: levelMetersSeries);
}
