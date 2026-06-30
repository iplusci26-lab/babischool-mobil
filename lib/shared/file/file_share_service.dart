import 'dart:io';

import 'package:share_plus/share_plus.dart';

class FileShareService {

  static Future<void> share(

    File file,

  ) async {

    await SharePlus.instance.share(

      ShareParams(

        files: [

          XFile(

            file.path,
          )
        ],
      ),
    );
  }
}