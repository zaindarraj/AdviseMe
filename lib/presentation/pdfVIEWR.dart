
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewerScreen extends StatefulWidget {
  String pdf;
  PDFViewerScreen({super.key, required this.pdf});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(super.widget.pdf);
    return Scaffold(
      
        body: SizedBox(
          width: size.width,
          height: size.height,
      child: PDFView(
          enableSwipe: true,
  swipeHorizontal: true,
  autoSpacing: false,
  pageFling: false,
        filePath: super.widget.pdf,
      ),
    ));
  }
}
