import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final Set<Marker> _markers = {};
  static const _storageKey = 'saved_markers_v1';

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  /// Load saved markers from local storage.
  Future<void> _loadMarkers() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_storageKey) ?? [];

    if (list.isEmpty) {
      // If nothing saved yet, start with one marker at Mae Sai (optional)
      setState(() {
        _markers.add(
          const Marker(
            markerId: MarkerId('maesai'),
            position: _maeSai,
            infoWindow: InfoWindow(title: 'Mae Sai'),
            draggable: true,
          ),
        );
      });
      await _saveMarkers(); // persist the default
      return;
    }

    final loaded = <Marker>{};
    for (final item in list) {
      try {
        final m = jsonDecode(item) as Map<String, dynamic>;
        final id = m['id'] as String;
        final lat = (m['lat'] as num).toDouble();
        final lng = (m['lng'] as num).toDouble();
        final title = (m['title'] as String?) ?? 'Pin';

        loaded.add(
          Marker(
            markerId: MarkerId(id),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: title),
            draggable: true,
            onDragEnd: (p) => _updateMarkerPosition(id, p),
          ),
        );
      } catch (_) {
        // skip malformed entries
      }
    }

    setState(() {
      _markers
        ..clear()
        ..addAll(loaded);
    });
  }

  /// Save current markers to local storage.
  Future<void> _saveMarkers() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _markers.map((m) {
      return jsonEncode({
        'id': m.markerId.value,
        'lat': m.position.latitude,
        'lng': m.position.longitude,
        'title': m.infoWindow.title ?? 'Pin',
      });
    }).toList();
    await prefs.setStringList(_storageKey, list);
  }

  /// Update a marker's position (after dragging) and persist.
  void _updateMarkerPosition(String id, LatLng newPos) {
    setState(() {
      _markers
        ..removeWhere((m) => m.markerId.value == id)
        ..add(
          Marker(
            markerId: MarkerId(id),
            position: newPos,
            infoWindow: const InfoWindow(title: 'Pin'),
            draggable: true,
            onDragEnd: (p) => _updateMarkerPosition(id, p),
          ),
        );
    });
    _saveMarkers();
  }

  void _onMapCreated(GoogleMapController c) => _controller = c;

  /// Add marker on long-press and persist.
  void _onLongPress(LatLng latLng) {
    final id =
        '${latLng.latitude.toStringAsFixed(6)},${latLng.longitude.toStringAsFixed(6)}';
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(id),
          position: latLng,
          infoWindow: const InfoWindow(title: 'Pin'),
          draggable: true,
          onDragEnd: (p) => _updateMarkerPosition(id, p),
        ),
      );
    });
    _saveMarkers();
  }

  /// Optional: clear all markers.
  Future<void> _clearAll() async {
    setState(() => _markers.clear());
    await _saveMarkers();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('All markers cleared')));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // for AutomaticKeepAliveClientMixin
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Clear all markers',
            onPressed: _markers.isEmpty ? null : _clearAll,
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPos,
            onMapCreated: _onMapCreated,
            myLocationEnabled: false, // 🔒 do not show current location
            myLocationButtonEnabled: false, // 🔒 no jump to current location
            markers: _markers,
            onLongPress: _onLongPress,
            compassEnabled: true,
          ),
          Positioned(
            bottom: 20,
            right: 20,
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

  @override
  bool get wantKeepAlive => true;
}
