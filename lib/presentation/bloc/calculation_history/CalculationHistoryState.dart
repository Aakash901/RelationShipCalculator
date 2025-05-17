
import 'package:equatable/equatable.dart';
import '../../../data/models/CalculationModel.dart';

abstract class CalculationHistoryState extends Equatable {
  const CalculationHistoryState();

  @override
  List<Object?> get props => [];
}

class CalculationHistoryInitial extends CalculationHistoryState {}

class CalculationHistoryLoading extends CalculationHistoryState {}

class CalculationHistoryLoaded extends CalculationHistoryState {
  final List<CalculationModel> allCalculations;
  final List<CalculationModel> recentCalculations;

  const CalculationHistoryLoaded({
    required this.allCalculations,
    required this.recentCalculations,
  });

  @override
  List<Object?> get props => [allCalculations, recentCalculations];
}

class CalculationHistoryError extends CalculationHistoryState {
  final String message;

  const CalculationHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}