import 'package:flutter/material.dart';

void main() {
  runApp(const ChauffeurScreen());
}

class ChauffeurScreen extends StatelessWidget {
  const ChauffeurScreen({super.key});

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
  final List<Map<String, dynamic>> _bins = [
    {'location': 'Toulon', 'name': 'Benne X2247B', 'fillLevel': 80},
    {'location': 'Toulon', 'name': 'Benne 12UX7', 'fillLevel': 40},
    {'location': 'La valette', 'name': 'Benne 26VGD', 'fillLevel': 60},
    {'location': 'La valette', 'name': 'Benne 72A8X', 'fillLevel': 90},
  ];

  final List<String> _companies = [
    'Company A',
    'Company B',
    'Company C',
    'Company D',
  ];

  void _addNewBin(String location, String name, int fillLevel) {
    setState(() {
      _bins.add({'location': location, 'name': name, 'fillLevel': fillLevel});
    });
  }

  void _removeBin(int index) {
    setState(() {
      _bins.removeAt(index);
    });
  }

  void _showBinOptions(BuildContext context, String binName, String location, int fillLevel) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Options pour $binName',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Action pour afficher les informations de la benne
                  Navigator.pop(context);
                },
                child: const Text('Info'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final index = _bins.indexWhere((bin) => bin['name'] == binName && bin['location'] == location);
                  _removeBin(index);
                  Navigator.pop(context);
                },
                child: const Text('Récupérer'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Entreprise',
                  border: OutlineInputBorder(),
                ),
                items: _companies.map((String company) {
                  return DropdownMenuItem<String>(
                    value: company,
                    child: Text(company),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedCompany = value!;
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
                onPressed: () {
                  if (selectedCompany.isNotEmpty && binNumber.isNotEmpty) {
                    _addNewBin(selectedCompany, binNumber, fillLevel);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Valider'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
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
                  MaterialPageRoute(builder: (context) => const LoginPage()),
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
    final Map<String, List<Map<String, dynamic>>> binsByCity = {};
    for (var bin in _bins) {
      if (!binsByCity.containsKey(bin['location'])) {
        binsByCity[bin['location']] = [];
      }
      binsByCity[bin['location']]!.add(bin);
    }
    binsByCity.forEach((key, value) {
      value.sort((a, b) => b['fillLevel'].compareTo(a['fillLevel']));
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
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
                              title: Text(bin['name']),
                              trailing: Text('${bin['fillLevel']}%'),
                              onTap: () {
                                _showBinOptions(context, bin['name'], bin['location'], bin['fillLevel']);
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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _navigateToLogin(BuildContext context, String userType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserLoginPage(userType: userType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choisissez votre type de connexion:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _navigateToLogin(context, 'Entreprise');
              },
              child: const Text('Entreprise'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _navigateToLogin(context, 'Chauffeur');
              },
              child: const Text('Chauffeur'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _navigateToLogin(context, 'Veolia');
              },
              child: const Text('Veolia'),
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

class UserLoginPage extends StatelessWidget {
  final String userType;

  const UserLoginPage({required this.userType, super.key});

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
              decoration: const InputDecoration(
                labelText: 'Nom d\'utilisateur',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Action de connexion
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
