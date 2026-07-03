import 'dart:typed_data';

import 'package:dio/dio.dart';

class AttachmentModel {

  final String name;

  final String? path;

  final Uint8List bytes;

  final String mimeType;

  final int size;

  const AttachmentModel({

    required this.name,

    required this.bytes,

    this.path,

    required this.mimeType,

    required this.size,
  });

  bool get isImage =>
      mimeType.startsWith("image/");

  bool get isPdf =>
      mimeType == "application/pdf";

  bool get isAudio =>
      mimeType.startsWith("audio/");

  bool get isVideo =>
      mimeType.startsWith("video/");

  bool get isDocument =>
      !isImage &&
      !isPdf &&
      !isAudio &&
      !isVideo;

  String get formattedSize {

    if (size < 1024) {

      return "$size o";

    }

    if (size < 1024 * 1024) {

      return "${(size / 1024).toStringAsFixed(1)} KB";

    }

    return "${(size / 1024 / 1024).toStringAsFixed(1)} MB";
  }

  MultipartFile toMultipart() {

    return MultipartFile.fromBytes(

      bytes,

      filename: name,

      contentType: DioMediaType.parse(
        mimeType,
      ),
    );
  }
}