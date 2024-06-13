import 'package:flutter/material.dart';
import 'package:garage_week_2024/models/entrepriseModel.dart';
import 'package:garage_week_2024/models/userModel.dart';
import 'package:garage_week_2024/screens/profile_select_screen/profile_select_screen.dart';
import '../../models/benneModel.dart';
import '../../services/entrepriseServices.dart';
import '../login_screen/login_screen.dart';

class ChauffeurScreen extends StatelessWidget {
  const ChauffeurScreen({super.key, required User user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Bennes',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const ChauffeurInfo(),
    );
  }
}

class ChauffeurInfo extends StatefulWidget {
  const ChauffeurInfo({super.key});

  @override
  State<ChauffeurInfo> createState() => _ChauffeurInfoState();
}

class _ChauffeurInfoState extends State<ChauffeurInfo> {
  Future<List<Benne>> _bins;
  Future<List<Entreprise>> _companies;

  _ChauffeurInfoState()
      : _bins = EntrepriseServices().getAllBenne(),
        _companies = EntrepriseServices().getAllEntreprise();

  Future<void> _addNewBin(
      String type, String id, double fullness, Entreprise entreprise) async {
    Benne newBin = Benne(
      id: id,
      type: type,
      fullness: fullness,
      location: entreprise.ville,
      client: entreprise.nom,
      emptying: false,
      lastUpdate: DateTime.now().toIso8601String(),
    );
    List<Benne> bins = await _bins;
    bins.add(newBin);
    EntrepriseServices().addBenneToEntreprise(entreprise.id, newBin);
  }

  Future<void> _removeBin(int index) async {
    List<Benne> bins = await _bins;
    bins.removeAt(index);
  }

  void _showBinOptions(BuildContext context, String binId, String location,
      int fillLevel, Entreprise entreprise, additionalArgument) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Options pour $binId',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Action pour afficher les informations de la benne
                  Navigator.pop(context);
                },
                child: const Text('Info'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  // Find the index of the bin in the _bins list
                  int index = (await _bins).indexWhere(
                      (bin) => bin.id == binId && bin.location == location);

                  // Remove the bin from the _bins list
                  _bins.then((bins) => bins.removeAt(index));

                  // Remove the bin from the database
                  EntrepriseServices()
                      .removeBenneFromEntreprise(entreprise.id, binId);

                  Navigator.pop(context);
                },
                child: const Text('Récupérer'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAddBinBottomSheet() async {
    String selectedCompany = '';
    String binNumber = '';
    String binType = '';
    int fillLevel = 0;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ajouter une Benne',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Entreprise>>(
                future: _companies,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Entreprise>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return DropdownButtonFormField<String>(
                      items: snapshot.data!.map((company) {
                        return DropdownMenuItem(
                          value: company.nom,
                          child: Text(company.nom),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedCompany = newValue!;
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Numéro de la Benne',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  binNumber = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Type de déchets',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  binType = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Niveau de remplissage (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  fillLevel = int.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (selectedCompany.isNotEmpty && binNumber.isNotEmpty) {
                    Entreprise selectedEntreprise = await _companies.then(
                        (companies) => companies.firstWhere(
                            (company) => company.nom == selectedCompany));
                    _addNewBin(binType, binNumber, fillLevel.toDouble(),
                        selectedEntreprise);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Valider'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Voulez-vous vraiment vous déconnecter?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Se Déconnecter'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const ProfileSelectScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Regroupement et tri des bennes par niveau de remplissage
    final Map<String, List<Benne>> binsByCity = {};
    _bins.then((bins) {
      bins.forEach((bin) {
        if (!binsByCity.containsKey(bin.location)) {
          binsByCity[bin.location] = [];
        }
        binsByCity[bin.location]?.add(bin);
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Bennes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _confirmLogout(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                          entry.key,
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
                              title: Text(bin.id),
                              trailing: Text('${bin.fullness}%'),
                              onTap: () {
                                _showBinOptions(
                                    context,
                                    bin.id,
                                    bin.location,
                                    bin.fullness.toInt(),
                                    EntrepriseServices()
                                            .getEntreprise(bin.client)
                                        as Entreprise,
                                    null);
                              },
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBinBottomSheet,
        tooltip: 'Ajouter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
