import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../data/models/CalculationModel.dart';
import '../presentation/bloc/calculation_history/CalculationHistoryBloc.dart';
import '../presentation/bloc/calculation_history/CalculationHistoryEvent.dart';
import '../utils/AppColors.dart';

class CalculationDetailScreen extends StatelessWidget {
  final CalculationModel calculation;

  const CalculationDetailScreen({Key? key, required this.calculation})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAlimony = calculation.type == CalculationType.alimony;
    final color = isAlimony ? AppColors.secondaryColor : AppColors.primaryColor;
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          isAlimony
              ? 'Alimony Calculation Details'
              : 'Dowry Calculation Details',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share functionality coming soon'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(context, color),

            const SizedBox(height: 24),

            if (isAlimony)
              _buildAlimonyDetails(context)
            else
              _buildDowryDetails(context),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calculation Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'ID:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Text(
                        calculation.id.substring(0, 8),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Date:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Text(
                        dateFormatter.format(calculation.timestamp),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Recalculate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Implement recalculation
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Recalculation feature coming soon'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Delete Calculation'),
                              content: const Text(
                                'Are you sure you want to delete this calculation?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(
                                      context,
                                    );

                                    context.read<CalculationHistoryBloc>().add(
                                      DeleteCalculation(calculation.id),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Calculation deleted'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'DELETE',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                calculation.type == CalculationType.alimony
                    ? Icons.balance
                    : Icons.favorite,
                color: color,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                calculation.type == CalculationType.alimony
                    ? 'Alimony Result'
                    : 'Dowry Result',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (calculation.type == CalculationType.alimony) ...[
            _buildResultRow(
              context,
              label: 'Spousal Maintenance:',
              value: '₹${calculation.inputData['alimonyAmount']?.toInt() ?? 0}',
              color: color,
              isMain: false,
            ),
            const SizedBox(height: 8),
            _buildResultRow(
              context,
              label: 'Child Support:',
              value:
                  '₹${calculation.inputData['childSupportAmount']?.toInt() ?? 0}',
              color: color,
              isMain: false,
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            _buildResultRow(
              context,
              label: 'Total Monthly Support:',
              value: '₹${calculation.result.toInt()}',
              color: color,
              isMain: true,
            ),
            const SizedBox(height: 12),
            Text(
              'Optional Lump Sum: ₹${calculation.inputData['lumpSumAmount']?.toInt() ?? 0}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ] else ...[
            Text(
              '₹${calculation.result.toInt()}',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            calculation.type == CalculationType.alimony
                ? 'This is an estimated alimony amount based on the provided information. The actual amount may vary based on legal jurisdiction, court decisions, and other relevant factors.'
                : 'This is an estimated dowry amount based on the provided information. The actual amount may vary based on cultural, regional, and personal factors.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
    required bool isMain,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isMain ? 17 : 15,
            fontWeight: isMain ? FontWeight.bold : FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isMain ? 22 : 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAlimonyDetails(BuildContext context) {
    final inputData = calculation.inputData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Marriage & Jurisdiction', Icons.gavel),
        _buildDetailsCard(context, [
          _buildDetailRow(
            context,
            'State/City',
            inputData['state'] ?? 'Not specified',
          ),
          _buildDetailRow(
            context,
            'Marriage Duration',
            inputData['marriageDuration'] ?? 'Not specified',
          ),
          _buildDetailRow(
            context,
            'Religion/Marriage Act',
            inputData['religion'] ?? 'Not specified',
          ),
        ]),

        const SizedBox(height: 16),

        _buildSectionHeader(
          context,
          'Spouses\' Income & Assets',
          Icons.account_balance_wallet,
        ),
        _buildDetailsCard(context, [
          _buildDetailRow(
            context,
            'Husband\'s Income',
            inputData['husbandIncome'] ?? 'Not specified',
          ),
          _buildDetailRow(
            context,
            'Wife\'s Income',
            inputData['wifeIncome'] ?? 'Not specified',
          ),
          _buildDetailRow(
            context,
            'Husband\'s Assets',
            inputData['husbandAssets'] ?? 'Not specified',
          ),
          _buildDetailRow(
            context,
            'Wife\'s Assets',
            inputData['wifeAssets'] ?? 'Not specified',
          ),
        ]),

        const SizedBox(height: 16),

        _buildSectionHeader(context, 'Financial Obligations', Icons.money_off),
        _buildDetailsCard(context, [
          _buildDetailRow(
            context,
            'Husband\'s Liabilities',
            inputData['husbandLiabilities'] ?? 'Not specified',
          ),
          _buildDetailRow(
            context,
            'Wife\'s Liabilities',
            inputData['wifeLiabilities'] ?? 'Not specified',
          ),
          _buildDetailRow(
            context,
            'Other Dependents',
            inputData['otherDependents'] ?? 'Not specified',
          ),
        ]),

        const SizedBox(height: 16),

        _buildSectionHeader(context, 'Children & Custody', Icons.child_care),
        _buildDetailsCard(context, [
          _buildDetailRow(
            context,
            'Children Count',
            inputData['childrenCount'] ?? 'Not specified',
          ),
          _buildDetailRow(
            context,
            'Children Ages',
            inputData['childrenAges'] ?? 'Not specified',
          ),
          _buildDetailRow(
            context,
            'Child Expenses',
            inputData['childExpenses'] ?? 'Not specified',
          ),
          _buildDetailRow(
            context,
            'Custody',
            inputData['custody'] ?? 'Not specified',
          ),
        ]),

        const SizedBox(height: 16),

        _buildSectionHeader(context, 'Standard of Living', Icons.house),
        _buildDetailsCard(context, [
          _buildDetailRow(
            context,
            'Household Expenses',
            inputData['householdExpenses'] ?? 'Not specified',
          ),
          _buildDetailRow(
            context,
            'Personal Expenses',
            inputData['personalExpenses'] ?? 'Not specified',
          ),
          _buildDetailRow(
            context,
            'Lifestyle',
            inputData['lifestyle'] ?? 'Not specified',
          ),
        ]),

        if (inputData.containsKey('wifeEmployment') ||
            inputData.containsKey('education') ||
            inputData.containsKey('careerSacrifices')) ...[
          const SizedBox(height: 16),

          _buildSectionHeader(context, 'Employment & Career', Icons.work),
          _buildDetailsCard(context, [
            if (inputData.containsKey('wifeEmployment'))
              _buildDetailRow(
                context,
                'Wife\'s Employment',
                inputData['wifeEmployment'],
              ),
            if (inputData.containsKey('education'))
              _buildDetailRow(context, 'Education', inputData['education']),
            if (inputData.containsKey('careerSacrifices'))
              _buildDetailRow(
                context,
                'Career Sacrifices',
                inputData['careerSacrifices'],
              ),
          ]),
        ],

        if (inputData.containsKey('husbandAge') ||
            inputData.containsKey('wifeAge') ||
            inputData.containsKey('healthIssues')) ...[
          const SizedBox(height: 16),

          _buildSectionHeader(context, 'Health & Age', Icons.favorite),
          _buildDetailsCard(context, [
            if (inputData.containsKey('husbandAge'))
              _buildDetailRow(
                context,
                'Husband\'s Age',
                inputData['husbandAge'],
              ),
            if (inputData.containsKey('wifeAge'))
              _buildDetailRow(context, 'Wife\'s Age', inputData['wifeAge']),
            if (inputData.containsKey('healthIssues'))
              _buildDetailRow(
                context,
                'Health Issues',
                inputData['healthIssues'],
              ),
          ]),
        ],

        if (inputData.containsKey('interimMaintenance') ||
            inputData.containsKey('legalExpenses')) ...[
          const SizedBox(height: 16),

          _buildSectionHeader(context, 'Legal Support', Icons.balance),
          _buildDetailsCard(context, [
            if (inputData.containsKey('interimMaintenance'))
              _buildDetailRow(
                context,
                'Interim Maintenance',
                inputData['interimMaintenance'],
              ),
            if (inputData.containsKey('legalExpenses'))
              _buildDetailRow(
                context,
                'Legal Expenses',
                inputData['legalExpenses'],
              ),
          ]),
        ],
      ],
    );
  }

  Widget _buildDowryDetails(BuildContext context) {
    final inputData = calculation.inputData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Personal Information', Icons.person),
        _buildDetailsCard(context, [
          if (inputData.containsKey('age'))
            _buildDetailRow(context, 'Age', inputData['age']),
          if (inputData.containsKey('profession'))
            _buildDetailRow(context, 'Profession', inputData['profession']),
          if (inputData.containsKey('education'))
            _buildDetailRow(context, 'Education', inputData['education']),
        ]),

        const SizedBox(height: 16),

        _buildSectionHeader(
          context,
          'Financial Information',
          Icons.account_balance_wallet,
        ),
        _buildDetailsCard(context, [
          if (inputData.containsKey('income'))
            _buildDetailRow(context, 'Monthly Income', inputData['income']),
          if (inputData.containsKey('familyAssets'))
            _buildDetailRow(
              context,
              'Family Assets',
              inputData['familyAssets'],
            ),
        ]),

        const SizedBox(height: 16),

        _buildSectionHeader(context, 'Location & Housing', Icons.home),
        _buildDetailsCard(context, [
          if (inputData.containsKey('state'))
            _buildDetailRow(context, 'State/City', inputData['state']),
          if (inputData.containsKey('country'))
            _buildDetailRow(context, 'Country', inputData['country']),
          if (inputData.containsKey('residence'))
            _buildDetailRow(context, 'Residence', inputData['residence']),
        ]),

      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final color =
        calculation.type == CalculationType.alimony
            ? AppColors.secondaryColor
            : AppColors.primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
