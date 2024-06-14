import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garage_week_2024/models/entrepriseModel.dart';
import 'package:garage_week_2024/widgets/_confirmLogout.dart';

import '../../models/benneModel.dart';
import '../../models/userModel.dart';
import '../../services/entrepriseServices.dart';
import '../profile_select_screen/profile_select_screen.dart';

class ClientScreen extends StatelessWidget {
  final User user;
  ClientScreen({required this.user, Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Select Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClientInfo(user),
    );
  }
}

class ClientInfo extends StatelessWidget {
  ClientInfo(this.user, {Key? key}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Entreprise>(
      future: EntrepriseServices().getEntrepriseById(user.entrepriseId),
      builder: (BuildContext context, AsyncSnapshot<Entreprise> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final Entreprise entreprise = snapshot.data!;
          final List<Benne> Bennes = entreprise.listBenne;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 198, 222, 226),
              leading: const ConfirmLogout(),
              title: Center(
                child: Image.asset('lib/assets/icons/BinTech_Logo.jpg',
                    height: 50, width: 50, fit: BoxFit.cover),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    // Navigate to the settings screen
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenue ${entreprise.nom} !',
                    style: TextStyle(fontSize: 25),
                  ),
                  const Text('Mes bennes : ', style: TextStyle(fontSize: 25)),
                  Expanded(
                    child: Bennes.isEmpty
                        ? const Center(
                            child: Text('Aucune benne',
                                style: TextStyle(fontSize: 20)),
                          )
                        : ListView(
                            children: Bennes.map((benne) {
                              return InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    showDragHandle: true,
                                    builder: (context) {
                                      return LayoutBuilder(
                                        builder: (BuildContext context,
                                            BoxConstraints constraints) {
                                          return Container(
                                            width: constraints.maxWidth,
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text('Benne ID: ${benne.id}'),
                                                Text('Type: ${benne.type}'),
                                                Text(
                                                    'Emplacement: ${benne.location}'),
                                                Text(
                                                    'Taux de remplssage: ${(benne.fullness * 100).toStringAsFixed(1)}%'),
                                                Text('Client: ${benne.client}'),
                                                Text(
                                                    'Vidage prévu: ${benne.emptying ? 'Oui' : 'Non'}'),
                                                ElevatedButton(
                                                  child: Text(
                                                      'Demander le vidage'),
                                                  onPressed: () {
                                                    //TODO make a date picker for the emptying date and update the database
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                            'Benne n°${benne.id}, ${benne.type} à ${benne.location}'),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            LinearProgressIndicator(
                                              value: benne.fullness,
                                              minHeight: 20,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              backgroundColor: Colors.grey,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.green),
                                            ),
                                            Text(
                                              '${(benne.fullness * 100).toStringAsFixed(1)}%',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
