import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfView extends StatelessWidget {
  const PdfView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pdf View')),
      body: PdfViewer.asset("lib/assets/sample.pdf"),
    );
  }
}
