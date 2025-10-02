enum ReportType { safeZone, highGround, aid, sos }

extension ReportTypeX on ReportType {
  String get label {
    switch (this) {
      case ReportType.safeZone:
        return 'Safe Zone';
      case ReportType.highGround:
        return 'High Ground';
      case ReportType.aid:
        return 'Aid';
      case ReportType.sos:
        return 'SOS';
    }
  }

  // Temporary simple color/hue – swap to custom icons later.
  double get hue {
    switch (this) {
      case ReportType.safeZone:
        return 120; // green
      case ReportType.highGround:
        return 210; // blue
      case ReportType.aid:
        return 0; // red
      case ReportType.sos:
        return 30; // orange
    }
  }
}

class Report {
  final String id; // uuid or any unique string
  final ReportType type;
  final double lat;
  final double lng;
  final String placeName; // shown as marker title
  final String details; // marker snippet
  final DateTime createdAt;

  Report({
    required this.id,
    required this.type,
    required this.lat,
    required this.lng,
    required this.placeName,
    required this.details,
    required this.createdAt,
  });

  // Firestore-ready map
  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type.index,
    'lat': lat,
    'lng': lng,
    'placeName': placeName,
    'details': details,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Report.fromMap(Map<String, dynamic> m) => Report(
    id: m['id'] as String,
    type: ReportType.values[(m['type'] as num).toInt()],
    lat: (m['lat'] as num).toDouble(),
    lng: (m['lng'] as num).toDouble(),
    placeName: (m['placeName'] as String?) ?? '',
    details: (m['details'] as String?) ?? '',
    createdAt:
        DateTime.tryParse(m['createdAt'] as String? ?? '') ?? DateTime.now(),
  );
}
