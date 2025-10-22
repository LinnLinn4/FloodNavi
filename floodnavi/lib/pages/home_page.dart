import 'package:flutter/material.dart';
import '../utils/flood_forecast/graph.dart';
import '../utils/flood_forecast/weather_api.dart';
import '../utils/flood_forecast/flood_daily.dart';
import 'package:floodnavi/utils/flood_forecast/forecast_model.dart' as forecast;
import 'package:floodnavi/utils/flood_forecast/notification.dart' as noti;

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const _lat = 20.428056; // Mae Sai
  static const _lon = 99.883611;
  static const _dischargeThreshold = 397.59;

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late final Future<(FloodDaily, WeatherDaily)> _futureBothDaily;
  forecast.RiskLevel? _lastAlertedLevel;
  DateTime? _lastAlertAt;
  final Duration _alertCooldown = const Duration(minutes: 15);

  @override
  void initState() {
    super.initState();
    _futureBothDaily = Future.wait([
      fetchFloodDaily(lat: HomePage._lat, lon: HomePage._lon),
      fetchWeatherDaily(lat: HomePage._lat, lon: HomePage._lon),
    ]).then((res) => (res[0] as FloodDaily, res[1] as WeatherDaily));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "HOME",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No new notifications")),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          width: double.infinity,

          decoration: const BoxDecoration(
            color: Colors.black,
            // image: DecorationImage(
            //   image: AssetImage("assets/images/background.jpg"),
            //   fit: BoxFit.cover,
            // ),
          ),

          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "River Mae Sai\nMae Sai-Myanmar Bridge Station 1",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 30),
                SizedBox(
                  height: 220,

                  // child: FutureBuilder<FloodHourly>(
                  //   future: _future,
                  //   builder: (context, snap) {
                  //     if (snap.connectionState == ConnectionState.waiting) {
                  //       return const Center(
                  //         child: CircularProgressIndicator(color: Colors.white),
                  //       );
                  //     }
                  //     if (snap.hasError || !snap.hasData) {
                  //       return const Center(
                  //         child: Text(
                  //           'Failed to load data',
                  //           style: TextStyle(color: Colors.white70),
                  //         ),
                  //       );
                  //     }

                  //     final data = snap.data!;
                  //     final now = DateTime.now().toUtc();
                  //     final from = now.subtract(const Duration(hours: 6));
                  //     final times = <DateTime>[];
                  //     final vals = <double>[];

                  //     for (var i = 0; i < data.time.length; i++) {
                  //       final t = data.time[i].toUtc();
                  //       if (!t.isBefore(from) && !t.isAfter(now)) {
                  //         times.add(t);
                  //         vals.add(data.discharge[i]);
                  //       }
                  //     }

                  //     if (times.isEmpty) {
                  //       return const Center(
                  //         child: Text(
                  //           'No recent data',
                  //           style: TextStyle(color: Colors.white70),
                  //         ),
                  //       );
                  //     }

                  //     // ensure at most 7 ticks (0..6)
                  //     // while (times.length > 7) {
                  //     //   times.removeAt(0);
                  //     //   vals.removeAt(0);
                  //     // }

                  //     final labels = times
                  //         .map((d) => '${d.hour.toString().padLeft(2, '0')}:00')
                  //         .toList();

                  //     return WaterLevelChart(
                  //       levels: vals,
                  //       labels: labels,
                  //       floodThreshold: HomePage._dischargeThreshold,
                  //     );
                  //   },
                  // ),
                  child: FutureBuilder<FloodDaily>(
                    future: fetchFloodDaily(
                      lat: HomePage._lat,
                      lon: HomePage._lon,
                    ),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final d = snap.data!;

                      final levels = d.discharge;
                      final times = d.time;

                      final start = levels.length > 7 ? levels.length - 7 : 0;
                      final filteredLevels = levels.sublist(start);
                      final filteredTimes = times.sublist(start);

                      final labels = filteredTimes.map((t) {
                        return '${t.month}/${t.day}';
                      }).toList();

                      return WaterLevelChart(
                        levels: filteredLevels,
                        labels: labels,
                        floodThreshold: HomePage._dischargeThreshold,
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(10),
                  child: FutureBuilder<(FloodDaily, WeatherDaily)>(
                    future: _futureBothDaily,
                    builder: (context, snap) {
                      // show loading
                      if (snap.connectionState != ConnectionState.done) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      // show error if any
                      if (snap.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Failed to load data',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      // check null
                      final data = snap.data;
                      if (data == null) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No data returned'),
                        );
                      }

                      final (dis, wx) = snap.data!;

                      final risk = forecast.computeFloodRiskDaily(
                        tLevel: dis.time,
                        level: dis.discharge,
                        levelThreshold: HomePage._dischargeThreshold,
                        tPrecip: wx.time,
                        precipPerDay: wx.precipSum,
                        forecastDays: 2,
                        lookbackDaysForSlope: 3,
                        antecedentDays: 7,
                      );

                      final bannerColor = switch (risk.level) {
                        forecast.RiskLevel.severe => Colors.red.shade700,
                        forecast.RiskLevel.high => Colors.red,
                        forecast.RiskLevel.medium => Colors.orange,
                        forecast.RiskLevel.low => Colors.green,
                      };

                      final icon = switch (risk.level) {
                        forecast.RiskLevel.severe => Icons.crisis_alert,
                        forecast.RiskLevel.high => Icons.crisis_alert,
                        forecast.RiskLevel.medium => Icons.warning_amber,
                        forecast.RiskLevel.low => Icons.check_circle,
                      };

                      final isHighOrSevere =
                          risk.level.index >= noti.RiskLevel.high.index;
                      final cooledDown =
                          _lastAlertAt == null ||
                          DateTime.now().difference(_lastAlertAt!) >
                              _alertCooldown;

                      if (risk.level.index >= forecast.RiskLevel.high.index &&
                          risk.level != _lastAlertedLevel) {
                        _lastAlertedLevel = risk.level;

                        final title = risk.level == noti.RiskLevel.severe
                            ? '🚨 SEVERE Flood Risk'
                            : '⚠️ High Flood Risk';

                        final body = [
                          'Location: Mae Sai area',
                          if (risk.reasons.isNotEmpty) ...risk.reasons,
                        ].join(' • ');

                        noti.NotificationService.instance.showRiskAlert(
                          level: risk.level,
                          title: title,
                          body: body,
                        );
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: bannerColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.all(20),
                        //margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(icon, color: Colors.white),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${risk.level.name.toUpperCase()} Risk | ${risk.reasons.join(" , ")}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Expanded(
                            child: _buildButton(
                              Icons.safety_check,
                              "Nearest SafeZone",
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _buildButton(
                              Icons.insert_drive_file_rounded,
                              "Report Info",
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _buildButton(
                              Icons.phone,
                              "Emergency Contact",
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(child: _buildButton(Icons.book, "Handbook")),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildButton(IconData icon, String label) {
  return SizedBox(
    height: 120,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.all(10),
      ),

      onPressed: () => {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon, size: 50),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}
