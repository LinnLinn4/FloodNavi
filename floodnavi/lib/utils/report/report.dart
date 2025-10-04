enum ReportType { shelter, highGround, aid, sos }

extension ReportTypeX on ReportType {
  String get label {
    switch (this) {
      case ReportType.shelter:
        return 'Flood Shelter';
      case ReportType.highGround:
        return 'High Ground';
      case ReportType.aid:
        return 'Aid';
      case ReportType.sos:
        return 'SOS';
    }
  }

  double get hue {
    switch (this) {
      case ReportType.shelter:
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
  final String id;
  final ReportType type;
  final double lat;
  final double lng;
  final String placeName;
  final String details;
  final DateTime createdAt;
  final int estCapacity;
  final int currCapacity;
  final bool hasWater;
  final bool hasFood;
  final bool hasToilet;
  final bool hasCharging;
  final String access;

  Report({
    required this.id,
    required this.type,
    required this.lat,
    required this.lng,
    required this.placeName,
    required this.details,
    required this.createdAt,
    required this.estCapacity,
    required this.currCapacity,
    this.hasWater = false,
    this.hasFood = false,
    this.hasToilet = false,
    this.hasCharging = false,
    this.access = '',
  });

  // Firestore-ready map
  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type.index,
    'lat': lat,
    'lng': lng,
    'placeName': placeName,
    'estCapacity': estCapacity,
    'currCapacity': currCapacity,
    'hasWater': hasWater,
    'hasFood': hasFood,
    'hasToilet': hasToilet,
    'hasCharging': hasCharging,
    'access': access,
    'details': details,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Report.fromMap(Map<String, dynamic> m) => Report(
    id: m['id'] as String,
    type: ReportType.values[(m['type'] as num).toInt()],
    lat: (m['lat'] as num).toDouble(),
    lng: (m['lng'] as num).toDouble(),
    placeName: (m['placeName'] as String?) ?? '',
    estCapacity: (m['estCapacity']),
    currCapacity: (m['currCapacity']),
    hasWater: m['hasWater'] as bool? ?? false,
    hasFood: m['hasFood'] as bool? ?? false,
    hasToilet: m['hasToilet'] as bool? ?? false,
    hasCharging: m['hasCharging'] as bool? ?? false,
    access: (m['access'] as String?) ?? '',
    details: (m['details'] as String?) ?? '',
    createdAt:
        DateTime.tryParse(m['createdAt'] as String? ?? '') ?? DateTime.now(),
  );
}
