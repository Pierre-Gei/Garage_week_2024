import 'package:flutter/material.dart';
import '../login_screen/login_screen.dart';

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
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
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
          children:
          <Widget>[
            Image.asset('lib/assets/icons/BinTech_Logo.jpg', width: 100, height: 100 ),
            const SizedBox(height: 20),
            Image.asset('lib/assets/icons/Véolia.png', width: 100, height: 100 ),
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
                debugPrint('véolia');
                const ProfileSelectScreen()._navigateToLogin(context, 'veolia');
              },
              child: const Text('veolia'),
            ),
          ],
        ),
      ),
    );
  }
}
