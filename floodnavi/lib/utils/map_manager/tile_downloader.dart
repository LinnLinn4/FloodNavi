import 'dart:math';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class TileDownloader {
  TileDownloader({
    this.urlTemplate = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    this.subdomains = const ['a', 'b', 'c'],
  });

  final String urlTemplate;
  final List<String> subdomains;

  Future<String> _tilesRoot() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/tiles';
    await Directory(path).create(recursive: true);
    return path;
  }

  String _urlFor(int z, int x, int y) {
    final s = subdomains[(x + y) % subdomains.length];
    return urlTemplate
        .replaceAll('{s}', s)
        .replaceAll('{z}', '$z')
        .replaceAll('{x}', '$x')
        .replaceAll('{y}', '$y');
  }

  String _filePath(String root, int z, int x, int y) => '$root/$z/$x/$y.png';

  // WebMercator helpers
  static int _lon2tileX(double lon, int z) =>
      ((lon + 180.0) / 360.0 * (1 << z)).floor();
  static int _lat2tileY(double lat, int z) {
    final rad = lat * pi / 180.0;
    return ((1 - log(tan(rad) + 1 / cos(rad)) / pi) / 2 * (1 << z)).floor();
  }

  /// Download tiles covering [south, west, north, east] for zooms [minZ..maxZ]
  Future<void> downloadMaeSai({
    required double south,
    required double west,
    required double north,
    required double east,
    required int minZoom,
    required int maxZoom,
    void Function(int done, int total)? onProgress,
  }) async {
    final root = await _tilesRoot();

    for (int z = minZoom; z <= maxZoom; z++) {
      final xMin = _lon2tileX(west, z);
      final xMax = _lon2tileX(east, z);
      final yMin = _lat2tileY(north, z); // note: north->min y in TMS
      final yMax = _lat2tileY(south, z);

      final total = (xMax - xMin + 1) * (yMax - yMin + 1);
      int done = 0;

      for (int x = xMin; x <= xMax; x++) {
        for (int y = yMin; y <= yMax; y++) {
          final file = File(_filePath(root, z, x, y));
          if (!await file.exists()) {
            final url = _urlFor(z, x, y);
            final resp = await http.get(Uri.parse(url));
            if (resp.statusCode == 200) {
              await file.parent.create(recursive: true);
              await file.writeAsBytes(resp.bodyBytes, flush: true);
            }
          }
          done++;
          onProgress?.call(done, total);
        }
      }
    }
  }
}
