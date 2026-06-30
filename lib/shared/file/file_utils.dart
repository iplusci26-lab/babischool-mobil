class FileUtils {

  static String humanSize(int bytes) {

    if (bytes < 1024) {

      return "$bytes o";
    }

    if (bytes < 1024 * 1024) {

      return "${(bytes / 1024).toStringAsFixed(1)} KB";
    }

    if (bytes < 1024 * 1024 * 1024) {

      return "${(bytes / 1024 / 1024).toStringAsFixed(1)} MB";
    }

    return "${(bytes / 1024 / 1024 / 1024).toStringAsFixed(1)} GB";
  }

  static bool isImage(String type) =>
      type == "image";

  static bool isPdf(String type) =>
      type == "pdf";

  static bool isAudio(String type) =>
      type == "audio";

  static bool isVideo(String type) =>
      type == "video";
}