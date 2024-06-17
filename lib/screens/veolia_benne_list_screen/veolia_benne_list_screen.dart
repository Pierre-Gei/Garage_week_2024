import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/benneModel.dart';
import '../../services/entrepriseServices.dart';


//écran de la liste des bennes
class VeoliaBenneListScreen extends StatefulWidget {
  const VeoliaBenneListScreen({super.key});

  @override
  _VeoliaBenneListScreenState createState() => _VeoliaBenneListScreenState();
}

//état de l'écran de la liste des bennes
class _VeoliaBenneListScreenState extends State<VeoliaBenneListScreen> {
  //liste des bennes
  List<Benne> _bins = [];

  //chargement des données
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  //chargement des données depuis la base de données
  Future<void> _loadData() async {
    final bins = await EntrepriseServices().getAllBenne();
    setState(() {
      _bins = bins;
    });
  }

  //affichage de l'écran
  @override
  Widget build(BuildContext context) {
    //regroupement des bennes par ville pour l'affichage
    final Map<String, List<Benne>> binsByCity = {};
    _bins.forEach((bin) {
      if (!binsByCity.containsKey(bin.location)) {
        binsByCity[bin.location] = [];
      }
      binsByCity[bin.location]!.add(bin);
    });

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 198, 222, 226),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Center(
            child: Image.asset('lib/assets/icons/BinTech_Logo.jpg',
                height: 50, width: 50, fit: BoxFit.cover),
          ),
          actions: const [
            SizedBox(width: 57),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Liste des bennes',
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: binsByCity.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          entry.key.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        children: entry.value.map((bin) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              title: Text('Benne n° ${bin.id}'),
                              trailing: Text('${(bin.fullness * 100)}%'),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
