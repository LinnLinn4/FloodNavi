import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'report.dart';

void openReportDetails(
  BuildContext context,
  Report r,
  GoogleMapController? controller,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.35,
      minChildSize: 0.25,
      maxChildSize: 0.8,
      builder: (context, scrollCtrl) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: ListView(
            controller: scrollCtrl,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Icon(_iconForType(r.type), color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      r.placeName.isEmpty ? r.type.label : r.placeName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              Text(
                'Location: ${r.lat.toStringAsFixed(5)}, ${r.lng.toStringAsFixed(5)}',
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Text(
                'Type: ${r.type.label}',
                style: const TextStyle(color: Colors.black54),
              ),
              Text(
                'Name: ${r.placeName}',
                style: const TextStyle(color: Colors.black54),
              ),
              Text(
                'Estimated Capacity: ${r.estCapacity} people',
                style: const TextStyle(color: Colors.black54),
              ),
              Text(
                'Available space: ${r.estCapacity - r.currCapacity} people',
                style: const TextStyle(color: Colors.black54),
              ),
              const Text('Facilities', style: TextStyle(color: Colors.black54)),
              _facilitiesRow(r),
              if (r.access.isNotEmpty)
                Text(
                  'Accessibilities: ${r.access}',
                  style: TextStyle(color: Colors.black54),
                ),
              if (r.details.isNotEmpty)
                Text(r.details, style: TextStyle(color: Colors.black54)),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        controller?.animateCamera(
                          CameraUpdate.newLatLngZoom(LatLng(r.lat, r.lng), 16),
                        );
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.center_focus_strong),
                      label: const Text('Center'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: open external maps or route
                      },
                      icon: const Icon(Icons.directions),
                      label: const Text('Directions'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}

IconData _iconForType(ReportType t) {
  switch (t) {
    case ReportType.shelter:
      return Icons.safety_check;
    case ReportType.highGround:
      return Icons.terrain;
    case ReportType.aid:
      return Icons.volunteer_activism;
    case ReportType.sos:
      return Icons.sos;
  }
}

Widget _facilityChip(IconData icon, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    margin: const EdgeInsets.only(right: 8, bottom: 8),
    decoration: BoxDecoration(
      color: Colors.green.withOpacity(0.08),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.green.withOpacity(0.25)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.green),
        const SizedBox(width: 6),
        Text(label),
      ],
    ),
  );
}

Widget _facilitiesRow(Report r) {
  final chips = <Widget>[];
  if (r.hasFood) chips.add(_facilityChip(Icons.restaurant, 'Food'));
  if (r.hasWater) chips.add(_facilityChip(Icons.water_drop, 'Water'));
  if (r.hasToilet) chips.add(_facilityChip(Icons.wc, 'Toilet'));
  if (r.hasCharging) chips.add(_facilityChip(Icons.bolt, 'Charging'));
  if (chips.isEmpty) {
    return const Text(
      'No facilities reported',
      style: TextStyle(color: Colors.black54),
    );
  }
  return Wrap(children: chips);
}
