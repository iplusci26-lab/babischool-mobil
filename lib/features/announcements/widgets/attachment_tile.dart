import 'package:flutter/material.dart';

class AttachmentTile extends StatelessWidget {
  final String fileName;

  final VoidCallback onTap;

  const AttachmentTile({
    super.key,
    required this.fileName,
    required this.onTap,
  });

  IconData get icon {
    final extension =
        fileName.split(".").last.toLowerCase();

    switch (extension) {
      case "pdf":
        return Icons.picture_as_pdf;

      case "doc":
      case "docx":
        return Icons.description;

      case "xls":
      case "xlsx":
        return Icons.table_chart;

      case "jpg":
      case "jpeg":
      case "png":
        return Icons.image;

      default:
        return Icons.attach_file;
    }
  }

  Color get iconColor {
    final extension =
        fileName.split(".").last.toLowerCase();

    switch (extension) {
      case "pdf":
        return Colors.red;

      case "doc":
      case "docx":
        return Colors.blue;

      case "xls":
      case "xlsx":
        return Colors.green;

      case "jpg":
      case "jpeg":
      case "png":
        return Colors.deepPurple;

      default:
        return const Color(0xff6214BE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    iconColor.withOpacity(0.12),
                child: Icon(
                  icon,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pièce jointe",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fileName,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.open_in_new,
                color: Color(0xff6214BE),
              ),
            ],
          ),
        ),
      ),
    );
  }
}