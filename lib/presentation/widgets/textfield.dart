import 'package:flutter/material.dart';

import '../../core/const.dart';

class MyTextFied extends StatefulWidget {
  const MyTextFied({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.validator,
    this.maxlength,
    this.maxLine,
    this.minLines,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final int? maxlength;
  final int? maxLine;
  final int? minLines;
  final TextInputType? keyboardType;

  @override
  State<MyTextFied> createState() => _MyTextFiedState();
}

class _MyTextFiedState extends State<MyTextFied> {
  late bool obscure;

  @override
  void initState() {
    obscure = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: widget.validator,
        obscureText: obscure,
        controller: widget.controller,
        maxLength: widget.maxlength,
        maxLines: widget.maxLine,
        minLines: widget.minLines,
        keyboardType: widget.keyboardType,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
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
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 139, 139, 141)),
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                )
              : null,
          counterText: "",
        ),
      ),
    );
  }
}
 Widget buildTextField(
    TextEditingController controller,
    String hintText,
    bool obscureText, {
    int maxLines = 1,
    int minLines = 1,
    String? Function(String?)? validator,
    int? maxlength,
    TextInputType? keyboardType,
  }) {
    return MyTextFied(
      controller: controller,
      hintText: hintText,
      obscureText: obscureText,
      maxLine: maxLines,
      minLines: minLines,
      validator: validator,
      maxlength: maxlength,
      keyboardType: keyboardType,
    );
  }