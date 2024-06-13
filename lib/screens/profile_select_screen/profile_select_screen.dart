import 'package:flutter/material.dart';
import 'package:garage_week_2024/screens/chauffeur_screen/chauffeur_screen.dart';
import '../login_screen/login_screen.dart';
import '/screens/client_screen/client_screen.dart';

void main() {
  runApp(const ProfileSelectScreen());
}

class ProfileSelectScreen extends StatelessWidget {
  const ProfileSelectScreen({super.key});

  void _navigateToLogin(BuildContext context, String userType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserLoginPage(userType: userType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Select Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProfileSelect(),
    );
  }
}

class ProfileSelect extends StatelessWidget {
  const ProfileSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Select Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Select your profile',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint('client');
                const ProfileSelectScreen()._navigateToLogin(context, 'client');
              },
              child: const Text('client'),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint('chauffeur');
                const ProfileSelectScreen()._navigateToLogin(context, 'chauffeur');
              },
              child: const Text('chauffeur'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the véolia screen
              },
              child: const Text('véolia'),
            ),
          ],
        ),
      ),
    );
  }
}
