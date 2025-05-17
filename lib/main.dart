import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:relncalc/presentation/bloc/calculation_history/CalculationHistoryBloc.dart';
import 'package:relncalc/presentation/bloc/profile/ProfileBloc.dart';
import 'package:relncalc/screens/HomeScreen.dart';
import 'package:relncalc/utils/AppTheme.dart';
import 'package:relncalc/utils/ThemeProvider.dart';

import 'data/models/CalculationModel.dart';
import 'data/repositories/CalculationRepository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  Hive.registerAdapter(CalculationModelAdapter());
  Hive.registerAdapter(CalculationTypeAdapter());

  await Hive.openBox<CalculationModel>('calculations');
  await Hive.openBox('profile');

  final profileBox = Hive.box('profile');
  final isDarkMode = profileBox.get('isDarkMode', defaultValue: false);

  runApp(MyApp(initialDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool initialDarkMode;

  const MyApp({Key? key, required this.initialDarkMode}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ValueNotifier<ThemeMode> _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = ValueNotifier(
      widget.initialDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }

  @override
  Widget build(BuildContext context) {
    final calculationRepository = CalculationRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider<CalculationHistoryBloc>(
          create: (context) => CalculationHistoryBloc(calculationRepository),
        ),
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
      ],
      child: ThemeProvider(
        themeMode: _themeMode,
        lightTheme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: _themeMode,
          builder: (context, themeMode, _) {
            return MaterialApp(
              title: 'Relationship Calculator',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
