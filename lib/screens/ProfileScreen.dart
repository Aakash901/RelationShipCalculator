import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../presentation/bloc/profile/ProfileBloc.dart';
import '../presentation/bloc/profile/ProfileEvent.dart';
import '../presentation/bloc/profile/ProfileState.dart';
import '../utils/AppColors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _avatarUrl;

  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isDarkMode = false;

  int _totalCalculations = 0;
  int _dowryCalculations = 0;
  int _alimonyCalculations = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticInOut),
    );

    _nameController = TextEditingController(text: 'User');
    _emailController = TextEditingController(text: '');
    _phoneController = TextEditingController(text: '');

    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileLoaded) {
      _nameController.text = profileState.name;
      _avatarUrl = profileState.avatar;

      if (profileState.additionalData != null) {
        _emailController.text =
            profileState.additionalData!['email']?.toString() ?? '';
        _phoneController.text =
            profileState.additionalData!['phone']?.toString() ?? '';
        _totalCalculations =
            (profileState.additionalData!['totalCalculations'] as int?) ?? 0;
        _dowryCalculations =
            (profileState.additionalData!['dowryCalculations'] as int?) ?? 0;
        _alimonyCalculations =
            (profileState.additionalData!['alimonyCalculations'] as int?) ?? 0;
      }

      _isDarkMode = profileState.isDarkMode;
    } else {
      context.read<ProfileBloc>().add(LoadProfile());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> additionalData = {
        'email': _emailController.text,
        'phone': _phoneController.text,
      };

      context.read<ProfileBloc>().add(
        UpdateProfileExtended(
          name: _nameController.text,
          avatar: _avatarUrl,
          additionalData: additionalData,
        ),
      );
      _showSuccessAnimation();
    }
  }

  void _showSuccessAnimation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            const Text('Profile updated successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    context.read<ProfileBloc>().add(UpdateThemePreference(_isDarkMode));
  }

  void _showAvatarOptions() {
    _animationController.reset();
    _animationController.forward();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose Avatar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAvatarOption(1),
                    _buildAvatarOption(2),
                    _buildAvatarOption(3),
                    _buildAvatarOption(4),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAvatarOption(5),
                    _buildAvatarOption(6),
                    _buildAvatarOption(7),
                    _buildAvatarOption(8),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Remove Avatar'),
                    onPressed: () {
                      setState(() {
                        _avatarUrl = null;
                      });
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildAvatarOption(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _avatarUrl = 'https://i.pravatar.cc/150?img=$index';
        });
        Navigator.pop(context);
      },
      child: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=$index'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primaryColor;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded) {
            _nameController.text = state.name;
            _avatarUrl = state.avatar;

            if (state.additionalData != null) {
              _emailController.text =
                  state.additionalData!['email']?.toString() ??
                  _emailController.text;
              _phoneController.text =
                  state.additionalData!['phone']?.toString() ??
                  _phoneController.text;
              _totalCalculations =
                  state.additionalData!['totalCalculations'] as int? ??
                  _totalCalculations;
              _dowryCalculations =
                  state.additionalData!['dowryCalculations'] as int? ??
                  _dowryCalculations;
              _alimonyCalculations =
                  state.additionalData!['alimonyCalculations'] as int? ??
                  _alimonyCalculations;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Hero(
                              tag: 'profile-avatar',
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: primaryColor.withOpacity(0.2),
                                backgroundImage:
                                    _avatarUrl != null
                                        ? NetworkImage(_avatarUrl!)
                                        : null,
                                child:
                                    _avatarUrl == null
                                        ? Text(
                                          _nameController.text.isNotEmpty
                                              ? _nameController.text[0]
                                                  .toUpperCase()
                                              : 'U',
                                          style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        )
                                        : null,
                              ),
                            ),

                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: ScaleTransition(
                                scale: _animation,
                                child: GestureDetector(
                                  onTap: _showAvatarOptions,
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: scaffoldBackgroundColor,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Hello, ${_nameController.text}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem(
                                context,
                                _totalCalculations.toString(),
                                'Total',
                                Icons.calculate,
                              ),
                              _buildStatItem(
                                context,
                                _dowryCalculations.toString(),
                                'Dowry',
                                Icons.favorite,
                              ),
                              _buildStatItem(
                                context,
                                _alimonyCalculations.toString(),
                                'Alimony',
                                Icons.account_balance,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildSectionHeader(
                    context,
                    'Personal Information',
                    Icons.person,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Please enter a valid email';
                        }
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  _buildSectionHeader(context, 'Preferences', Icons.settings),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isDark ? Icons.dark_mode : Icons.light_mode,
                              color: primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'App Theme',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                            Switch(
                              value: _isDarkMode,
                              onChanged: (value) {
                                setState(() {
                                  _isDarkMode = value;
                                });
                                _toggleTheme();
                              },
                              activeColor: primaryColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose between light and dark theme for the app',
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor?.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildThemePreview(
                                context,
                                false,
                                'Light',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildThemePreview(context, true, 'Dark'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.language, color: primaryColor, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Language',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select your preferred language',
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor?.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: 'English',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'English',
                              child: Text('English'),
                            ),
                            DropdownMenuItem(
                              value: 'Hindi',
                              child: Text('हिंदी (Hindi)'),
                            ),
                            DropdownMenuItem(
                              value: 'Spanish',
                              child: Text('Español (Spanish)'),
                            ),
                          ],
                          onChanged: (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Language changed to ${value ?? "English"}',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text(
                                'About Relationship Calculator',
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Version 1.0.0'),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'A calculator app designed to help users with relationship-based financial calculations, including dowry and alimony estimations.',
                                  ),
                                  const SizedBox(height: 16),
                                  const Text('© 2025 Your Company'),
                                  const SizedBox(height: 8),
                                  const Text('All rights reserved'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'About & Help',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.help_outline,
                            size: 16,
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final primaryColor = AppColors.primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: primaryColor, width: 4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    final primaryColor = AppColors.primaryColor;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: primaryColor, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildThemePreview(BuildContext context, bool isDark, String label) {
    final selected = (isDark && _isDarkMode) || (!isDark && !_isDarkMode);

    return GestureDetector(
      onTap: () {
        setState(() {
          _isDarkMode = isDark;
        });
        _toggleTheme();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                selected
                    ? AppColors.primaryColor
                    : isDark
                    ? Colors.grey[700]!
                    : Colors.grey[300]!,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 6,
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 6,
              color: isDark ? Colors.grey[700] : Colors.grey[300],
            ),
            const SizedBox(height: 4),
            Container(
              height: 6,
              width: 60,
              color: isDark ? Colors.grey[700] : Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableStatsPanel() {
    return ExpansionTile(
      title: Text(
        'Your Calculation Stats',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
      leading: Icon(Icons.bar_chart, color: AppColors.primaryColor),
      childrenPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildStatProgressBar(
                context,
                'Dowry Calculations',
                _dowryCalculations,
                _totalCalculations,
                AppColors.primaryColor,
              ),
              const SizedBox(height: 16),
              _buildStatProgressBar(
                context,
                'Alimony Calculations',
                _alimonyCalculations,
                _totalCalculations,
                AppColors.secondaryColor,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Calculations',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$_totalCalculations',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatProgressBar(
    BuildContext context,
    String label,
    int value,
    int total,
    Color color,
  ) {
    final double percentage = total == 0 ? 0 : value / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('$value (${(percentage * 100).toInt()}%)'),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
