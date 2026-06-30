import 'dart:io';

import 'package:dio/dio.dart';

import 'package:path_provider/path_provider.dart';

class FileDownloadService {

  static Future<File> download({

    required String url,

    required String filename,

  }) async {

    final directory =

        await getApplicationDocumentsDirectory();

    final file = File(

      "${directory.path}/$filename",

    );

    if (

      await file.exists()

    ) {

      return file;
    }

    await Dio().download(

      url,

      file.path,
    );

    return file;
  }
}