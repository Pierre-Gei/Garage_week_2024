import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/benneModel.dart';
import '../profile_select_screen/profile_select_screen.dart';

void main() {
  runApp(const ClientScreen());
}

class ClientScreen extends StatelessWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Select Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ClientInfo(),
    );
  }
}

class ClientInfo extends StatelessWidget {
  const ClientInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String ClientName = 'Michel';
    final List<Benne> Bennes = [
      Benne(id: '1xzj', type: 'Verre', client: 'Michel', fullness: 0.5, location: 'Toulon', emptying: false),
      Benne(id: '2xjz', type: 'Plastique', client: 'Michel', fullness: 0.8, location: 'Toulon', emptying: true),
      Benne(id: '3xjz', type: 'Papier', client: 'Michel', fullness: 0.2, location: 'Toulon', emptying: false),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 198, 222, 226),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const ProfileSelectScreen()),
            );
          },
        ),
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
              'Bienvenue $ClientName !',
              style: TextStyle(fontSize: 25),
            ),
            const Text('Mes bennes : ', style: TextStyle(fontSize: 25)),
            Expanded(
              child: Bennes.isEmpty
                  ? const Center(
                child: Text('Aucune benne', style: TextStyle(fontSize: 20)),
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
                            builder: (BuildContext context, BoxConstraints constraints) {
                              return Container(
                                width: constraints.maxWidth,
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Benne ID: ${benne.id}'),
                                    Text('Type: ${benne.type}'),
                                    Text('Emplacement: ${benne.location}'),
                                    Text('Taux de remplssage: ${(benne.fullness * 100).toStringAsFixed(1)}%'),
                                    Text('Client: ${benne.client}'),
                                    Text('Vidage prévu: ${benne.emptying ? 'Oui' : 'Non'}'),
                                    ElevatedButton(
                                      child: Text('Demander le vidage'),
                                      onPressed: () {
                                        //TODO: Empty the bin
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
                            Text('Benne n°${benne.id}, ${benne.type} à ${benne.location}'),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                LinearProgressIndicator(
                                  value: benne.fullness,
                                  minHeight: 20,
                                  borderRadius: BorderRadius.circular(10),
                                  backgroundColor: Colors.grey,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                ),
                                Text(
                                  '${(benne.fullness * 100).toStringAsFixed(1)}%',
                                  style: TextStyle(color: Colors.white),
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
            ),          ],
        ),
      ),
    );
  }
}