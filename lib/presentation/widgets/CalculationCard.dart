// File: lib/presentation/widgets/CalculationCard.dart - With null safety
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/CalculationModel.dart';
import '../../utils/AppColors.dart';

class CalculationCard extends StatelessWidget {
  final CalculationModel calculation;

  const CalculationCard({Key? key, required this.calculation})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM dd, yyyy - HH:mm');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          calculation.type == CalculationType.dowry
                              ? AppColors.primaryColor.withOpacity(0.1)
                              : AppColors.secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      calculation.type == CalculationType.dowry
                          ? Icons.favorite
                          : Icons.account_balance,
                      color:
                          calculation.type == CalculationType.dowry
                              ? AppColors.primaryColor
                              : AppColors.secondaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    calculation.type == CalculationType.dowry
                        ? 'Dowry Calculation'
                        : 'Alimony Calculation',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                dateFormatter.format(calculation.timestamp),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          calculation.type == CalculationType.dowry
              ? _buildDowryDetails(context, calculation)
              : _buildAlimonyDetails(context, calculation),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Calculated Amount:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '₹${calculation.result.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      calculation.type == CalculationType.dowry
                          ? AppColors.primaryColor
                          : AppColors.secondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDowryDetails(
    BuildContext context,
    CalculationModel calculation,
  ) {
    final Map<String, dynamic> inputData = calculation.inputData;

    if (inputData.containsKey('husbandIncome') ||
        inputData.containsKey('state') ||
        inputData.containsKey('profession')) {
      return Column(
        children: [
          if (inputData.containsKey('profession'))
            _buildDetailRow(
              context,
              label: 'Profession',
              value: '${inputData['profession'] ?? 'Not specified'}',
            ),
          if (inputData.containsKey('monthlyIncome') ||
              inputData.containsKey('husbandIncome'))
            _buildDetailRow(
              context,
              label: 'Income',
              value:
                  '${inputData['monthlyIncome'] ?? inputData['husbandIncome'] ?? 'Not specified'}',
            ),
          if (inputData.containsKey('education') ||
              inputData.containsKey('educationLevel'))
            _buildDetailRow(
              context,
              label: 'Education',
              value:
                  '${inputData['education'] ?? inputData['educationLevel'] ?? 'Not specified'}',
            ),
          if (inputData.containsKey('residence'))
            _buildDetailRow(
              context,
              label: 'Residence',
              value: '${inputData['residence'] ?? 'Not specified'}',
            ),
          if (!inputData.containsKey('profession') &&
              !inputData.containsKey('monthlyIncome') &&
              !inputData.containsKey('husbandIncome') &&
              !inputData.containsKey('education') &&
              !inputData.containsKey('educationLevel') &&
              !inputData.containsKey('residence'))
            _buildDetailRow(
              context,
              label: 'Date Calculated',
              value: DateFormat('dd MMM yyyy').format(calculation.timestamp),
            ),
        ],
      );
    }

    return Column(
      children: [
        _buildSafeDetailRow(
          context,
          label: 'Monthly Income',
          value: inputData['income'],
          valueFormatter:
              (value) => '₹${(value as num?)?.toStringAsFixed(2) ?? 'N/A'}',
        ),
        const SizedBox(height: 8),
        _buildSafeDetailRow(
          context,
          label: 'Age',
          value: inputData['age'],
          valueFormatter: (value) => '${value ?? 'N/A'} years',
        ),
        const SizedBox(height: 8),
        _buildSafeDetailRow(
          context,
          label: 'Education Level',
          value: inputData['educationLevel'],
          valueFormatter:
              (value) =>
                  value != null
                      ? '${(value as num).toStringAsFixed(1)}/10'
                      : 'N/A',
        ),
        const SizedBox(height: 8),
        _buildSafeDetailRow(
          context,
          label: 'Family Assets',
          value: inputData['familyAssets'],
          valueFormatter:
              (value) => '₹${(value as num?)?.toStringAsFixed(2) ?? 'N/A'}',
        ),
      ],
    );
  }

  Widget _buildAlimonyDetails(
    BuildContext context,
    CalculationModel calculation,
  ) {
    final Map<String, dynamic> inputData = calculation.inputData;

    if (inputData.containsKey('state') ||
        inputData.containsKey('husbandIncome') ||
        inputData.containsKey('wifeIncome')) {
      return Column(
        children: [
          if (inputData.containsKey('husbandIncome'))
            _buildDetailRow(
              context,
              label: 'Husband\'s Income',
              value: '${inputData['husbandIncome'] ?? 'Not specified'}',
            ),
          if (inputData.containsKey('wifeIncome'))
            _buildDetailRow(
              context,
              label: 'Wife\'s Income',
              value: '${inputData['wifeIncome'] ?? 'Not specified'}',
            ),
          if (inputData.containsKey('marriageDuration'))
            _buildDetailRow(
              context,
              label: 'Marriage Duration',
              value: '${inputData['marriageDuration'] ?? 'Not specified'}',
            ),
          if (inputData.containsKey('childrenCount'))
            _buildDetailRow(
              context,
              label: 'Children',
              value: '${inputData['childrenCount'] ?? 'None'}',
            ),
          if (!inputData.containsKey('husbandIncome') &&
              !inputData.containsKey('wifeIncome') &&
              !inputData.containsKey('marriageDuration') &&
              !inputData.containsKey('childrenCount'))
            _buildDetailRow(
              context,
              label: 'Date Calculated',
              value: DateFormat('dd MMM yyyy').format(calculation.timestamp),
            ),
        ],
      );
    }
    return Column(
      children: [
        _buildSafeDetailRow(
          context,
          label: 'Payer Income',
          value: inputData['payerIncome'],
          valueFormatter:
              (value) => '₹${(value as num?)?.toStringAsFixed(2) ?? 'N/A'}',
        ),
        const SizedBox(height: 8),
        _buildSafeDetailRow(
          context,
          label: 'Receiver Income',
          value: inputData['receiverIncome'],
          valueFormatter:
              (value) => '₹${(value as num?)?.toStringAsFixed(2) ?? 'N/A'}',
        ),
        const SizedBox(height: 8),
        _buildSafeDetailRow(
          context,
          label: 'Marriage Duration',
          value: inputData['marriageDuration'],
          valueFormatter: (value) => value != null ? '$value years' : 'N/A',
        ),
        const SizedBox(height: 8),
        _buildSafeDetailRow(
          context,
          label: 'Children Count',
          value: inputData['childrenCount'],
          valueFormatter: (value) => '$value',
        ),
      ],
    );
  }

  Widget _buildSafeDetailRow(
    BuildContext context, {
    required String label,
    required dynamic value,
    required String Function(dynamic) valueFormatter,
  }) {
    final displayValue = value != null ? valueFormatter(value) : 'N/A';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(
          displayValue,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }
}
