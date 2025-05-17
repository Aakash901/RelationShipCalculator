import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends InheritedWidget {
  final ValueNotifier<ThemeMode> themeMode;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  const ThemeProvider({
    Key? key,
    required this.themeMode,
    required this.lightTheme,
    required this.darkTheme,
    required Widget child,
  }) : super(key: key, child: child);

  static ThemeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>()!;
  }

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  void toggleTheme() {
    final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    themeMode.value = newMode;

    final profileBox = Hive.box('profile');
    profileBox.put('isDarkMode', newMode == ThemeMode.dark);
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return themeMode != oldWidget.themeMode ||
        lightTheme != oldWidget.lightTheme ||
        darkTheme != oldWidget.darkTheme;
  }
}
