import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileCacheService {

  static Future<Directory> cacheDirectory()
  async {

    return getApplicationDocumentsDirectory();
  }

}