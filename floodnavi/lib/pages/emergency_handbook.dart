import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class EmergencyHandbookPage extends StatefulWidget {
  const EmergencyHandbookPage({super.key});

  @override
  State<EmergencyHandbookPage> createState() => _EmergencyHandbookPageState();
}

class _EmergencyHandbookPageState extends State<EmergencyHandbookPage> {
  bool _isDownloading = false;

  Future<void> _downloadPdf() async {
    try {
      setState(() => _isDownloading = true);

      // Get the downloads directory
      final directory = await getDownloadsDirectory();
      final filePath = '${directory?.path}/Emergency_Handbook.pdf';

      // Read the asset file
      final byteData = await DefaultAssetBundle.of(
        context,
      ).load('lib/assets/sample.pdf');
      final bytes = byteData.buffer.asUint8List();

      // Write to downloads folder
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Downloaded to: $filePath')));
        setState(() => _isDownloading = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Download failed: $e')));
        setState(() => _isDownloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Handbook'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: _isDownloading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: _downloadPdf,
                      tooltip: 'Download PDF',
                    ),
            ),
          ),
        ],
      ),
      body: SfPdfViewer.asset('lib/assets/sample.pdf'),
    );
  }
}
