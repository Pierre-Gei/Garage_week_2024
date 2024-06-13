import 'package:flutter/material.dart';
import 'package:garage_week_2024/services/userServices.dart';
import '../../models/userModel.dart';

import '../chauffeur_screen/chauffeur_screen.dart';
import '../client_screen/client_screen.dart';

void main() {
  runApp(UserLoginPage(userType: 'client'));
}

class UserLoginPage extends StatelessWidget {
  final String userType;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  UserLoginPage({required this.userType, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion $userType'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Nom d\'utilisateur',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String username = usernameController.text;
                String password = passwordController.text;
                bool userExists = await UserServices().checkUser(username, password, userType);
                print('Username: $username');
                print('Password: $password');
                print('User type: $userType');
                print('User exists: $userExists');
                User user = await UserServices().getUser(username);
                if (userExists) {
                  if (userType == 'client') {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ClientScreen(user: user),
                      ),
                    );
                  } else if (userType == 'chauffeur') {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ChauffeurScreen(user : user),
                      ),
                    );
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => UserLoginPage(userType: 'client'),
                      ),
                    );
                  }
                } else {
                  // Handle the case when the user does not exist
                }
              },
              child: const Text('Connexion'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}