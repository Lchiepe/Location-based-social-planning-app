import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final double height;
  final RegExp validationRegEx;
  final bool obscureText;
  final void Function(String?) onSaved;

  const CustomFormField({super.key,
    required this.hintText,
    required this.validationRegEx,
    required this.onSaved,
    required this.height,

    this.obscureText= false,

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
      onSaved: onSaved,
      obscureText: obscureText ,
      validator: (value){
        if(value != null && validationRegEx.hasMatch(value)){
          return null;
        }
        return "enter a valid ${hintText.toLowerCase()}";
      },
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
      ),
      ),
    );
  }
}
