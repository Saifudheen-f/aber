import 'package:espoir_marketing/core/const.dart';
import 'package:flutter/material.dart';

class ViewCategory extends StatelessWidget {
  final String requirement;

  const ViewCategory({required this.requirement, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: icontheme,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color.fromARGB(255, 81, 81, 82),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(_getIconForRequirement(requirement), color: icontheme),
              const SizedBox(width: 8),
              Text(
                requirement,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 1, 70, 126),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIconForRequirement(String category) {
    switch (category) {
      case 'Dealer':
        return Icons.store;
      case 'Contractor':
        return Icons.engineering;
      case 'Referral':
        return Icons.group;
      case 'Direct Client':
        return Icons.person;
      case 'Tenders':
        return Icons.assignment;
      default:
        return Icons.help_outline;
    }
  }
}
