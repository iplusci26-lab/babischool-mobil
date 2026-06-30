import 'dart:io';

import 'file_download_service.dart';
import 'file_open_service.dart';
import 'file_share_service.dart';

class FileManager {

  static Future<File> download({

    required String url,

    required String filename,

  }) {

    return FileDownloadService.download(

      url: url,

      filename: filename,
    );
  }

  static Future<void> open(File file) {

    return FileOpenService.open(file);
  }

  static Future<void> share(File file) {

    return FileShareService.share(file);
  }

}