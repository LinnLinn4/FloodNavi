import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

/// Reads tiles from disk if present, otherwise falls back to network.
class DiskFirstTileProvider extends TileProvider {
  DiskFirstTileProvider({
    required this.rootPath, // e.g. "<app-docs>/tiles"
    required this.urlTemplate,
    this.subdomains = const ['a', 'b', 'c'],
  });

  final String rootPath;
  final String urlTemplate;
  final List<String> subdomains;

  String _filePath(int z, int x, int y) => '$rootPath/$z/$x/$y.png';

  String _urlFor(int z, int x, int y) {
    final s = subdomains[(x + y) % subdomains.length];
    return urlTemplate
        .replaceAll('{s}', s)
        .replaceAll('{z}', '$z')
        .replaceAll('{x}', '$x')
        .replaceAll('{y}', '$y');
  }

  @override
  ImageProvider getImage(TileCoordinates coords, TileLayer options) {
    final x = coords.x.round();
    final y = coords.y.round();
    final z = coords.z.round();
    final file = File(_filePath(z, x, y));

    if (file.existsSync()) {
      return FileImage(file);
    }
    return NetworkImage(_urlFor(z, x, y));
  }
}
