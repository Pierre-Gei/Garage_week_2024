import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:garage_week_2024/permissions.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dbUpdateDev.dart';
import 'firebase_options.dart';
import 'screens/profile_select_screen/profile_select_screen.dart';


//fichier de lancement de l'application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Add this line
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('fr_FR', null);
  await requestBluetoothPermissions();
  //addUserToDatabase();
  runApp(const ProfileSelectScreen());
}

//classe principale de l'application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BinTracker',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: const ProfileSelectScreen(),
    );
  }
}