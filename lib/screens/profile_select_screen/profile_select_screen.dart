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
        backgroundColor: const Color.fromARGB(255, 198, 222, 226),
        title: Center(
          child: Image.asset('lib/assets/icons/BinTech_Logo.jpg',
              height: 50, width: 50, fit: BoxFit.cover),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      AssetImage('lib/assets/icons/BinTech_Logo.jpg'),
                ),
                SizedBox(width: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('lib/assets/icons/Véolia.png'),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Choisissez votre profil',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                debugPrint('client');
                const ProfileSelectScreen()._navigateToLogin(context, 'client');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.person), // Add your desired icon here
                  const SizedBox(width: 10),
                  const Text('client', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint('chauffeur');
                const ProfileSelectScreen()
                    ._navigateToLogin(context, 'chauffeur');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.drive_eta), // Add your desired icon here
                  const SizedBox(width: 10),
                  const Text('chauffeur', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint('véolia');
                const ProfileSelectScreen()._navigateToLogin(context, 'veolia');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.business), // Add your desired icon here
                  const SizedBox(width: 10),
                  const Text('véolia', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
