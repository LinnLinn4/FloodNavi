import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// Emergency Handbook PDF Page
class EmergencyHandbookPage extends StatelessWidget {
  const EmergencyHandbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Handbook')),
      body: SfPdfViewer.asset(
        'assets/sample.pdf',
      ), // Update this path if your PDF is elsewhere
    );
  }
}
