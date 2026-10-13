import 'dart:convert';
import 'dart:async';

import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:latlong2/latlong.dart' as latlng;
import '../utils/map_manager/offline_map_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:floodnavi/utils/report/report.dart';
import 'package:floodnavi/utils/report/reportform.dart';
import 'package:floodnavi/utils/report/report_details.dart';
import 'package:floodnavi/utils/report/report_data.dart';
//import 'package:floodnavi/utils/map_manager/offline_map_manager.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  GoogleMapController? _controller;
  String? _localTilesRoot;
  final _online = true;

  // Mae Sai Location
  static const LatLng _maeSai = LatLng(20.4397, 99.8790);
  static const CameraPosition _initialPos = CameraPosition(
    target: _maeSai,
    zoom: 13,
  );
  String? _tilesRoot;

  bool _isOnline = true;
  late StreamSubscription<InternetConnectionStatus> _connSub;

  @override
  void initState() {
    super.initState();
    _loadReports();
    _initTilesRoot();
    _watchConnectivity();
  }

  Future<void> _initTilesRoot() async {
    _tilesRoot = await OfflineMapManager.tilesRootPath();
    setState(() {});
  }

  void _watchConnectivity() async {
    final connectionChecker = InternetConnectionChecker.instance;

    // Initial check
    connectionChecker.hasConnection.then((connected) {
      setState(() => _isOnline = connected);
    });

    // Listen for connectivity changes
    _connSub = connectionChecker.onStatusChange.listen((status) {
      final online = status == InternetConnectionStatus.connected;
      if (online != _isOnline) {
        setState(() => _isOnline = online);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              online
                  ? 'Connected to the internet'
                  : 'Offline – showing offline map',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
    connectionChecker.dispose();
  }

  @override
  void dispose() {
    _connSub.cancel();
    super.dispose();
  }

  Future<void> _downloadTiles() async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Downloading map for offline use...')),
    );

    await OfflineMapManager.downloadMaeSai(onProgress: (p) {});

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Offline map download complete ✅')),
    );
  }

  // Storage
  final List<Report> _reports = [];
  static const _storageKey = 'reports_v1';

  // Report Types
  final Set<ReportType> _visibleTypes = {
    ReportType.shelter,
    ReportType.highGround,
    ReportType.aid,
    ReportType.sos,
  };

  Future<void> _loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    final imported = prefs.getBool(seedImportedKey) ?? false;

    final saved = prefs.getStringList(_storageKey) ?? [];
    final loaded = <Report>[];

    for (final s in saved) {
      try {
        loaded.add(Report.fromMap(jsonDecode(s) as Map<String, dynamic>));
      } catch (_) {}
    }

    if (loaded.isEmpty) {
      final seeds = List<Report>.from(reports);
      if (seeds.isNotEmpty) {
        setState(() {
          _reports
            ..clear()
            ..addAll(seeds);
        });

        await prefs.setStringList(
          _storageKey,
          seeds.map((r) => jsonEncode(r.toMap())).toList(),
        );
        await prefs.setBool(seedImportedKey, true);
      }
    } else {
      setState(() {
        _reports
          ..clear()
          ..addAll(loaded);
      });
    }
    debugPrint(
      'imported? $imported  loaded=${loaded.length}  in-memory=${_reports.length}',
    );
  }

  Future<void> _saveReports() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      _reports.map((r) => jsonEncode(r.toMap())).toList(),
    );
  }

  Set<Marker> get _visibleMarkers {
    final set = <Marker>{};
    for (final r in _reports) {
      if (!_visibleTypes.contains(r.type)) continue;
      set.add(
        Marker(
          markerId: MarkerId(r.id),
          position: LatLng(r.lat, r.lng),
          infoWindow: InfoWindow(
            title: r.placeName,
            //snippet: r.details,
            onTap: () => openReportDetails(context, r, _controller),
          ),
          onTap: () => openReportDetails(context, r, _controller),
          icon: BitmapDescriptor.defaultMarkerWithHue(r.type.hue),
        ),
      );
    }
    return set;
  }

  // Report Markers
  List<fmap.Marker> get _visibleMarkersOffline {
    return _reports.where((r) => _visibleTypes.contains(r.type)).map((r) {
      final color = switch (r.type) {
        ReportType.shelter => Colors.green,
        ReportType.highGround => Colors.blue,
        ReportType.aid => Colors.red,
        ReportType.sos => Colors.orange,
      };

      return fmap.Marker(
        point: latlng.LatLng(r.lat, r.lng),
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () => openReportDetails(context, r, _controller),
          child: Icon(Icons.location_on, color: color, size: 40),
        ),
      );
    }).toList();
  }

  void _onLongPress(LatLng pos) {
    _openReportForm(context, pos);
  }

  Future<void> _openReportForm(BuildContext context, LatLng pos) async {
    final result = await showModalBottomSheet<ReportFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) => ReportForm(initialType: ReportType.shelter),
    );

    if (result == null) return; // cancelled

    // Create and save report
    final newReport = Report(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: result.type,
      lat: pos.latitude,
      lng: pos.longitude,
      placeName: result.placeName,
      estCapacity: result.estCapacity,
      currCapacity: result.currCapacity,
      hasFood: result.food,
      hasWater: result.water,
      hasToilet: result.toilet,
      hasCharging: result.charging,
      access: result.access,
      details: result.details,
      createdAt: DateTime.now(),

      phone: result.phone,
      peopleCount: result.peopleCount,
      severity: result.severity,
      medical: result.medical,
      trapped: result.trapped,
    );

    setState(() => _reports.add(newReport));
    _saveReports();
  }

  //filter setting
  bool _filtersExpanded = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          _isOnline ? _buildOnlineMap() : _buildOfflineMap(),
          Positioned(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: _buildFilterPanel(),
            ),
          ),

          Positioned(
            top: 30,
            right: 20,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.search),
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => {},
                    icon: Icon(Icons.notifications),
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.sync),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: 20,
            bottom: 20,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _downloadTiles,
                    icon: const Icon(Icons.file_download),
                    color: Colors.white,
                    iconSize: 40,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'zoom_in',
                  onPressed: () =>
                      _controller?.animateCamera(CameraUpdate.zoomIn()),
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 12),
                FloatingActionButton.small(
                  heroTag: 'zoom_out',
                  onPressed: () =>
                      _controller?.animateCamera(CameraUpdate.zoomOut()),
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineMap() {
    return GoogleMap(
      initialCameraPosition: _initialPos,
      onMapCreated: (c) => _controller = c,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      markers: _visibleMarkers,
      onLongPress: _onLongPress,
    );
  }

  Widget _buildOfflineMap() {
    if (_tilesRoot == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return fmap.FlutterMap(
      options: fmap.MapOptions(
        initialCenter: latlng.LatLng(_maeSai.latitude, _maeSai.longitude),
        initialZoom: 13,
      ),
      children: [
        if (_online)
          // ONLINE layer
          fmap.TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            //subdomains: const ['a', 'b', 'c'],
            // default network provider
          )
        else
          // OFFLINE layer (reads from files the user downloaded earlier)
          fmap.TileLayer(
            urlTemplate: 'file://${_localTilesRoot!}/{z}/{x}/{y}.png',
            tileProvider: fmap.FileTileProvider(),
          ),
        fmap.MarkerLayer(markers: _visibleMarkersOffline),
      ],
    );
  }

  Widget _buildFilterPanel() {
    return SafeArea(
      child: Card(
        margin: const EdgeInsets.only(top: 8, left: 12, right: 12),
        child: Theme(
          // makes ExpansionTile dense and clean
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: _filtersExpanded,
            onExpansionChanged: (v) => setState(() => _filtersExpanded = v),
            title: Row(
              children: [
                const Icon(Icons.filter_list),
                const SizedBox(width: 8),
                const Text('Filters'),
                const Spacer(),
              ],
            ),
            children: [
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ReportType.values.map((t) {
                    final selected = _visibleTypes.contains(t);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: FilterChip(
                        label: Text(t.label),
                        selected: selected,
                        onSelected: (_) {
                          setState(() {
                            if (selected) {
                              _visibleTypes.remove(t);
                            } else {
                              _visibleTypes.add(t);
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
