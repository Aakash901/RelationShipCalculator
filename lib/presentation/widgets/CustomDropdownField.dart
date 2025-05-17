import 'package:flutter/material.dart';

import '../../utils/AppColors.dart';
class CustomDropdownField extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[50],
        filled: true,
      ),
      icon: const Icon(Icons.arrow_drop_down_circle_outlined),
      iconEnabledColor: AppColors.primaryColor,
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontSize: 16,
      ),
      dropdownColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[700]
          : Colors.white,
      borderRadius: BorderRadius.circular(16),
      validator: validator,
      isExpanded: true,
      hint: Text(
        'Select ${labelText.toLowerCase()}',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 16,
        ),
      ),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}