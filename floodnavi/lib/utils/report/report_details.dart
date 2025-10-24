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
      initialChildSize: 0.40,
      minChildSize: 0.25,
      maxChildSize: 0.85,
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

              // Text(
              //   'Location: ${r.lat.toStringAsFixed(5)}, ${r.lng.toStringAsFixed(5)}',
              //   style: const TextStyle(color: Colors.black54),
              // ),
              // const SizedBox(height: 4),
              // Text(
              //   'Type: ${r.type.label}',
              //   style: const TextStyle(color: Colors.black54),
              // ),
              // Text(
              //   'Name: ${r.placeName}',
              //   style: const TextStyle(color: Colors.black54),
              // ),
              // Text(
              //   'Estimated Capacity: ${r.estCapacity} people',
              //   style: const TextStyle(color: Colors.black54),
              // ),
              // Text(
              //   'Available space: ${r.estCapacity - r.currCapacity} people',
              //   style: const TextStyle(color: Colors.black54),
              // ),
              // const Text('Facilities', style: TextStyle(color: Colors.black54)),
              // _facilitiesRow(r),
              // if (r.access.isNotEmpty)
              //   Text(
              //     'Accessibilities: ${r.access}',
              //     style: TextStyle(color: Colors.black54),
              //   ),
              // if (r.details.isNotEmpty)
              //   Text(r.details, style: TextStyle(color: Colors.black54)),
              _row('Type', r.type.label),
              _row(
                'Location',
                '${r.lat.toStringAsFixed(5)}, ${r.lng.toStringAsFixed(5)}',
              ),

              const SizedBox(height: 8),
              const Divider(),

              // Type-specific section
              _typeSpecificSection(r),

              if ((r.details).isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Notes',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(r.details, style: const TextStyle(color: Colors.black87)),
              ],

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
                  // Expanded(
                  //   child: ElevatedButton.icon(
                  //     onPressed: () {
                  //       //open external maps or route
                  //     },
                  //     icon: const Icon(Icons.directions),
                  //     label: const Text('Directions'),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.green,
                  //       foregroundColor: Colors.white,
                  //     ),
                  //   ),
                  // ),
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

Widget _typeSpecificSection(Report r) {
  switch (r.type) {
    case ReportType.shelter:
    case ReportType.highGround:
      final available = (r.estCapacity - r.currCapacity).clamp(-999999, 999999);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('Estimated Capacity', '${r.estCapacity} people'),
          _row('Current Capacity', '${r.currCapacity} people'),
          _row('Available Space', '$available people'),
          if (r.access.isNotEmpty) _row('Accessibility', r.access),
          const SizedBox(height: 8),
          const Text(
            'Facilities',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          _facilitiesRow(r),
        ],
      );

    case ReportType.aid:
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (r.access.isNotEmpty) _row('Contact / Org', r.access),
          if (r.details.isEmpty)
            const Text(
              'No additional notes',
              style: TextStyle(color: Colors.black54),
            ),
        ],
      );

    case ReportType.sos:
      // Assumes these fields exist in your Report model (nullable for others):
      // phone (String?), peopleCount (int?), severity (String?),
      // medical (bool?), trapped (bool?)
      final sev = r.severity ?? '—';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('Contact Phone', r.phone?.isNotEmpty == true ? r.phone! : '—'),
          _row('People Count', (r.peopleCount?.toString() ?? '—')),
          _row('Severity', sev),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _statusChip(
                Icons.medical_services,
                'Medical Emergency',
                r.medical == true,
              ),
              _statusChip(
                Icons.hail,
                'Trapped / Need Rescue',
                r.trapped == true,
              ),
            ],
          ),
        ],
      );
  }
}

Widget _row(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87, fontSize: 14),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: value),
        ],
      ),
    ),
  );
}

Widget _statusChip(IconData icon, String label, bool on) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: (on ? Colors.red : Colors.grey).withOpacity(0.08),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: (on ? Colors.red : Colors.grey).withOpacity(0.25),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: on ? Colors.red : Colors.grey),
        const SizedBox(width: 6),
        Text(label),
      ],
    ),
  );
}
