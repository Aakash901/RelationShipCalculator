import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/AppColors.dart';

class CustomNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final String hintText;
  final String? Function(String?)? validator;

  const CustomNumberField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    required this.hintText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
      ],
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),
      ),
      validator: validator,
    );
  }
}