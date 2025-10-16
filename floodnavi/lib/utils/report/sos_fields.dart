import 'package:flutter/material.dart';

class SosFields extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController peopleController;
  final TextEditingController detailsController;
  final String severity;
  final bool medical;
  final bool trapped;
  final Function(String) onSeverityChanged;
  final Function(bool) onMedicalChanged;
  final Function(bool) onTrappedChanged;

  const SosFields({
    super.key,
    required this.phoneController,
    required this.peopleController,
    required this.detailsController,
    required this.severity,
    required this.medical,
    required this.trapped,
    required this.onSeverityChanged,
    required this.onMedicalChanged,
    required this.onTrappedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Contact Phone'),
          controller: phoneController,
          keyboardType: TextInputType.phone,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Phone is required' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'People Count'),
          controller: peopleController,
          keyboardType: TextInputType.number,
          validator: (v) {
            final n = int.tryParse(v ?? '');
            if (n == null || n <= 0) return 'Enter a valid number';
            return null;
          },
        ),
        DropdownButtonFormField<String>(
          value: severity,
          decoration: const InputDecoration(labelText: 'Severity'),
          items: const [
            'Low',
            'Medium',
            'High',
          ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (v) => onSeverityChanged(v ?? 'Medium'),
        ),
        CheckboxListTile(
          title: const Text('Medical Emergency'),
          value: medical,
          onChanged: (v) => onMedicalChanged(v ?? false),
        ),
        CheckboxListTile(
          title: const Text('People Trapped / Need Rescue'),
          value: trapped,
          onChanged: (v) => onTrappedChanged(v ?? false),
        ),
        TextFormField(
          controller: detailsController,
          decoration: const InputDecoration(labelText: 'Details (optional)'),
          maxLines: 3,
        ),
      ],
    );
  }
}
