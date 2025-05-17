import 'package:equatable/equatable.dart';

import '../../../data/models/CalculationModel.dart';
abstract class CalculationHistoryEvent extends Equatable {
  const CalculationHistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCalculationHistory extends CalculationHistoryEvent {}

class AddCalculation extends CalculationHistoryEvent {
  final CalculationModel calculation;

  const AddCalculation(this.calculation);

  @override
  List<Object?> get props => [calculation];
}

class DeleteCalculation extends CalculationHistoryEvent {
  final String id;

  const DeleteCalculation(this.id);

  @override
  List<Object?> get props => [id];
}

class ClearHistory extends CalculationHistoryEvent {}
