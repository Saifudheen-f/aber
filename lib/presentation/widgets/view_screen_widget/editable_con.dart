import 'package:espoir_marketing/core/const.dart';
import 'package:flutter/material.dart';

class EditableInfoContainer extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FocusNode focusNode;

  const EditableInfoContainer({
    required this.title,
    required this.controller,
    required this.focusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:  TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: icontheme,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          style: const TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 3, 69, 122),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Colors.blueAccent, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Colors.blueAccent, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            suffixIcon:
                const Icon(Icons.edit, color: Color.fromARGB(255, 3, 5, 83)),
          ),
        ),
      ],
    );
  }
}