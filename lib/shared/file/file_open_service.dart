import 'dart:io';

import 'package:open_filex/open_filex.dart';

class FileOpenService {

  static Future<void> open(

    File file,

  ) async {

    await OpenFilex.open(

      file.path,
    );
  }
}