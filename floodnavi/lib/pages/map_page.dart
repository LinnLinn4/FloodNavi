import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:floodnavi/utils/report/report.dart';
import 'package:floodnavi/utils/report/reportform.dart';
import 'package:floodnavi/utils/report/report_details.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  GoogleMapController? _controller;

  // Mae Sai Location
  static const LatLng _maeSai = LatLng(20.4397, 99.8790);
  static const CameraPosition _initialPos = CameraPosition(
    target: _maeSai,
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    _loadReports();
    _deleteAllReportsForDebug();
  }

  // Storage
  final List<Report> _reports = [];
  static const _storageKey = 'reports_v1';

  // Filter (which types are visible)
  final Set<ReportType> _visibleTypes = {
    ReportType.shelter,
    ReportType.highGround,
    ReportType.aid,
    ReportType.sos,
  };

  Future<void> _loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_storageKey) ?? [];
    final loaded = <Report>[];
    for (final s in list) {
      try {
        loaded.add(Report.fromMap(jsonDecode(s) as Map<String, dynamic>));
      } catch (_) {}
    }
    setState(() {
      _reports
        ..clear()
        ..addAll(
          loaded.isEmpty
              ? [
                  // Optional: a default marker at Mae Sai
                ]
              : loaded,
        );
    });
    await _saveReports();
  }

  Future<void> _saveReports() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      _reports.map((r) => jsonEncode(r.toMap())).toList(),
    );
  }

  Future<void> _deleteAllReportsForDebug() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    debugPrint('✅ All saved markers deleted from local storage.');
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
            // keep small bubble if you want
            title: r.placeName,
            //snippet: r.details,
            onTap: () => openReportDetails(
              context,
              r,
              _controller,
            ), // tap bubble -> full sheet
          ),
          onTap: () => openReportDetails(context, r, _controller),
          // draggable: true,
          icon: BitmapDescriptor.defaultMarkerWithHue(r.type.hue),
          // onDragEnd: (p) {
          //   final i = _reports.indexWhere((e) => e.id == r.id);
          //   if (i != -1) {
          //     setState(
          //       () => _reports[i] = Report(
          //         id: r.id,
          //         type: r.type,
          //         lat: p.latitude,
          //         lng: p.longitude,
          //         placeName: r.placeName,
          //         details: r.details,
          //         createdAt: r.createdAt,
          //       ),
          //     );
          //     _saveReports();
          //   }
          // },
        ),
      );
    }
    return set;
  }

  void _onMapCreated(GoogleMapController c) => _controller = c;

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
      id: DateTime.now().millisecondsSinceEpoch.toString(), // or a uuid
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
          GoogleMap(
            initialCameraPosition: _initialPos,
            onMapCreated: _onMapCreated,
            myLocationEnabled: false, //do not show current location
            myLocationButtonEnabled: false, //no jump to current location
            markers: _visibleMarkers,
            zoomControlsEnabled: false,
            onLongPress: _onLongPress,
            //compassEnabled: true,
          ),
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
                    onPressed: () => {},
                    icon: const Icon(Icons.file_download),
                    color: Colors.white,
                    iconSize: 25,
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.insert_drive_file_rounded),
                    color: Colors.white,
                    iconSize: 45,
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
