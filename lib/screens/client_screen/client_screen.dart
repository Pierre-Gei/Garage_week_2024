import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/benneModel.dart';
import '../profile_select_screen/profile_select_screen.dart';

void main() {
  runApp(const ClientScreen());
}

class ClientScreen extends StatelessWidget {
  const ClientScreen({super.key});
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
  const ClientInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final String ClientName;
    List<Benne> Bennes;
    Bennes = [
      Benne(id: '1xzj', type: 'Verre', client: 'Michel', fullness: 0.5, location: 'Toulon'),
      Benne(id: '2xjz', type: 'Plastique', client: 'Michel', fullness: 0.8, location: 'Toulon'),
      Benne(id: '3xjz', type: 'Papier', client: 'Michel', fullness: 0.2, location: 'Toulon'),
    ];
    ClientName = 'Michel';
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
                child: ListView(
                  children:  [
                    if (Bennes.isEmpty)
                      const Center(
                        child: Text('Aucune benne', style: TextStyle(fontSize: 20)),
                      )
                    else
                      Column(
                        children: Bennes.map((benne) {
                          return ListTile(
                            title: Text('Benne n°${benne.id}, ${benne.type} à ${benne.location}'),
                            subtitle:
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    LinearProgressIndicator(value: benne.fullness, minHeight: 20, borderRadius: BorderRadius.circular(10), backgroundColor: Colors.grey, valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
                                    Text('${(benne.fullness * 100).toStringAsFixed(1)}%', style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}
