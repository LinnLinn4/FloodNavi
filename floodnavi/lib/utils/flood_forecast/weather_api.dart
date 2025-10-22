import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherDaily {
  final List<DateTime> time;
  final List<double> precipSum; // mm
  WeatherDaily({required this.time, required this.precipSum});
}

Future<WeatherDaily> fetchWeatherDaily({
  required double lat,
  required double lon,
  int pastDays = 6,
  int forecasDays = 1,
}) async {
  final uri = Uri.parse(
    'https://api.open-meteo.com/v1/forecast'
    '?latitude=$lat&longitude=$lon'
    '&daily=precipitation_sum'
    '&past_days=$pastDays&forecast_days=$forecasDays',
  );

  final r = await http.get(uri);
  if (r.statusCode != 200) {
    throw Exception('Weather API HTTP ${r.statusCode}: ${r.body}');
  }

  final root = jsonDecode(r.body) as Map<String, dynamic>;
  final daily = root['daily'] as Map<String, dynamic>?;

  if (daily == null) {
    throw Exception('Weather API missing daily: ${r.body}');
  }

  final times = (daily['time'] as List)
      .cast<String>()
      .map((s) => DateTime.parse(s)) // local date (no time)
      .toList();

  final precip = (daily['precipitation_sum'] as List)
      .cast<num>()
      .map((n) => n.toDouble())
      .toList();

  // late final Map<String, dynamic> j;
  // try {
  //   j = jsonDecode(r.body) as Map<String, dynamic>;
  // } catch (e) {
  //   throw Exception('Weather API JSON parse error: $e\nBody: ${r.body}');
  // }

  // if (j['daily'] == null) {
  //   throw Exception('Weather API missing "daily" in response: ${r.body}');
  // }
  // final daily = j['daily'] as Map<String, dynamic>;

  List<T> asList<T>(dynamic x, String key) {
    if (x is! List) throw Exception('Weather API "$key" is not a List');
    return x.map((e) => e as T).toList();
  }

  // final times = asList<String>(
  //   daily['time'],
  //   'time',
  // ).map((s) => DateTime.parse(s).toUtc()).toList();
  // final precipSum = asList<num>(
  //   daily['precipitation'],
  //   'precipitation',
  // ).map((n) => (n).toDouble()).toList();

  if (times.isEmpty || precip.isEmpty) {
    throw Exception('Weather API returned empty arrays');
  }
  if (times.length != precip.length) {
    throw Exception(
      'Length mismatch: time=${times.length} precip=${precip.length}',
    );
  }

  return WeatherDaily(time: times, precipSum: precip);
}
