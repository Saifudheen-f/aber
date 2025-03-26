import 'package:espoir_marketing/core/const.dart';
import 'package:flutter/material.dart';

class TaskStatus extends StatelessWidget {
  final String? selectedStatus;
  final ValueChanged<String?> onStatusChanged;

  TaskStatus({
    required this.selectedStatus,
    required this.onStatusChanged,
    super.key,
  });
  final List<Map<String, String>> statusItems = [
    {'value': 'Started', 'text': 'Started'},
    {'value': 'On Going', 'text': 'On Going'},
    {'value': 'Completed', 'text': 'Completed'},
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Status:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: icontheme,
          ),
        ),
        const SizedBox(height: 10),
        ...statusItems.map((item) {
          return RadioListTile<String>(
            value: item['value']!,
            groupValue: selectedStatus,
            onChanged: onStatusChanged,
            title: Text(
              item['text']!,
              style: TextStyle(color: primaryColor),
            ),
            activeColor: icontheme,
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),
      ],
    );
  }
}
