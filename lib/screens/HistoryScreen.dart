import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass/glass.dart';

import '../data/models/CalculationModel.dart';
import '../presentation/bloc/calculation_history/CalculationHistoryBloc.dart';
import '../presentation/bloc/calculation_history/CalculationHistoryEvent.dart';
import '../presentation/bloc/calculation_history/CalculationHistoryState.dart';
import '../presentation/widgets/CalculationCard.dart';
import '../utils/AppColors.dart';
import 'CalculationDetailScreen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<CalculationHistoryBloc>().add(LoadCalculationHistory());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: FadeIn(
                    child: Text(
                      'Calculation History',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryColor.withOpacity(0.7),
                          AppColors.primaryColor.withOpacity(0.9),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElasticIn(
                            child: Icon(
                              Icons.history,
                              size: 80,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FadeInUp(
                            child: Text(
                              'Track Your Financial Calculations',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    onPressed: () => _showClearHistoryDialog(context),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.95),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      labelColor: AppColors.primaryColor,
                      unselectedLabelColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      tabs: const [
                        Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text('All'),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text('Dowry'),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text('Alimony'),
                          ),
                        ),
                      ],
                    ),
                  ).asGlass(tintColor: Colors.white, frosted: true),
                ),
              ),
            ],
        body: BlocBuilder<CalculationHistoryBloc, CalculationHistoryState>(
          builder: (context, state) {
            if (state is CalculationHistoryLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state is CalculationHistoryLoaded) {
              final allCalculations = state.allCalculations;
              final dowryCalculations =
                  allCalculations
                      .where((calc) => calc.type == CalculationType.dowry)
                      .toList();
              final alimonyCalculations =
                  allCalculations
                      .where((calc) => calc.type == CalculationType.alimony)
                      .toList();

              if (allCalculations.isEmpty) {
                return _buildEmptyHistory();
              }
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildCalculationList(allCalculations),
                  _buildCalculationList(dowryCalculations),
                  _buildCalculationList(alimonyCalculations),
                ],
              );
            } else if (state is CalculationHistoryError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Oops! Something went wrong',
                      style: TextStyle(
                        color: Colors.red.shade300,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: TextStyle(
                        color: Colors.red.shade200,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCalculationList(List<CalculationModel> calculations) {
    if (calculations.isEmpty) {
      return _buildEmptyHistory();
    }

    return FadeInUp(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: calculations.length,
        itemBuilder: (context, index) {
          return FadeInUp(
            delay: Duration(milliseconds: 100 * index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Dismissible(
                key: Key(calculations[index].id),
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  context.read<CalculationHistoryBloc>().add(
                    DeleteCalculation(calculations[index].id),
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CalculationDetailScreen(
                                calculation: calculations[index],
                              ),
                        ),
                      );
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1.5,
                        ),
                      ),
                      child: CalculationCard(calculation: calculations[index]),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeIn(
            child: Icon(
              Icons.history_toggle_off_rounded,
              size: 100,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            child: Text(
              'No Calculations Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text(
              'Start calculating to see your history here',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
              },
              child: const Text(
                'Start Calculating',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Clear History',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            content: Text(
              'Are you sure you want to clear all calculation history?',
              style: TextStyle(color: Colors.grey[600]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  context.read<CalculationHistoryBloc>().add(ClearHistory());
                  Navigator.pop(context);
                },
                child: const Text(
                  'CLEAR',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
