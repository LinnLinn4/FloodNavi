import "report.dart";

const seedImportedKey = 'seed_imported_v1';

//Sample data
final List<Report> reports = [
  Report(
    id: 'seed_shelter_1',
    type: ReportType.shelter,
    lat: 20.42830, // tweak to exact spot
    lng: 99.88340,
    placeName: 'Wat Mae Sai Shelter',
    details: 'Community hall; mats & blankets available.',
    createdAt: DateTime.now(),
    estCapacity: 120,
    currCapacity: 30,
    hasFood: true,
    hasWater: true,
    hasToilet: true,
    hasCharging: true,
    access: 'Truck accessible; parking behind the hall',
  ),
  Report(
    id: 'seed_high_1',
    type: ReportType.highGround,
    lat: 20.43210,
    lng: 99.88050,
    placeName: 'Riverside High Ground',
    details: 'Open field above floodplain.',
    createdAt: DateTime.now(),
    estCapacity: 300,
    currCapacity: 0,
    hasWater: false,
    hasFood: false,
    hasToilet: false,
    hasCharging: false,
    access: 'Walkable; uneven terrain',
  ),
  Report(
    id: 'seed_aid_1',
    type: ReportType.aid,
    lat: 20.42690,
    lng: 99.88700,
    placeName: 'Aid Point – Market',
    details: 'Dry food & bottled water 10:00–18:00',
    createdAt: DateTime.now(),
    estCapacity: 0,
    currCapacity: 0,
    hasFood: true,
    hasWater: true,
    hasToilet: false,
    hasCharging: false,
    access: 'Near market parking lot',
  ),
];
