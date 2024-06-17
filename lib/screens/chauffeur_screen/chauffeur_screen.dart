import 'package:flutter/material.dart';
import '../../models/benneModel.dart';
import '../../models/entrepriseModel.dart';
import '../../models/userModel.dart';
import '../../services/entrepriseServices.dart';
import '../../widgets/_confirmLogout.dart';
import '../login_screen/login_screen.dart';

class ChauffeurScreen extends StatelessWidget {
  const ChauffeurScreen({Key? key, required User user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des bennes',
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
  const ChauffeurInfo({Key? key}) : super(key: key);

  @override
  State<ChauffeurInfo> createState() => _ChauffeurInfoState();
}

class _ChauffeurInfoState extends State<ChauffeurInfo> {
  List<Benne> _bins = [];
  List<Entreprise> _companies = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final bins = await EntrepriseServices().getAllBenne();
    final companies = await EntrepriseServices().getAllEntreprise();
    setState(() {
      _bins = bins;
      _companies = companies;
    });
  }

Future<void> _addNewBin(
    String type, String id, double fullness, Entreprise entreprise) async {
  Benne newBin = Benne(
    id: id,
    type: type,
    fullness: fullness,
    location: entreprise.ville,
    client: entreprise.nom,
    emptying: false,
    lastUpdate: DateTime.now(),
  );
  await EntrepriseServices().addBenneToEntreprise(entreprise.id, newBin);
  await _loadData(); // Reload the data after adding a new bin
}

  Future<void> _removeBin(int index) async {
    List<Benne> bins = await _bins;
    Benne binToRemove = bins[index];
    Entreprise entreprise = await EntrepriseServices().getEntreprise(binToRemove.client);
    bins.removeAt(index);
    await EntrepriseServices().removeBenneFromEntreprise(
        entreprise.id, binToRemove);
    await _loadData(); // Reload the data after removing a bin
  }

  void _showBinOptions(BuildContext context, Benne bin, Entreprise entreprise, additionalArgument) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Options pour benne n°${bin.id}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Show the bin info in a box
                  _ShowBinInfo(context, bin, entreprise);
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
                      (newbin) => newbin.id == bin.id && newbin.location == bin.location);

                  // Remove the bin from the _bins list
                  _removeBin(index);
                  // Remove the bin from the database
                  EntrepriseServices()
                      .removeBenneFromEntreprise(entreprise.id, bin);
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
                'Ajouter une benne',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedCompany.isNotEmpty ? selectedCompany : null,
                items: _companies
                    .map<DropdownMenuItem<String>>((Entreprise value) {
                  return DropdownMenuItem<String>(
                    value: value.nom,
                    child: Text(value.nom),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCompany = newValue!;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Numéro de la benne',
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedCompany.isNotEmpty && binNumber.isNotEmpty) {
                    Entreprise entreprise = _companies.firstWhere(
                        (company) => company.nom == selectedCompany);
                    _addNewBin(
                        binType, binNumber, 0, entreprise);
                    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    // Regroupement et tri des bennes par niveau de remplissage
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
        leading: const ConfirmLogout(),
        title: Center(
          child: Image.asset('lib/assets/icons/BinTech_Logo.jpg',
              height: 50, width: 50, fit: BoxFit.cover),
        ),
        actions: [
          SizedBox(width: 57),
        ]
      ),
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
                              onTap: () async {
                                _showBinOptions(
                                    context,
                                    bin,
                                    await EntrepriseServices()
                                        .getEntreprise(bin.client),
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

  Future<void> _ShowBinInfo(BuildContext context, Benne bin, Entreprise entreprise) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informations sur la benne ${bin.id}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type de déchets: ${entreprise.listBenne.firstWhere((element) => element.id == bin.id).type}'),
              Text('Emplacement: ${bin.location}'),
              Text('Taux de remplissage: ${bin.fullness*100}%'),
              Text('Client: ${entreprise.nom}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
