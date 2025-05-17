import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/CalculationModel.dart';
import '../presentation/bloc/calculation_history/CalculationHistoryBloc.dart';
import '../presentation/bloc/calculation_history/CalculationHistoryEvent.dart';
import '../presentation/widgets/CustomDropdownField.dart';
import '../presentation/widgets/SectionHeader.dart';
import '../utils/AppColors.dart';

class AlimonyCalculatorScreen extends StatefulWidget {
  const AlimonyCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<AlimonyCalculatorScreen> createState() =>
      _AlimonyCalculatorScreenState();
}

class _AlimonyCalculatorScreenState extends State<AlimonyCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedState;
  String? _selectedMarriageDuration;
  String? _selectedReligion;

  String? _selectedHusbandIncome;
  String? _selectedWifeIncome;
  String? _selectedHusbandAssets;
  String? _selectedWifeAssets;

  String? _selectedHusbandLiabilities;
  String? _selectedWifeLiabilities;
  String? _selectedOtherDependents;
  String? _selectedChildrenCount;
  String? _selectedChildrenAges;
  String? _selectedChildExpenses;
  String? _selectedCustody;

  String? _selectedHouseholdExpenses;
  String? _selectedPersonalExpenses;
  String? _selectedLifestyle;
  String? _selectedWifeEmployment;
  String? _selectedEducation;
  String? _selectedCareerSacrifices;

  String? _selectedHusbandAge;
  String? _selectedWifeAge;
  String? _selectedHealthIssues;

  String? _selectedInterimMaintenance;
  String? _selectedLegalExpenses;

  bool _isCalculated = false;
  double _monthlyAlimony = 0.0;
  double _childSupport = 0.0;
  double _lumpSum = 0.0;
  final List<String> _stateOptions = [
    'Delhi NCR',
    'Mumbai',
    'Bangalore',
    'Chennai',
    'Kolkata',
    'Hyderabad',
    'Pune',
    'Ahmedabad',
    'Chandigarh',
    'Jaipur',
    'Other Tier 1 City',
    'Tier 2 City',
    'Tier 3 City/Town',
  ];

  final List<String> _marriageDurationOptions = [
    'Less than 1 year',
    '1-3 years',
    '3-5 years',
    '5-10 years',
    '10-15 years',
    '15-20 years',
    'More than 20 years',
  ];

  final List<String> _religionOptions = [
    'Hindu Marriage Act',
    'Special Marriage Act',
    'Muslim Personal Law',
    'Christian Marriage Act',
    'Parsi Marriage Act',
    'Goa Civil Code',
    'Other',
  ];
  final List<String> _incomeOptions = [
    'No Income',
    'Less than ₹25,000',
    '₹25,000 - ₹50,000',
    '₹50,000 - ₹1 lakh',
    '₹1 lakh - ₹2 lakhs',
    '₹2 lakhs - ₹5 lakhs',
    'More than ₹5 lakhs',
  ];

  final List<String> _assetsOptions = [
    'No Significant Assets',
    'Less than ₹25 lakhs',
    '₹25 lakhs - ₹50 lakhs',
    '₹50 lakhs - ₹1 crore',
    '₹1 crore - ₹5 crores',
    'More than ₹5 crores',
  ];
  final List<String> _liabilitiesOptions = [
    'No Liabilities',
    'Less than ₹10,000',
    '₹10,000 - ₹25,000',
    '₹25,000 - ₹50,000',
    '₹50,000 - ₹1 lakh',
    'More than ₹1 lakh',
  ];

  final List<String> _dependentsOptions = [
    'No Other Dependents',
    '1 Dependent',
    '2 Dependents',
    '3 Dependents',
    '4 or More Dependents',
  ];

  final List<String> _childrenCountOptions = [
    'No Children',
    '1 Child',
    '2 Children',
    '3 Children',
    '4 or More Children',
  ];

  final List<String> _childrenAgesOptions = [
    'Not Applicable',
    'All Below 5 Years',
    'Between 5-10 Years',
    'Between 10-15 Years',
    'Between 15-18 Years',
    'Mixed Age Groups',
  ];

  final List<String> _childExpensesOptions = [
    'Not Applicable',
    'Less than ₹10,000',
    '₹10,000 - ₹25,000',
    '₹25,000 - ₹50,000',
    '₹50,000 - ₹1 lakh',
    'More than ₹1 lakh',
  ];

  final List<String> _custodyOptions = [
    'Not Applicable',
    'Wife has Primary Custody',
    'Husband has Primary Custody',
    'Joint Custody',
    'To Be Determined',
  ];

  final List<String> _wifeEmploymentOptions = [
    'Unemployed',
    'Employed (Part-time)',
    'Employed (Full-time)',
    'Self-employed',
    'Homemaker by Choice',
    'Unable to Work',
  ];

  final List<String> _educationOptions = [
    'Below 10th Standard',
    '10th Standard',
    '12th Standard',
    'Graduate',
    'Post-Graduate',
    'Professional Degree (MD/Engineering/Law)',
    'PhD or Higher',
  ];

  final List<String> _careerSacrificesOptions = [
    'No Sacrifices Made',
    'Changed Jobs for Marriage',
    'Took Career Break',
    'Gave Up Career Completely',
    'Relocated Abandoning Career',
    'Not Applicable',
  ];

  final List<String> _ageOptions = [
    'Below 25 years',
    '25-30 years',
    '31-40 years',
    '41-50 years',
    '51-60 years',
    'Above 60 years',
  ];

  final List<String> _healthIssuesOptions = [
    'No Major Health Issues',
    'Wife has Health Issues',
    'Husband has Health Issues',
    'Both have Health Issues',
    'Child has Special Needs',
  ];

  final List<String> _maintenanceOptions = [
    'None',
    'Less than ₹10,000',
    '₹10,000 - ₹25,000',
    '₹25,000 - ₹50,000',
    'More than ₹50,000',
  ];

  final List<String> _legalExpensesOptions = [
    'Minimal (< ₹50,000)',
    'Moderate (₹50,000 - ₹2 lakhs)',
    'Significant (₹2 lakhs - ₹5 lakhs)',
    'High (₹5 lakhs - ₹10 lakhs)',
    'Very High (> ₹10 lakhs)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'Alimony Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.secondaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.secondaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Estimate Alimony & Child Support',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This calculator provides an estimate based on Indian legal precedents. Actual amounts vary by court decision. Select options from all categories for the most accurate estimate.',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const SectionHeader(
                  title: 'Marriage & Jurisdiction',
                  icon: Icons.gavel,
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'State / City',
                  prefixIcon: Icons.location_city,
                  value: _selectedState,
                  items: _stateOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedState = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a state/city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Duration of Marriage',
                  prefixIcon: Icons.timer,
                  value: _selectedMarriageDuration,
                  items: _marriageDurationOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedMarriageDuration = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select marriage duration';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Religion / Marriage Act',
                  prefixIcon: Icons.book,
                  value: _selectedReligion,
                  items: _religionOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedReligion = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select religion/marriage act';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                const SectionHeader(
                  title: 'Spouses\' Income & Assets',
                  icon: Icons.account_balance_wallet,
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Husband\'s Net Monthly Income',
                  prefixIcon: Icons.person,
                  value: _selectedHusbandIncome,
                  items: _incomeOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedHusbandIncome = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select husband\'s income';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Wife\'s Net Monthly Income',
                  prefixIcon: Icons.person,
                  value: _selectedWifeIncome,
                  items: _incomeOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedWifeIncome = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select wife\'s income';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdownField(
                  labelText: 'Husband\'s Major Assets',
                  prefixIcon: Icons.home,
                  value: _selectedHusbandAssets,
                  items: _assetsOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedHusbandAssets = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select husband\'s assets';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Wife\'s Major Assets',
                  prefixIcon: Icons.home,
                  value: _selectedWifeAssets,
                  items: _assetsOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedWifeAssets = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select wife\'s assets';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const SectionHeader(
                  title: 'Financial Obligations & Liabilities',
                  icon: Icons.money_off,
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Husband\'s Monthly Liabilities',
                  prefixIcon: Icons.currency_rupee,
                  value: _selectedHusbandLiabilities,
                  items: _liabilitiesOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedHusbandLiabilities = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select husband\'s liabilities';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Wife\'s Monthly Liabilities',
                  prefixIcon: Icons.currency_rupee,
                  value: _selectedWifeLiabilities,
                  items: _liabilitiesOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedWifeLiabilities = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select wife\'s liabilities';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Number of Other Dependents',
                  prefixIcon: Icons.people,
                  value: _selectedOtherDependents,
                  items: _dependentsOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedOtherDependents = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select number of dependents';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const SectionHeader(
                  title: 'Children & Custody',
                  icon: Icons.child_care,
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Number of Minor Children',
                  prefixIcon: Icons.family_restroom,
                  value: _selectedChildrenCount,
                  items: _childrenCountOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedChildrenCount = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select number of children';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Ages of Children',
                  prefixIcon: Icons.cake,
                  value: _selectedChildrenAges,
                  items: _childrenAgesOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedChildrenAges = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select children ages';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Estimated Child-Related Expenses',
                  prefixIcon: Icons.school,
                  value: _selectedChildExpenses,
                  items: _childExpensesOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedChildExpenses = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select child expenses';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Custody Arrangement',
                  prefixIcon: Icons.home_filled,
                  value: _selectedCustody,
                  items: _custodyOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedCustody = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select custody arrangement';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const SectionHeader(
                  title: 'Standard of Living / Expenses',
                  icon: Icons.house,
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Household Expenses',
                  prefixIcon: Icons.shopping_cart,
                  value: _selectedHouseholdExpenses,
                  items: const [
                    'Less than ₹15,000',
                    '₹15,000 - ₹30,000',
                    '₹30,000 - ₹50,000',
                    '₹50,000 - ₹1 lakh',
                    'More than ₹1 lakh',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedHouseholdExpenses = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select household expenses';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Monthly Personal Expenses',
                  prefixIcon: Icons.shopping_bag,
                  value: _selectedPersonalExpenses,
                  items: const [
                    'Less than ₹5,000',
                    '₹5,000 - ₹15,000',
                    '₹15,000 - ₹30,000',
                    '₹30,000 - ₹50,000',
                    'More than ₹50,000',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedPersonalExpenses = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select personal expenses';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Lifestyle Indicators',
                  prefixIcon: Icons.airline_seat_flat,
                  value: _selectedLifestyle,
                  items: const [
                    'Modest',
                    'Middle-class',
                    'Upper Middle-class',
                    'Affluent',
                    'Elite',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedLifestyle = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select lifestyle indicator';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const SectionHeader(
                  title: 'Employment & Career Factors',
                  icon: Icons.work,
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Wife\'s Employment Status',
                  prefixIcon: Icons.business_center,
                  value: _selectedWifeEmployment,
                  items: _wifeEmploymentOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedWifeEmployment = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select employment status';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Educational Qualification',
                  prefixIcon: Icons.school,
                  value: _selectedEducation,
                  items: _educationOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedEducation = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select educational qualification';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Career Sacrifices for Marriage',
                  prefixIcon: Icons.psychology,
                  value: _selectedCareerSacrifices,
                  items: _careerSacrificesOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedCareerSacrifices = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select career sacrifices';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const SectionHeader(
                  title: 'Health & Age',
                  icon: Icons.favorite,
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Husband\'s Age',
                  prefixIcon: Icons.person_outline,
                  value: _selectedHusbandAge,
                  items: _ageOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedHusbandAge = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select husband\'s age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Wife\'s Age',
                  prefixIcon: Icons.person_outline,
                  value: _selectedWifeAge,
                  items: _ageOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedWifeAge = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select wife\'s age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Major Health Issues',
                  prefixIcon: Icons.medical_services,
                  value: _selectedHealthIssues,
                  items: _healthIssuesOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedHealthIssues = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select health issues';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const SectionHeader(
                  title: 'Existing Support & Legal Costs',
                  icon: Icons.balance,
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Interim Maintenance Already Received',
                  prefixIcon: Icons.payments,
                  value: _selectedInterimMaintenance,
                  items: _maintenanceOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedInterimMaintenance = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select interim maintenance';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Expected Legal Expenses',
                  prefixIcon: Icons.description,
                  value: _selectedLegalExpenses,
                  items: _legalExpensesOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedLegalExpenses = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select legal expenses';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _calculateAlimony,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Calculate Alimony',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildAlimonyResults(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _calculateAlimony() {
    print("Calculate button pressed");
    print("Form validation result: ${_formKey.currentState?.validate()}");

    if (_formKey.currentState == null) {
      print("ERROR: Form key current state is null");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Internal error: Form state is null'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      print("Form validation passed");
      try {
        List<String> missingFields = [];

        if (_selectedState == null) {
          print("Missing: State/City");
          missingFields.add('State/City');
        }
        if (_selectedMarriageDuration == null) {
          print("Missing: Marriage Duration");
          missingFields.add('Marriage Duration');
        }
        if (_selectedReligion == null) {
          print("Missing: Religion/Marriage Act");
          missingFields.add('Religion/Marriage Act');
        }
        if (_selectedHusbandIncome == null) {
          print("Missing: Husband's Income");
          missingFields.add('Husband\'s Income');
        }
        if (_selectedWifeIncome == null) {
          print("Missing: Wife's Income");
          missingFields.add('Wife\'s Income');
        }
        if (_selectedHusbandAssets == null) {
          print("Missing: Husband's Assets");
          missingFields.add('Husband\'s Assets');
        }
        if (_selectedWifeAssets == null) {
          print("Missing: Wife's Assets");
          missingFields.add('Wife\'s Assets');
        }
        if (_selectedHusbandLiabilities == null) {
          print("Missing: Husband's Liabilities");
          missingFields.add('Husband\'s Liabilities');
        }
        if (_selectedWifeLiabilities == null) {
          print("Missing: Wife's Liabilities");
          missingFields.add('Wife\'s Liabilities');
        }
        if (_selectedOtherDependents == null) {
          print("Missing: Other Dependents");
          missingFields.add('Other Dependents');
        }
        if (_selectedChildrenCount == null) {
          print("Missing: Number of Children");
          missingFields.add('Number of Children');
        }
        if (_selectedChildrenAges == null) {
          print("Missing: Children's Ages");
          missingFields.add('Children\'s Ages');
        }
        if (_selectedChildExpenses == null) {
          print("Missing: Child Expenses");
          missingFields.add('Child Expenses');
        }
        if (_selectedCustody == null) {
          print("Missing: Custody Arrangement");
          missingFields.add('Custody Arrangement');
        }
        if (_selectedHouseholdExpenses == null) {
          print("Missing: Household Expenses");
          missingFields.add('Household Expenses');
        }
        if (_selectedPersonalExpenses == null) {
          print("Missing: Personal Expenses");
          missingFields.add('Personal Expenses');
        }
        if (_selectedLifestyle == null) {
          print("Missing: Lifestyle");
          missingFields.add('Lifestyle');
        }

        if (missingFields.isNotEmpty) {
          print("Missing fields found: ${missingFields.length}");
          String errorMsg =
              'Please fill in the following fields: ${missingFields.join(", ")}';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );

          return;
        }

        print("All required fields are present, proceeding with calculation");

        final husbandIncome = _getIncomeValue(_selectedHusbandIncome!);
        print("Husband's Income: $husbandIncome");

        final wifeIncome = _getIncomeValue(_selectedWifeIncome!);
        print("Wife's Income: $wifeIncome");

        final husbandLiabilities = _getLiabilitiesValue(
          _selectedHusbandLiabilities!,
        );
        print("Husband's Liabilities: $husbandLiabilities");

        final wifeLiabilities = _getLiabilitiesValue(_selectedWifeLiabilities!);
        print("Wife's Liabilities: $wifeLiabilities");

        final marriageDurationFactor = _getMarriageDurationFactor(
          _selectedMarriageDuration!,
        );
        print("Marriage Duration Factor: $marriageDurationFactor");

        final childrenFactor = _getChildrenFactor(
          _selectedChildrenCount!,
          _selectedChildExpenses!,
        );
        print("Children Factor: $childrenFactor");

        final custodyFactor = _getCustodyFactor(_selectedCustody!);
        print("Custody Factor: $custodyFactor");

        final careerSacrificeFactor =
            _selectedCareerSacrifices != null
                ? _getCareerSacrificeFactor(_selectedCareerSacrifices!)
                : 1.0;
        print("Career Sacrifice Factor: $careerSacrificeFactor");

        final lifestyleFactor = _getLifestyleFactor(_selectedLifestyle!);
        print("Lifestyle Factor: $lifestyleFactor");

        final healthFactor =
            _selectedHealthIssues != null
                ? _getHealthFactor(_selectedHealthIssues!)
                : 1.0;
        print("Health Factor: $healthFactor");

        final husbandNetIncome = husbandIncome - husbandLiabilities;
        print("Husband's Net Income: $husbandNetIncome");

        if (husbandNetIncome <= 0) {
          print(
            "ERROR: Husband's net income is zero or negative: $husbandNetIncome",
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Husband\'s net income is zero or negative after liabilities. Alimony calculation not possible.',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        double baseAlimony = husbandNetIncome * 0.25;
        print("Initial Base Alimony (25% of net income): $baseAlimony");

        baseAlimony *= marriageDurationFactor;
        print("After marriage duration adjustment: $baseAlimony");

        baseAlimony *= careerSacrificeFactor;
        print("After career sacrifice adjustment: $baseAlimony");

        baseAlimony *= healthFactor;
        print("After health factor adjustment: $baseAlimony");

        if (wifeIncome > 0) {
          final wifeNetIncome = wifeIncome - wifeLiabilities;
          print("Wife's Net Income: $wifeNetIncome");

          final incomeRatio = wifeNetIncome / husbandNetIncome;
          print("Income Ratio (wife/husband): $incomeRatio");

          final reductionFactor = incomeRatio < 0.7 ? incomeRatio : 0.7;
          print("Reduction Factor: $reductionFactor");

          baseAlimony *= (1 - reductionFactor);
          print("After wife's income adjustment: $baseAlimony");
        }

        final minimumLiving = _getMinimumLivingValue(_selectedLifestyle!);
        print("Minimum Living Standard: $minimumLiving");

        if (baseAlimony < minimumLiving &&
            husbandNetIncome > minimumLiving * 2) {
          print("Adjusting to minimum living standard");
          baseAlimony = minimumLiving;
        }

        double childSupport = 0.0;
        if (_selectedChildrenCount != 'No Children') {
          final childExpensesValue = _getChildExpensesValue(
            _selectedChildExpenses!,
          );
          print("Child Expenses Value: $childExpensesValue");

          childSupport = childExpensesValue * childrenFactor * custodyFactor;
          print("Calculated Child Support: $childSupport");
        }

        final lumpSumYears = marriageDurationFactor * 3;
        print("Lump Sum Years: $lumpSumYears");

        _lumpSum = (baseAlimony + childSupport) * 12 * lumpSumYears;
        print("Calculated Lump Sum: $_lumpSum");

        _monthlyAlimony = baseAlimony.roundToDouble();
        _childSupport = childSupport.roundToDouble();
        print("Final Monthly Alimony: $_monthlyAlimony");
        print("Final Child Support: $_childSupport");

        setState(() {
          _isCalculated = true;
          print("State updated: _isCalculated = $_isCalculated");
        });

        Map<String, dynamic> inputData = {
          'state': _selectedState,
          'marriageDuration': _selectedMarriageDuration,
          'religion': _selectedReligion,

          'husbandIncome': _selectedHusbandIncome,
          'wifeIncome': _selectedWifeIncome,
          'husbandAssets': _selectedHusbandAssets,
          'wifeAssets': _selectedWifeAssets,

          'husbandLiabilities': _selectedHusbandLiabilities,
          'wifeLiabilities': _selectedWifeLiabilities,
          'otherDependents': _selectedOtherDependents,

          'childrenCount': _selectedChildrenCount,
          'childrenAges': _selectedChildrenAges,
          'childExpenses': _selectedChildExpenses,
          'custody': _selectedCustody,

          'householdExpenses': _selectedHouseholdExpenses,
          'personalExpenses': _selectedPersonalExpenses,
          'lifestyle': _selectedLifestyle,

          'wifeEmployment': _selectedWifeEmployment,
          'education': _selectedEducation,
          'careerSacrifices': _selectedCareerSacrifices,
          'husbandAge': _selectedHusbandAge,
          'wifeAge': _selectedWifeAge,
          'healthIssues': _selectedHealthIssues,
          'interimMaintenance': _selectedInterimMaintenance,
          'legalExpenses': _selectedLegalExpenses,

          'alimonyAmount': _monthlyAlimony,
          'childSupportAmount': _childSupport,
          'lumpSumAmount': _lumpSum,
          'calculationTimestamp': DateTime.now().toIso8601String(),
        };
        final calculation = CalculationModel(
          type: CalculationType.alimony,
          inputData: inputData,
          result: _monthlyAlimony + _childSupport,
        );

        print("Saving to history: ${calculation.id}");
        print("Total amount: ${calculation.result}");
        print("Input data keys: ${inputData.keys.toList()}");

        try {
          context.read<CalculationHistoryBloc>().add(
            AddCalculation(calculation),
          );
          print("Calculation added to history successfully");
        } catch (e) {
          print("ERROR adding calculation to history: $e");
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alimony calculated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error calculating alimony: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the validation errors in the form'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildAlimonyResults() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.balance, color: AppColors.secondaryColor, size: 28),
              const SizedBox(width: 12),
              Text(
                'Estimated Maintenance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Spousal Maintenance:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '₹${_monthlyAlimony.toInt()}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'per month',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Child Support:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '₹${_childSupport.toInt()}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'per month',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Monthly Support:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '₹${(_monthlyAlimony + _childSupport).toInt()}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Optional Lump Sum:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '₹${_lumpSum.toInt()}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'This is a one-time payment option that may be considered in lieu of monthly payments.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Note: This is an estimate based on the provided information. Actual alimony and child support amounts are determined by the court and may vary.',
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  double _getIncomeValue(String income) {
    switch (income) {
      case 'No Income':
        return 0;
      case 'Less than ₹25,000':
        return 20000;
      case '₹25,000 - ₹50,000':
        return 37500;
      case '₹50,000 - ₹1 lakh':
        return 75000;
      case '₹1 lakh - ₹2 lakhs':
        return 150000;
      case '₹2 lakhs - ₹5 lakhs':
        return 350000;
      case 'More than ₹5 lakhs':
        return 750000;
      default:
        return 0;
    }
  }

  double _getLiabilitiesValue(String liabilities) {
    switch (liabilities) {
      case 'No Liabilities':
        return 0;
      case 'Less than ₹10,000':
        return 5000;
      case '₹10,000 - ₹25,000':
        return 17500;
      case '₹25,000 - ₹50,000':
        return 37500;
      case '₹50,000 - ₹1 lakh':
        return 75000;
      case 'More than ₹1 lakh':
        return 150000;
      default:
        return 0;
    }
  }

  double _getMarriageDurationFactor(String duration) {
    switch (duration) {
      case 'Less than 1 year':
        return 0.5;
      case '1-3 years':
        return 0.7;
      case '3-5 years':
        return 0.9;
      case '5-10 years':
        return 1.1;
      case '10-15 years':
        return 1.3;
      case '15-20 years':
        return 1.5;
      case 'More than 20 years':
        return 1.7;
      default:
        return 1.0;
    }
  }

  double _getChildrenFactor(String childrenCount, String childExpenses) {
    if (childrenCount == 'No Children') return 0.0;

    switch (childrenCount) {
      case '1 Child':
        return 1.0;
      case '2 Children':
        return 1.6;
      case '3 Children':
        return 2.0;
      case '4 or More Children':
        return 2.3;
      default:
        return 0.0;
    }
  }

  double _getChildExpensesValue(String expenses) {
    switch (expenses) {
      case 'Not Applicable':
        return 0;
      case 'Less than ₹10,000':
        return 5000;
      case '₹10,000 - ₹25,000':
        return 17500;
      case '₹25,000 - ₹50,000':
        return 37500;
      case '₹50,000 - ₹1 lakh':
        return 75000;
      case 'More than ₹1 lakh':
        return 125000;
      default:
        return 0;
    }
  }

  double _getCustodyFactor(String custody) {
    switch (custody) {
      case 'Not Applicable':
        return 0.0;
      case 'Wife has Primary Custody':
        return 1.0;
      case 'Husband has Primary Custody':
        return 0.3;
      case 'Joint Custody':
        return 0.6;
      case 'To Be Determined':
        return 0.8;
      default:
        return 0.0;
    }
  }

  double _getCareerSacrificeFactor(String sacrifice) {
    switch (sacrifice) {
      case 'No Sacrifices Made':
        return 0.8;
      case 'Changed Jobs for Marriage':
        return 1.0;
      case 'Took Career Break':
        return 1.2;
      case 'Gave Up Career Completely':
        return 1.4;
      case 'Relocated Abandoning Career':
        return 1.5;
      case 'Not Applicable':
        return 1.0;
      default:
        return 1.0;
    }
  }

  double _getLifestyleFactor(String lifestyle) {
    switch (lifestyle) {
      case 'Modest':
        return 0.8;
      case 'Middle-class':
        return 1.0;
      case 'Upper Middle-class':
        return 1.2;
      case 'Affluent':
        return 1.5;
      case 'Elite':
        return 2.0;
      default:
        return 1.0;
    }
  }

  double _getHealthFactor(String health) {
    switch (health) {
      case 'No Major Health Issues':
        return 1.0;
      case 'Wife has Health Issues':
        return 1.3;
      case 'Husband has Health Issues':
        return 0.9;
      case 'Both have Health Issues':
        return 1.1;
      case 'Child has Special Needs':
        return 1.4;
      default:
        return 1.0;
    }
  }

  double _getMinimumLivingValue(String lifestyle) {
    switch (lifestyle) {
      case 'Modest':
        return 15000;
      case 'Middle-class':
        return 25000;
      case 'Upper Middle-class':
        return 40000;
      case 'Affluent':
        return 75000;
      case 'Elite':
        return 150000;
      default:
        return 25000;
    }
  }
}
