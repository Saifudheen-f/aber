import 'package:espoir_marketing/core/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

class PhoneNumber extends StatefulWidget {
  final TextEditingController controller; // Use external controller

 final String? Function(String?)? validator;
  PhoneNumber({super.key, required this.controller,this.validator});

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();

  Future<void> pickContact() async {
    Contact? contact = await _contactPicker.selectContact();
    if (contact != null && contact.phoneNumbers?.isNotEmpty == true) {
      String selectedNumber = contact.phoneNumbers!.first; // Get first number
      widget.controller.text = selectedNumber; // Update text field

     // widget.onPhoneNumberSelected(selectedNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        keyboardType: TextInputType.phone,
        maxLength: 15,
        decoration: InputDecoration(
          hintText: "Phone Number",
          suffixIcon: IconButton(
            onPressed: pickContact,
            icon: const Icon(Icons.person),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: bordercolor, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: fadesecondart, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          fillColor: const Color.fromARGB(255, 245, 241, 251),
          filled: true,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 139, 139, 141)),
          counterText: "",
        ),
      ),
    );
  }
}
