
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String? avatar;
  final Map<String, dynamic>? additionalData;
  final bool isDarkMode;
  final String language;

  const ProfileLoaded({
    required this.name,
    this.avatar,
    this.additionalData,
    this.isDarkMode = false,
    this.language = 'English',
  });

  @override
  List<Object?> get props => [name, avatar, additionalData, isDarkMode, language];

  // Helper method to create a copy with updated fields
  ProfileLoaded copyWith({
    String? name,
    String? avatar,
    Map<String, dynamic>? additionalData,
    bool? isDarkMode,
    String? language,
  }) {
    return ProfileLoaded(
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      additionalData: additionalData ?? this.additionalData,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
