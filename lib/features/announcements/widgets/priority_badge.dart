import 'package:flutter/material.dart';

class PriorityBadge extends StatelessWidget {
  final String priority;
 

  const PriorityBadge({
    super.key,
    required this.priority,
    
  });

  Color get backgroundColor {
    switch (priority) {
      case "urgent":
        return Colors.red.shade100;

      case "important":
        return Colors.orange.shade100;

      default:
        return Colors.green.shade100;
    }
  }

  Color get textColor {
    switch (priority) {
      case "urgent":
        return Colors.red.shade700;

      case "important":
        return Colors.orange.shade800;

      default:
        return Colors.green.shade700;
    }
  }

  IconData get icon {
    switch (priority) {
      case "urgent":
        return Icons.priority_high;

      case "important":
        return Icons.warning_amber_rounded;

      default:
        return Icons.campaign_outlined;
    }
  }

  String get label {
    switch (priority) {
      case "urgent":
        return "Urgent";

      case "important":
        return "Important";

      default:
        return "Normal";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: textColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}