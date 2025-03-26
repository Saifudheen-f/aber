
import 'package:espoir_marketing/core/decoration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FollowUpButton extends StatelessWidget {
  final DateTime? nextFollowDate;
  final VoidCallback pickFollowUpDate;

  const FollowUpButton({
    super.key,
    this.nextFollowDate,
    required this.pickFollowUpDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickFollowUpDate,
      child: Center(  // Wrap Container with Center widget
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: gradient
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_month, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  nextFollowDate == null
                      ? 'Pick Next Follow-Up Date'
                      : DateFormat('yyyy-MM-dd').format(nextFollowDate!),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
