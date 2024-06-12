import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'screens/profile_select_screen/profile_select_screen.dart';

void main() async {
  await initializeDateFormatting('fr_FR', null);
  runApp(const ProfileSelectScreen());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ENT ISEN Toulon',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          primarySwatch: Colors.red,
        ),
        home: const ProfileSelectScreen(),
    );
  }
}

