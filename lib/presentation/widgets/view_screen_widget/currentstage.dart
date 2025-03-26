import 'package:espoir_marketing/core/const.dart';
import 'package:flutter/material.dart';

class CurrentStage extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;

  CurrentStage({
    super.key,
    this.selectedValue,
    this.onChanged,
  });

  final List<Map<String, dynamic>> items = [
    {
      "value": "Following",
      "icon": Icons.remove_red_eye
    }, // Represents observation or tracking
    {
      "value": "Measured",
      "icon": Icons.linear_scale
    }, // Represents precision and measurement
    {
      "value": "Quoted",
      "icon": Icons.format_quote
    }, // Represents quoting or referencing
    {
      "value": "Advanced",
      "icon": Icons.business_center
    }, // Represents professional client services
    {
      "value": "Delivered",
      "icon": Icons.local_shipping
    }, // Represents delivery and logistics
    {
      "value": "Closed",
      "icon": Icons.check_circle
    }, // Represents completion or success
    {"value": "Failed", "icon": Icons.error}, // Represents failure or error
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 81, 81, 82),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 5,left: 5),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            hint: const Text(
              'Current stage',
              style: TextStyle(color: Color.fromARGB(255, 139, 139, 141)),
            ),
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 30,
            elevation: 16,
            style: const TextStyle(color: Colors.black, fontSize: 18),
            onChanged: onChanged,
            items: items
                .map<DropdownMenuItem<String>>((Map<String, dynamic> item) {
              return DropdownMenuItem<String>(
                value: item['value'],
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(item['icon'], color: icontheme),
                            const SizedBox(width: 10),
                            Text(item['value']),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
