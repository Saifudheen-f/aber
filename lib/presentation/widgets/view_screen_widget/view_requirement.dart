import 'package:espoir_marketing/core/const.dart';
import 'package:flutter/material.dart';

class RequirementContainer extends StatelessWidget {
  final String requirement;

  const RequirementContainer({required this.requirement, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requirement',
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

  IconData _getIconForRequirement(String requirement) {
    switch (requirement) {
      case 'Door':
        return Icons.door_front_door;
      case 'Windows':
        return Icons.window;
      case 'Customised':
        return Icons.build;
      case 'All':
        return Icons.select_all;
      default:
        return Icons.help_outline;
    }
  }
}
