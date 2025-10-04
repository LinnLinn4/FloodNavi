import 'report.dart';
import 'package:flutter/material.dart';

class ReportFormResult {
  final ReportType type;
  final String placeName;
  final int estCapacity;
  final int currCapacity;
  final bool water;
  final bool food;
  final bool toilet;
  final bool charging;
  final String access;
  final String details;

  ReportFormResult(
    this.type,
    this.placeName,
    this.estCapacity,
    this.currCapacity,
    this.food,
    this.water,
    this.toilet,
    this.charging,
    this.access,
    this.details,
  );
}

class ReportForm extends StatefulWidget {
  const ReportForm({super.key, required this.initialType});
  final ReportType initialType;

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final _formKey = GlobalKey<FormState>();
  final _placeCtrl = TextEditingController();
  final _detailsCtrl = TextEditingController();
  final _estCapacityCtrl = TextEditingController();
  final _currCapacityCtrl = TextEditingController();
  final _accessCtrl = TextEditingController();
  bool _water = false;
  bool _food = false;
  bool _toilet = false;
  bool _charging = false;

  late ReportType _type;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType; // ✅ safe place
  }

  @override
  void dispose() {
    _placeCtrl.dispose();
    _detailsCtrl.dispose();
    _estCapacityCtrl.dispose();
    _currCapacityCtrl.dispose();
    _accessCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom; // keyboard
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Form(
            key: _formKey,
            child: Wrap(
              runSpacing: 12,
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
                const SizedBox(height: 4),
                const Text(
                  'New Report',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButtonFormField<ReportType>(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: ReportType.values.map((t) {
                    return DropdownMenuItem(value: t, child: Text(t.label));
                  }).toList(),
                  onChanged: (v) => setState(() => _type = v ?? _type),
                ),
                TextFormField(
                  controller: _placeCtrl,
                  decoration: const InputDecoration(labelText: 'Place name'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: _estCapacityCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Estimated Capacity',
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Capacity is required';
                    }
                    final n = int.tryParse(value);
                    if (n == null || n <= 0) {
                      return 'Enter a valid positive number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _currCapacityCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Current Capacity',
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Capacity is required';
                    }
                    final n = int.tryParse(value);
                    if (n == null || n <= 0) {
                      return 'Enter a valid positive number';
                    }
                    return null;
                  },
                ),
                Text('Facilities', style: TextStyle(fontSize: 14)),
                Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Dry Food'),
                      value: _food,
                      onChanged: (v) => setState(() => _food = v ?? false),
                    ),
                    CheckboxListTile(
                      title: const Text('Drinking Water'),
                      value: _water,
                      onChanged: (v) => setState(() => _water = v ?? false),
                    ),
                    CheckboxListTile(
                      title: const Text('Toilet'),
                      value: _toilet,
                      onChanged: (v) => setState(() => _toilet = v ?? false),
                    ),
                    CheckboxListTile(
                      title: const Text('Charging points'),
                      value: _charging,
                      onChanged: (v) => setState(() => _charging = v ?? false),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _accessCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Accessibility:',
                  ),
                  maxLines: 1,
                ),
                TextFormField(
                  controller: _detailsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Additional Details (optional)',
                  ),
                  maxLines: 3,
                ),
                Text('Tip: Your report helps others find safety!'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          final est = int.parse(_estCapacityCtrl.text.trim());
                          final curr = int.parse(_currCapacityCtrl.text.trim());
                          Navigator.pop(
                            context,
                            ReportFormResult(
                              _type,
                              _placeCtrl.text.trim(),
                              est,
                              curr,
                              _food,
                              _water,
                              _toilet,
                              _charging,
                              _accessCtrl.text.trim(),
                              _detailsCtrl.text.trim(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
