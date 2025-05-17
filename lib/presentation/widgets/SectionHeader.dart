import 'package:flutter/material.dart';

import '../../utils/AppColors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionHeader({Key? key, required this.title, required this.icon})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: AppColors.secondaryColor, width: 4),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondaryColor, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
