// File: lib/presentation/widgets/result_display.dart (fixed)
import 'package:flutter/material.dart';
import '../../data/models/CalculationModel.dart';
import '../../utils/AppColors.dart';

class ResultDisplay extends StatelessWidget {
  final double result;
  final CalculationType type;

  const ResultDisplay({
    Key? key,
    required this.result,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = type == CalculationType.dowry
        ? AppColors.primaryColor
        : AppColors.secondaryColor;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                type == CalculationType.dowry
                    ? Icons.favorite
                    : Icons.account_balance,
                color: primaryColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                type == CalculationType.dowry
                    ? 'Dowry Calculation Result'
                    : 'Alimony Calculation Result',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "₹${result.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _getResultDescription(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  String _getResultDescription() {
    if (type == CalculationType.dowry) {
      return 'This is an estimated dowry amount based on the provided information. The actual amount may vary based on cultural, regional, and personal factors.';
    } else {
      return 'This is an estimated alimony amount based on the provided information. The actual amount may vary based on legal jurisdiction, court decisions, and other relevant factors.';
    }
  }
}