
import 'package:espoir_marketing/core/const.dart';
import 'package:espoir_marketing/presentation/widgets/followup_button.dart';
import 'package:flutter/material.dart';

class StatusSection extends StatelessWidget {
 
  final String? selectedStatus;
  final ValueChanged<String?> onStatusChanged;
  final DateTime? nextFollowDate;
  final VoidCallback pickFollowUpDate;

   StatusSection({
    
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.nextFollowDate,
    required this.pickFollowUpDate,
    super.key,
  });
final List<Map<String, String>> statusItems = [
    {'value': 'Follow Up', 'text': 'Follow Up'},
    {'value': 'Hold', 'text': 'Hold'},
    {'value': 'Closed', 'text': 'Closed'},
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
            color:icontheme,
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
              style:  TextStyle(color:icontheme),
            ),
            activeColor: icontheme,
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),
        if (selectedStatus == 'Follow Up')
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              FollowUpButton(
                nextFollowDate: nextFollowDate,
                pickFollowUpDate: pickFollowUpDate,
              ),
            ],
          ),
      ],
    );
  }
}