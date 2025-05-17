import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String? avatar;

  const UpdateProfile({
    required this.name,
    this.avatar,
  });

  @override
  List<Object?> get props => [name, avatar];
}

class UpdateProfileExtended extends UpdateProfile {
  final Map<String, dynamic> additionalData;

  const UpdateProfileExtended({
    required String name,
    String? avatar,
    required this.additionalData,
  }) : super(name: name, avatar: avatar);

  @override
  List<Object?> get props => [name, avatar, additionalData];
}

class UpdateThemePreference extends ProfileEvent {
  final bool isDarkMode;

  const UpdateThemePreference(this.isDarkMode);

  @override
  List<Object?> get props => [isDarkMode];
}

class UpdateLanguagePreference extends ProfileEvent {
  final String language;

  const UpdateLanguagePreference(this.language);

  @override
  List<Object?> get props => [language];
}