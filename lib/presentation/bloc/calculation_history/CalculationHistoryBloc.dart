import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/CalculationModel.dart';
import '../../../data/repositories/CalculationRepository.dart';
import 'CalculationHistoryEvent.dart';
import 'CalculationHistoryState.dart';

class CalculationHistoryBloc
    extends Bloc<CalculationHistoryEvent, CalculationHistoryState> {
  final CalculationRepository _calculationRepository;

  CalculationHistoryBloc(this._calculationRepository)
    : super(CalculationHistoryInitial()) {
    on<LoadCalculationHistory>(_onLoadCalculationHistory);
    on<AddCalculation>(_onAddCalculation);
    on<DeleteCalculation>(_onDeleteCalculation);
    on<ClearHistory>(_onClearHistory);
  }

  void _onLoadCalculationHistory(
    LoadCalculationHistory event,
    Emitter<CalculationHistoryState> emit,
  ) {
    emit(CalculationHistoryLoading());
    try {
      print("Loading calculation history");
      final allCalculations = _calculationRepository.getAllCalculations();
      final recentCalculations = _calculationRepository.getRecentCalculations();

      print(
        "Loaded ${allCalculations.length} calculations, ${recentCalculations.length} recent ones",
      );

      emit(
        CalculationHistoryLoaded(
          allCalculations: allCalculations,
          recentCalculations: recentCalculations,
        ),
      );
    } catch (e) {
      print("Error loading calculation history: $e");
      emit(CalculationHistoryError('Failed to load calculation history: $e'));
    }
  }

  void _onAddCalculation(
    AddCalculation event,
    Emitter<CalculationHistoryState> emit,
  ) async {
    try {
      if (state is CalculationHistoryLoaded) {
        final currentState = state as CalculationHistoryLoaded;

        bool isDuplicate = _checkForDuplicate(
          currentState.allCalculations,
          event.calculation,
        );

        if (isDuplicate) {
          print("Skipping duplicate calculation");
          return;
        }

        print("Saving new calculation: ${event.calculation.id}");
        print("Input data: ${event.calculation.inputData}");

        await _calculationRepository.saveCalculation(event.calculation);

        final allCalculations = _calculationRepository.getAllCalculations();
        final recentCalculations =
            _calculationRepository.getRecentCalculations();

        emit(
          CalculationHistoryLoaded(
            allCalculations: allCalculations,
            recentCalculations: recentCalculations,
          ),
        );

        print(
          "Save successful, emitted new state with ${allCalculations.length} calculations",
        );
      } else {
        add(LoadCalculationHistory());
        add(event);
      }
    } catch (e) {
      print("Error adding calculation: $e");
      emit(CalculationHistoryError('Failed to add calculation: $e'));
    }
  }

  void _onDeleteCalculation(
    DeleteCalculation event,
    Emitter<CalculationHistoryState> emit,
  ) async {
    if (state is CalculationHistoryLoaded) {
      try {
        print("Deleting calculation: ${event.id}");
        await _calculationRepository.deleteCalculation(event.id);

        final allCalculations = _calculationRepository.getAllCalculations();
        final recentCalculations =
            _calculationRepository.getRecentCalculations();

        emit(
          CalculationHistoryLoaded(
            allCalculations: allCalculations,
            recentCalculations: recentCalculations,
          ),
        );

        print(
          "Delete successful, emitted new state with ${allCalculations.length} calculations",
        );
      } catch (e) {
        print("Error deleting calculation: $e");
        emit(CalculationHistoryError('Failed to delete calculation: $e'));
      }
    }
  }

  void _onClearHistory(
    ClearHistory event,
    Emitter<CalculationHistoryState> emit,
  ) async {
    try {
      print("Clearing all history");
      await _calculationRepository.clearAllCalculations();

      emit(
        const CalculationHistoryLoaded(
          allCalculations: [],
          recentCalculations: [],
        ),
      );

      print("Clear successful, emitted empty state");
    } catch (e) {
      print("Error clearing history: $e");
      emit(CalculationHistoryError('Failed to clear history: $e'));
    }
  }

  bool _checkForDuplicate(
    List<CalculationModel> existingCalculations,
    CalculationModel newCalculation,
  ) {
    if (existingCalculations.any((calc) => calc.id == newCalculation.id)) {
      return true;
    }

    for (var existing in existingCalculations) {
      if (existing.type == newCalculation.type) {
        if (existing.type == CalculationType.alimony) {
          bool coreInputsMatch = _compareAlimonyInputs(
            existing.inputData,
            newCalculation.inputData,
          );

          bool resultMatches =
              (existing.result - newCalculation.result).abs() < 0.01;

          if (coreInputsMatch && resultMatches) {
            print("Found duplicate calculation: ${existing.id}");
            return true;
          }
        } else if (existing.type == CalculationType.dowry) {
          bool coreInputsMatch = _compareDowryInputs(
            existing.inputData,
            newCalculation.inputData,
          );

          bool resultMatches =
              (existing.result - newCalculation.result).abs() < 0.01;

          if (coreInputsMatch && resultMatches) {
            print("Found duplicate calculation: ${existing.id}");
            return true;
          }
        }
      }
    }

    return false;
  }

  bool _compareAlimonyInputs(
    Map<String, dynamic> existing,
    Map<String, dynamic> newInputs,
  ) {
    final keyFields = [
      'husbandIncome',
      'wifeIncome',
      'husbandLiabilities',
      'wifeLiabilities',
      'marriageDuration',
      'childrenCount',
      'custody',
      'lifestyle',
    ];

    for (var field in keyFields) {
      if (!existing.containsKey(field) || !newInputs.containsKey(field)) {
        continue;
      }

      if (existing[field] != newInputs[field]) {
        return false;
      }
    }

    return true;
  }

  bool _compareDowryInputs(
    Map<String, dynamic> existing,
    Map<String, dynamic> newInputs,
  ) {
    final keyFields = [
      'income',
      'age',
      'educationLevel',
      'familyAssets',
      'state',
      'profession',
      'residence',
    ];

    for (var field in keyFields) {
      if (!existing.containsKey(field) || !newInputs.containsKey(field)) {
        continue;
      }
      if (existing[field] != newInputs[field]) {
        return false;
      }
    }

    return true;
  }
}
