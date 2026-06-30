import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class FilePermissionService {

  static Future<bool> request() async {

    if (Platform.isAndroid) {

      final status =

          await Permission.storage.request();

      return status.isGranted;
    }

    return true;
  }
}