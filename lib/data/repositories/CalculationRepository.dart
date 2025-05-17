import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/CalculationModel.dart';

class CalculationRepository {
  final Box<CalculationModel> _calculationsBox;

  CalculationRepository()
    : _calculationsBox = Hive.box<CalculationModel>('calculations');

  CalculationRepository.withBox(this._calculationsBox);

  Future<void> saveCalculation(CalculationModel calculation) async {
    debugPrint('Repository: Saving calculation ${calculation.id}');
    try {
      await _calculationsBox.put(calculation.id, calculation);
      debugPrint('Repository: Save successful');
    } catch (e) {
      debugPrint('Repository: Error saving calculation: $e');
      throw Exception('Failed to save calculation: $e');
    }
  }

  List<CalculationModel> getAllCalculations() {
    try {
      final calculations = _calculationsBox.values.toList();

      calculations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      debugPrint('Repository: Retrieved ${calculations.length} calculations');
      return calculations;
    } catch (e) {
      debugPrint('Repository: Error retrieving all calculations: $e');
      throw Exception('Failed to retrieve calculations: $e');
    }
  }

  List<CalculationModel> getCalculationsByType(CalculationType type) {
    try {
      final calculations =
          _calculationsBox.values
              .where((calculation) => calculation.type == type)
              .toList();

      calculations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      debugPrint(
        'Repository: Retrieved ${calculations.length} calculations of type $type',
      );
      return calculations;
    } catch (e) {
      debugPrint('Repository: Error retrieving calculations by type: $e');
      throw Exception('Failed to retrieve calculations by type: $e');
    }
  }

  List<CalculationModel> getRecentCalculations() {
    try {
      final calculations = _calculationsBox.values.toList();

      calculations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      final recentCalculations = calculations.take(5).toList();
      debugPrint(
        'Repository: Retrieved ${recentCalculations.length} recent calculations',
      );
      return recentCalculations;
    } catch (e) {
      debugPrint('Repository: Error retrieving recent calculations: $e');
      throw Exception('Failed to retrieve recent calculations: $e');
    }
  }

  Future<void> deleteCalculation(String id) async {
    debugPrint('Repository: Deleting calculation $id');
    try {
      await _calculationsBox.delete(id);
      debugPrint('Repository: Delete successful');
    } catch (e) {
      debugPrint('Repository: Error deleting calculation: $e');
      throw Exception('Failed to delete calculation: $e');
    }
  }

  Future<void> clearAllCalculations() async {
    debugPrint('Repository: Clearing all calculations');
    try {
      await _calculationsBox.clear();
      debugPrint('Repository: Clear successful');
    } catch (e) {
      debugPrint('Repository: Error clearing calculations: $e');
      throw Exception('Failed to clear calculations: $e');
    }
  }
}
