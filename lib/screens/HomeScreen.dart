import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../data/models/CalculationModel.dart';
import '../presentation/bloc/calculation_history/CalculationHistoryBloc.dart';
import '../presentation/bloc/calculation_history/CalculationHistoryEvent.dart';
import '../presentation/bloc/calculation_history/CalculationHistoryState.dart';
import '../presentation/bloc/profile/ProfileBloc.dart';
import '../presentation/bloc/profile/ProfileEvent.dart';
import '../presentation/bloc/profile/ProfileState.dart';
import '../utils/AppColors.dart';
import 'AlimonyCalculatorScreen.dart';
import 'CalculationDetailScreen.dart';
import 'DowryCalculatorScreen.dart';
import 'HistoryScreen.dart';
import 'ProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _pageController = PageController(viewportFraction: 0.85);

    context.read<CalculationHistoryBloc>().add(LoadCalculationHistory());
    context.read<ProfileBloc>().add(LoadProfile());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      _showDisclaimerDialog();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Important Disclaimer",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "This application is created purely for fun and educational purposes.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "All calculations are fictional and should never be used for real-life decisions. The app is designed as a project to demonstrate Flutter development skills.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "I Understand",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(position: _slideAnimation, child: child),
            );
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildAppBar(isDarkMode)),

              SliverToBoxAdapter(
                child: _buildWelcomeBanner(screenSize, isDarkMode),
              ),

              SliverToBoxAdapter(child: _buildFeatureCards(screenSize)),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Calculations',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HistoryScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'View All',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: AppColors.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                sliver: _buildRecentCalculations(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryColor, AppColors.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calculate,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Relationship',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Calc',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),

          GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                ),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return Hero(
                    tag: 'profile-avatar',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primaryColor.withOpacity(
                          0.1,
                        ),
                        backgroundImage:
                            state.avatar != null
                                ? NetworkImage(state.avatar!)
                                : null,
                        child:
                            state.avatar == null
                                ? Text(
                                  state.name[0].toUpperCase(),
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                )
                                : null,
                      ),
                    ),
                  );
                }

                return CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner(Size screenSize, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Stack(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isDarkMode
                        ? [Color(0xFF2A2D3E), Color(0xFF212332)]
                        : [Color(0xFF6C63FF), Color(0xFF4ECDC4)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color:
                      isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    String name = 'User';
                    if (state is ProfileLoaded) {
                      name = state.name.split(' ')[0];
                    }
                    return Row(
                      children: [
                        Text(
                          'Hello, ',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'What would you like to calculate today?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(24),
              ),
              child: SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 30,
                      bottom: 30,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCards(Size screenSize) {
    return SizedBox(
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Our Calculators',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    ...List.generate(
                      _features.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentPage == index ? 16 : 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color:
                              _currentPage == index
                                  ? AppColors.primaryColor
                                  : Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: _features.length,
              itemBuilder: (context, index) {
                final feature = _features[index];
                final double opacity =
                    1.0 - 0.5 * (_currentPage - index).abs().clamp(0.0, 1.0);
                final double scale =
                    0.8 +
                    0.2 * (1 - (_currentPage - index).abs().clamp(0.0, 1.0));

                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.8, end: scale),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: opacity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => feature['screen'],
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: feature['color'].withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: feature['color'].withOpacity(0.1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(24),
                                        topRight: Radius.circular(24),
                                      ),
                                    ),
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: feature['color'].withOpacity(
                                            0.15,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          feature['icon'],
                                          color: feature['color'],
                                          size: 60,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            feature['title'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.titleLarge?.color,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Expanded(
                                            child: Text(
                                              feature['description'],
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color
                                                    ?.withOpacity(0.7),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: feature['color']
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Calculate',
                                                      style: TextStyle(
                                                        color: feature['color'],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Icon(
                                                      Icons.arrow_forward,
                                                      color: feature['color'],
                                                      size: 16,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> _features = [
    {
      'title': 'Dowry Calculator',
      'description': 'Estimate based on personal and financial factors.',
      'icon': Icons.favorite,
      'color': AppColors.primaryColor,
      'screen': const DowryCalculatorScreen(),
    },
    {
      'title': 'Alimony Calculator',
      'description': 'Calculate spousal support with key inputs.',
      'icon': Icons.account_balance,
      'color': AppColors.secondaryColor,
      'screen': const AlimonyCalculatorScreen(),
    },
  ];

  Widget _buildRecentCalculations() {
    return BlocBuilder<CalculationHistoryBloc, CalculationHistoryState>(
      builder: (context, state) {
        if (state is CalculationHistoryLoading) {
          return SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          );
        } else if (state is CalculationHistoryLoaded) {
          if (state.recentCalculations.isEmpty) {
            return SliverToBoxAdapter(child: _buildEmptyState());
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final calculation = state.recentCalculations[index];
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 600 + (index * 100)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildEnhancedCalculationCard(calculation),
                ),
              );
            }, childCount: state.recentCalculations.length),
          );
        } else if (state is CalculationHistoryError) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CalculationHistoryBloc>().add(
                        LoadCalculationHistory(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        return SliverToBoxAdapter(child: const SizedBox.shrink());
      },
    );
  }

  Widget _buildEnhancedCalculationCard(CalculationModel calculation) {
    final color =
        calculation.type == CalculationType.dowry
            ? AppColors.primaryColor
            : AppColors.secondaryColor;
    final icon =
        calculation.type == CalculationType.dowry
            ? Icons.favorite
            : Icons.account_balance;
    final title =
        calculation.type == CalculationType.dowry
            ? 'Dowry Calculation'
            : 'Alimony Calculation';

    final dateFormatter = DateFormat('dd MMM, yyyy • hh:mm a');

    String getDetailsText() {
      if (calculation.type == CalculationType.dowry) {
        if (calculation.inputData.containsKey('profession')) {
          return 'Profession: ${calculation.inputData['profession']}';
        } else if (calculation.inputData.containsKey('education')) {
          return 'Education: ${calculation.inputData['education']}';
        }
        return 'Monthly Income: ${calculation.inputData['income'] ?? 'Not specified'}';
      } else {
        if (calculation.inputData.containsKey('marriageDuration')) {
          return 'Marriage: ${calculation.inputData['marriageDuration']}';
        } else if (calculation.inputData.containsKey('childrenCount')) {
          return 'Children: ${calculation.inputData['childrenCount']}';
        }
        return 'Monthly Income: ${calculation.inputData['husbandIncome'] ?? 'Not specified'}';
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => CalculationDetailScreen(calculation: calculation),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(child: Icon(icon, color: color, size: 24)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          getDetailsText(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateFormatter.format(calculation.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).textTheme.bodySmall?.color?.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${calculation.result.toInt()}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 180,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: GridPainter(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    lineWidth: 1,
                    gridSize: 15,
                  ),
                ),
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.history,
                    size: 60,
                    color: AppColors.primaryColor.withOpacity(0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'No Calculations Yet',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Try our calculators and your results will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor.withOpacity(0.2),
                AppColors.secondaryColor.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "Fun & Educational Purposes Only",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                "This app is designed purely for entertainment and learning. The calculations are not based on actual legal guidance and should never be used for real-life decisions. Enjoy exploring the app as a fun way to learn about Flutter development!",
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _features[0]['screen'],
                        ),
                      );
                    },
                    icon: Icon(_features[0]['icon']),
                    label: const Text('Try a Calculator'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  final Color color;
  final double lineWidth;
  final double gridSize;

  GridPainter({
    required this.color,
    required this.lineWidth,
    required this.gridSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = lineWidth;

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
