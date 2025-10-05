import 'package:floodnavi/utils/report/sos_fields.dart';
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

  //SOS
  final String? phone;
  final int? peopleCount;
  final String? severity; // 'Low' | 'Medium' | 'High'
  final bool? medical;
  final bool? trapped;

  ReportFormResult({
    required this.type,
    required this.placeName,
    this.estCapacity = 0,
    this.currCapacity = 0,
    this.water = false,
    this.food = false,
    this.toilet = false,
    this.charging = false,
    this.access = '',
    this.details = '',

    //SOS
    this.phone,
    this.peopleCount,
    this.severity,
    this.medical,
    this.trapped,
  });
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

  final _sosPhoneCtrl = TextEditingController();
  final _sosPeopleCtrl = TextEditingController();

  String _sosSeverity = 'Medium';
  bool _sosMedical = false;
  bool _sosTrapped = false;

  // // Aid fields
  // final _aidOrgCtrl = TextEditingController();
  // final _aidNotesCtrl = TextEditingController();
  // final Set<String> _aidNeeds = {};

  late ReportType _type;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
  }

  @override
  void dispose() {
    _placeCtrl.dispose();
    _detailsCtrl.dispose();
    _estCapacityCtrl.dispose();
    _currCapacityCtrl.dispose();
    _accessCtrl.dispose();
    _sosPhoneCtrl.dispose();
    _sosPeopleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom; // keyboard
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: bottom),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Grab handle ---
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

                // ---- Type picker ----
                DropdownButtonFormField<ReportType>(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: ReportType.values
                      .map(
                        (t) => DropdownMenuItem(value: t, child: Text(t.label)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _type = v ?? _type),
                ),

                // ---- Common field ----
                TextFormField(
                  controller: _placeCtrl,
                  decoration: const InputDecoration(labelText: 'Place name'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),

                // ---- Type-specific fields (switch) ----
                const SizedBox(height: 8),
                _buildTypeSection(),

                const SizedBox(height: 8),
                const Text('Tip: Your report helps others find safety!'),

                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onSubmit,
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

  /// Chooses which block of inputs to render based on `_type`.
  Widget _buildTypeSection() {
    switch (_type) {
      case ReportType.shelter:
      case ReportType.highGround:
        return _buildShelterFields();

      case ReportType.aid:
        return _buildAidFields();

      case ReportType.sos:
        return SosFields(
          phoneController: _sosPhoneCtrl,
          peopleController: _sosPeopleCtrl,
          detailsController: _detailsCtrl,
          severity: _sosSeverity,
          medical: _sosMedical,
          trapped: _sosTrapped,
          onSeverityChanged: (v) => setState(() => _sosSeverity = v),
          onMedicalChanged: (v) => setState(() => _sosMedical = v),
          onTrappedChanged: (v) => setState(() => _sosTrapped = v),
        );
    }
  }

  /// Fields for Shelter / HighGround (your original ones)
  Widget _buildShelterFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _estCapacityCtrl,
          decoration: const InputDecoration(labelText: 'Estimated Capacity'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Capacity is required';
            final n = int.tryParse(value);
            if (n == null || n <= 0) return 'Enter a valid positive number';
            return null;
          },
        ),
        TextFormField(
          controller: _currCapacityCtrl,
          decoration: const InputDecoration(labelText: 'Current Capacity'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Capacity is required';
            final n = int.tryParse(value);
            if (n == null || n <= 0) return 'Enter a valid positive number';
            return null;
          },
        ),
        const SizedBox(height: 5),
        const Text('Facilities', style: TextStyle(fontSize: 16)),
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
          decoration: const InputDecoration(labelText: 'Accessibility:'),
          maxLines: 1,
        ),
        TextFormField(
          controller: _detailsCtrl,
          decoration: const InputDecoration(
            labelText: 'Additional Details (optional)',
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  /// Minimal example for Aid (customize as needed)
  Widget _buildAidFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // reuse details/access if you like
        TextFormField(
          controller: _detailsCtrl,
          decoration: const InputDecoration(labelText: 'Aid details / notes'),
          maxLines: 3,
        ),
        TextFormField(
          controller: _accessCtrl,
          decoration: const InputDecoration(
            labelText: 'Contact / Org (optional)',
          ),
        ),
      ],
    );
  }

  // /// Minimal example for SOS (phone, people, severity, flags, details)
  // Widget _buildSosFields() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       TextFormField(
  //         decoration: const InputDecoration(labelText: 'Contact Phone'),
  //         controller: _sosPhoneCtrl,
  //         keyboardType: TextInputType.phone,
  //         validator: (v) =>
  //             (v == null || v.trim().isEmpty) ? 'Phone is required' : null,
  //       ),
  //       TextFormField(
  //         decoration: const InputDecoration(labelText: 'People Count'),
  //         controller: _sosPeopleCtrl,
  //         keyboardType: TextInputType.number,
  //         validator: (v) {
  //           final n = int.tryParse(v ?? '');
  //           if (n == null || n <= 0) return 'Enter a valid number';
  //           return null;
  //         },
  //       ),
  //       DropdownButtonFormField<String>(
  //         value: _sosSeverity,
  //         decoration: const InputDecoration(labelText: 'Severity'),
  //         items: const ['Low', 'Medium', 'High']
  //             .map((s) => DropdownMenuItem(value: s, child: Text(s)))
  //             .toList(),
  //         onChanged: (v) => setState(() => _sosSeverity = (v ?? 'Medium')),
  //       ),
  //       CheckboxListTile(
  //         title: const Text('Medical Emergency'),
  //         value: _sosMedical,
  //         onChanged: (v) => setState(() => _sosMedical = v ?? false),
  //       ),
  //       CheckboxListTile(
  //         title: const Text('People Trapped / Need Rescue'),
  //         value: _sosTrapped,
  //         onChanged: (v) => setState(() => _sosTrapped = v ?? false),
  //       ),
  //       TextFormField(
  //         controller: _detailsCtrl,
  //         decoration: const InputDecoration(labelText: 'Details (optional)'),
  //         maxLines: 3,
  //       ),
  //     ],
  //   );
  // }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    // Defaults
    int est = 0, curr = 0;
    bool water = _water, food = _food, toilet = _toilet, charging = _charging;
    String access = _accessCtrl.text.trim();
    String details = _detailsCtrl.text.trim();

    // Only validate capacities for shelter/highGround
    if (_type == ReportType.shelter || _type == ReportType.highGround) {
      est = int.parse(_estCapacityCtrl.text.trim());
      curr = int.parse(_currCapacityCtrl.text.trim());
    }

    Navigator.pop(
      context,
      ReportFormResult(
        type: _type,
        placeName: _placeCtrl.text.trim(),
        estCapacity: est,
        currCapacity: curr,
        food: food, // keep your existing ordering
        water: water,
        toilet: toilet,
        charging: charging,
        access: access,
        details: details,
      ),
    );
  }
}
