import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../../data/models/CalculationModel.dart';
import 'ProfileEvent.dart';
import 'ProfileState.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final Box _profileBox = Hive.box('profile');
  StreamSubscription<BoxEvent>? _calculationsSubscription;

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateProfileExtended>(_onUpdateProfileExtended);
    on<UpdateThemePreference>(_onUpdateThemePreference);
    on<UpdateLanguagePreference>(_onUpdateLanguagePreference);

    final calculationsBox = Hive.box<CalculationModel>('calculations');
    _calculationsSubscription = calculationsBox.watch().listen((_) {
      updateCalculationStats();
    });
  }

  @override
  Future<void> close() {
    _calculationsSubscription?.cancel();
    return super.close();
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) {
    emit(ProfileLoading());
    try {
      final name = _profileBox.get('name', defaultValue: 'User');
      final avatar = _profileBox.get('avatar');
      final additionalData = _profileBox.get('additionalData');
      final isDarkMode = _profileBox.get('isDarkMode', defaultValue: false);
      final language = _profileBox.get('language', defaultValue: 'English');

      emit(
        ProfileLoaded(
          name: name,
          avatar: avatar,
          additionalData:
              additionalData != null
                  ? Map<String, dynamic>.from(additionalData)
                  : null,
          isDarkMode: isDarkMode,
          language: language,
        ),
      );

      if (additionalData == null ||
          !additionalData.containsKey('totalCalculations')) {
        updateCalculationStats();
      }
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await _profileBox.put('name', event.name);
      if (event.avatar != null) {
        await _profileBox.put('avatar', event.avatar);
      }

      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        emit(
          currentState.copyWith(
            name: event.name,
            avatar: event.avatar ?? currentState.avatar,
          ),
        );
      } else {
        emit(
          ProfileLoaded(
            name: event.name,
            avatar: event.avatar ?? _profileBox.get('avatar'),
          ),
        );
      }
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e'));
    }
  }

  void _onUpdateProfileExtended(
    UpdateProfileExtended event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _profileBox.put('name', event.name);
      if (event.avatar != null) {
        await _profileBox.put('avatar', event.avatar);
      }

      await _profileBox.put('additionalData', event.additionalData);

      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;

        Map<String, dynamic> mergedData = {
          ...currentState.additionalData ?? {},
        };
        mergedData.addAll(event.additionalData);

        emit(
          currentState.copyWith(
            name: event.name,
            avatar: event.avatar ?? currentState.avatar,
            additionalData: mergedData,
          ),
        );
      } else {
        emit(
          ProfileLoaded(
            name: event.name,
            avatar: event.avatar ?? _profileBox.get('avatar'),
            additionalData: event.additionalData,
            isDarkMode: _profileBox.get('isDarkMode', defaultValue: false),
            language: _profileBox.get('language', defaultValue: 'English'),
          ),
        );
      }
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e'));
    }
  }

  void _onUpdateThemePreference(
    UpdateThemePreference event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _profileBox.put('isDarkMode', event.isDarkMode);

      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        emit(currentState.copyWith(isDarkMode: event.isDarkMode));
      }
    } catch (e) {
      emit(ProfileError('Failed to update theme preference: $e'));
    }
  }

  void _onUpdateLanguagePreference(
    UpdateLanguagePreference event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _profileBox.put('language', event.language);

      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        emit(currentState.copyWith(language: event.language));
      }
    } catch (e) {
      emit(ProfileError('Failed to update language preference: $e'));
    }
  }

  void updateCalculationStats() async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;

      try {
        final calculationsBox = Hive.box<CalculationModel>('calculations');
        final calculations = calculationsBox.values.toList();

        final totalCalculations = calculations.length;
        final dowryCalculations =
            calculations
                .where((calc) => calc.type == CalculationType.dowry)
                .length;
        final alimonyCalculations =
            calculations
                .where((calc) => calc.type == CalculationType.alimony)
                .length;

        Map<String, dynamic> additionalData = currentState.additionalData ?? {};
        additionalData['totalCalculations'] = totalCalculations;
        additionalData['dowryCalculations'] = dowryCalculations;
        additionalData['alimonyCalculations'] = alimonyCalculations;

        await _profileBox.put('additionalData', additionalData);

        emit(currentState.copyWith(additionalData: additionalData));
      } catch (e) {
        print('Error updating calculation stats: $e');
      }
    }
  }
}
