import 'package:flutter/material.dart';
import '../../models/userModel.dart';

import '../../services/userServices.dart';
import '../chauffeur_screen/chauffeur_screen.dart';
import '../client_screen/client_screen.dart';
import '../veolia_screen/veolia_screen.dart';

//classe de l'écran de connexion
class UserLoginPage extends StatelessWidget {
  final String userType;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  UserLoginPage({required this.userType, super.key});

  //affichage de l'écran de connexion
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
                'Veuillez vous connecter',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
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
                        bool userExists = await UserServices()
                            .checkUser(username, password, userType);
                        if (userExists) {
                          User user = await UserServices().getUser(username);
                          if (userType == 'client') {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => ClientScreen(user: user),
                              ),
                            );
                          } else if (userType == 'chauffeur') {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChauffeurScreen(user: user),
                              ),
                            );
                          } else if (userType == 'veolia') {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => Veolia_screen(user: user),
                              ),
                            );
                          } else {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserLoginPage(userType: 'client'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Nom d\'utilisateur ou mot de passe incorrect'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Connexion'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
