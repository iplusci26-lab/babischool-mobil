import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {

  final String url;

  final String title;

  const PdfViewerScreen({

    super.key,

    required this.url,

    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(

          title,

          maxLines: 1,

          overflow: TextOverflow.ellipsis,
        ),

        actions: [

          IconButton(

            onPressed: () {

              // Bloc téléchargement
            },

            icon: const Icon(
              Icons.download,
            ),
          ),

          IconButton(

            onPressed: () {

              // Bloc partage
            },

            icon: const Icon(
              Icons.share,
            ),
          ),
        ],
      ),

      body: SfPdfViewer.network(

        url,

        canShowPaginationDialog: true,

        enableDoubleTapZooming: true,

        enableTextSelection: true,

        canShowScrollHead: true,

        canShowScrollStatus: true,
      ),
    );
  }
}