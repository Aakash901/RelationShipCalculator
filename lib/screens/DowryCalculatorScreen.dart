import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/CalculationModel.dart';
import '../presentation/bloc/calculation_history/CalculationHistoryBloc.dart';
import '../presentation/bloc/calculation_history/CalculationHistoryEvent.dart';
import '../presentation/widgets/CustomDropdownField.dart';
import '../presentation/widgets/ResultDisplay.dart';
import '../utils/AppColors.dart';

class DowryCalculatorScreen extends StatefulWidget {
  const DowryCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<DowryCalculatorScreen> createState() => _DowryCalculatorScreenState();
}

class _DowryCalculatorScreenState extends State<DowryCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedAge;
  String? _selectedProfession;
  String? _selectedSalary;
  String? _selectedEducation;
  String? _selectedResidence;
  String? _selectedCountry;

  bool _isCalculated = false;
  double _result = 0.0;

  final List<String> _ageOptions = [
    '18-24 years',
    '25-30 years',
    '31-35 years',
    '36-40 years',
    'More than 40 years',
  ];

  final List<String> _professionOptions = [
    'Entrepreneur',
    'Engineer',
    'Doctor',
    'Investment Banker',
    'Brand Manager',
    'Product Manager',
    'Content Creator',
    'Others',
  ];

  final List<String> _salaryOptions = [
    'Less than 50,000',
    '50,100 - 1 lakh',
    '1-2 lakhs',
    '2-5 lakhs',
    'More than 5 lakhs',
  ];

  final List<String> _educationOptions = [
    'High School',
    'Graduation',
    'Post Graduation',
    'PhD',
    'Dropout',
  ];

  final List<String> _residenceOptions = [
    'Self-owned',
    'Rented',
    'Parent\'s house',
  ];

  final List<String> _countryOptions = ['India', 'Abroad'];

  void _calculateDowry() {
    if (_formKey.currentState!.validate()) {
      final ageValue = _getAgeValue(_selectedAge!);
      final professionValue = _getProfessionValue(_selectedProfession!);
      final salaryValue = _getSalaryValue(_selectedSalary!);
      final educationValue = _getEducationValue(_selectedEducation!);
      final residenceValue = _getResidenceValue(_selectedResidence!);
      final countryValue = _getCountryValue(_selectedCountry!);

      double baseValue = salaryValue * 1.5;
      double ageMultiplier = ageValue;
      double professionFactor = professionValue * 0.8;
      double educationFactor = educationValue * 1.2;
      double residenceFactor = residenceValue * 0.7;
      double countryMultiplier = countryValue;

      _result =
          ((baseValue * ageMultiplier * countryMultiplier) +
              (professionFactor * educationFactor * residenceFactor * 10000)) /
          2;

      setState(() {
        _isCalculated = true;
      });

      final calculation = CalculationModel(
        type: CalculationType.dowry,
        inputData: {
          'age': _selectedAge,
          'profession': _selectedProfession,
          'salary': _selectedSalary,
          'education': _selectedEducation,
          'residence': _selectedResidence,
          'country': _selectedCountry,
        },
        result: _result,
      );

      context.read<CalculationHistoryBloc>().add(AddCalculation(calculation));
    }
  }

  double _getAgeValue(String age) {
    switch (age) {
      case '18-24 years':
        return 1.5;
      case '25-30 years':
        return 1.3;
      case '31-35 years':
        return 1.0;
      case '36-40 years':
        return 0.8;
      case 'More than 40 years':
        return 0.6;
      default:
        return 1.0;
    }
  }

  double _getProfessionValue(String profession) {
    switch (profession) {
      case 'Entrepreneur':
        return 5.0;
      case 'Investment Banker':
        return 4.5;
      case 'Doctor':
        return 4.0;
      case 'Brand Manager':
        return 3.5;
      case 'Product Manager':
        return 3.5;
      case 'Engineer':
        return 3.0;
      case 'Content Creator':
        return 2.5;
      case 'Others':
        return 2.0;
      default:
        return 2.0;
    }
  }

  double _getSalaryValue(String salary) {
    switch (salary) {
      case 'Less than 50,000':
        return 40000;
      case '50,100 - 1 lakh':
        return 75000;
      case '1-2 lakhs':
        return 150000;
      case '2-5 lakhs':
        return 350000;
      case 'More than 5 lakhs':
        return 750000;
      default:
        return 50000;
    }
  }

  double _getEducationValue(String education) {
    switch (education) {
      case 'PhD':
        return 2.0;
      case 'Post Graduation':
        return 1.8;
      case 'Graduation':
        return 1.5;
      case 'High School':
        return 1.0;
      case 'Dropout':
        return 0.8;
      default:
        return 1.0;
    }
  }

  double _getResidenceValue(String residence) {
    switch (residence) {
      case 'Self-owned':
        return 2.0;
      case 'Parent\'s house':
        return 1.5;
      case 'Rented':
        return 1.0;
      default:
        return 1.0;
    }
  }

  double _getCountryValue(String country) {
    switch (country) {
      case 'Abroad':
        return 1.7;
      case 'India':
        return 1.0;
      default:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'Dowry Calculator',
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
                Text(
                  'Enter Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                CustomDropdownField(
                  labelText: 'Age',
                  prefixIcon: Icons.cake,
                  value: _selectedAge,
                  items: _ageOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedAge = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Profession',
                  prefixIcon: Icons.work,
                  value: _selectedProfession,
                  items: _professionOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedProfession = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your profession';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Monthly Salary',
                  prefixIcon: Icons.attach_money,
                  value: _selectedSalary,
                  items: _salaryOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedSalary = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your monthly salary';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Education',
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
                      return 'Please select your education';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Residence',
                  prefixIcon: Icons.home,
                  value: _selectedResidence,
                  items: _residenceOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedResidence = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your residence';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomDropdownField(
                  labelText: 'Country',
                  prefixIcon: Icons.public,
                  value: _selectedCountry,
                  items: _countryOptions,
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your country';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _calculateDowry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Calculate',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                if (_isCalculated) ...[
                  const SizedBox(height: 32),
                  ResultDisplay(result: _result, type: CalculationType.dowry),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
