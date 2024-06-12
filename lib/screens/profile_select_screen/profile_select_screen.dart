import 'package:flutter/material.dart';
import '/screens/client_screen/client_screen.dart';

void main() {
  runApp(const ProfileSelectScreen());
}

class ProfileSelectScreen extends StatelessWidget {
  const ProfileSelectScreen({super.key});

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
                debugPrint('Client');
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ClientScreen()),
                );
              },
              child: const Text('Client'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the driver screen
              },
              child: const Text('Chauffeur'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the véolia screen
              },
              child: const Text('Véolia'),
            ),
          ],
        ),
      ),
    );
  }
}
