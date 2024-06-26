import 'package:flutter/material.dart';
import '../screens/profile_select_screen/profile_select_screen.dart';

//classe de confirmation de déconnexion

class ConfirmLogout extends StatelessWidget {
  const ConfirmLogout({super.key});

  //bouton de déconnexion
  @override
  Widget build(BuildContext context) {
    return
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        _confirmLogout(context);
      },
    );
  }

  //fonction de confirmation de déconnexion
  Future<void> _confirmLogout(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Se déconnecter'),
          content: const Text('Voulez-vous vraiment vous déconnecter ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ProfileSelectScreen(),
                  ),
                );
              },
              child: const Text('Se déconnecter'),
            ),
          ],
        );
      },
    );
  }
}