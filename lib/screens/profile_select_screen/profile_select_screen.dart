import 'package:flutter/material.dart';
import '../login_screen/login_screen.dart';

//classe de sélection de profil
class ProfileSelectScreen extends StatelessWidget {
  const ProfileSelectScreen({super.key});

  void _navigateToLogin(BuildContext context, String userType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserLoginPage(userType: userType),
      ),
    );
  }

  //affichage de l'écran de sélection de profil
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sélection de profil',
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
                //Redirection vers la page de connexion avec le type de profil
                const ProfileSelectScreen()._navigateToLogin(context, 'client');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text('client', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint('chauffeur');
                //Redirection vers la page de connexion avec le type de profil
                const ProfileSelectScreen()
                    ._navigateToLogin(context, 'chauffeur');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.drive_eta),
                  SizedBox(width: 10),
                  Text('chauffeur', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                //Redirection vers la page de connexion avec le type de profil
                debugPrint('véolia');
                const ProfileSelectScreen()._navigateToLogin(context, 'veolia');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.business),
                  SizedBox(width: 10),
                  Text('véolia', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
