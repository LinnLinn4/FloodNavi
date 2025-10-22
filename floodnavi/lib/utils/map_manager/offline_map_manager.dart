import 'package:path_provider/path_provider.dart';
import 'tile_downloader.dart';

class OfflineMapManager {
  static final _downloader = TileDownloader();

  /// Resolve the tiles root path (same place downloader writes).
  static Future<String> tilesRootPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/tiles';
  }

  /// Call from your download button.
  static Future<void> downloadMaeSai({
    double south = 20.40,
    double west = 99.85,
    double north = 20.48,
    double east = 99.92,
    int minZoom = 14,
    int maxZoom = 16,
    void Function(double progress)? onProgress,
  }) async {
    int totalAll = 0, doneAll = 0;

    // pre-count total tiles across zooms for a nicer progress (optional)
    await _downloader.downloadMaeSai(
      south: south,
      west: west,
      north: north,
      east: east,
      minZoom: minZoom,
      maxZoom: maxZoom,
      onProgress: (done, total) {
        // This callback is per-zoom in the current implementation.
        doneAll = done;
        totalAll = total;
        if (onProgress != null && totalAll > 0) {
          onProgress(doneAll / totalAll);
        }
      },
    );
  }
}
