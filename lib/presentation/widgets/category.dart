import 'package:espoir_marketing/core/const.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;

  CategoryWidget({
    super.key,
    this.selectedValue,
    this.onChanged,
  });

  final List<Map<String, dynamic>> items = [
    {"value": "Dealer", "text": "Dealer", "icon": Icons.store},
    {"value": "Contractor", "text": "Contractor", "icon": Icons.engineering},
    {"value": "Referral", "text": "Referral", "icon": Icons.group},
    {"value": "Direct Client", "text": "Direct Client", "icon": Icons.person},
    {"value": "Tenders", "text": "Tenders", "icon": Icons.assignment},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 245, 241, 251),
          border: Border.all(color: bordercolor, width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: const Text(
                'Category',
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
                              Text(item['text']),
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
      ),
    );
  }
}
