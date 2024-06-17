import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/factureModel.dart';
import '../../models/userModel.dart';
import '../../services/factureService.dart';
import '../../widgets/_confirmLogout.dart';
import '../facture_screen/facture_screen.dart';
import '../planning_screen/planning_screen.dart';
import '../stats_screen/stats_screen.dart';
import '../veolia_benne_list_screen/veolia_benne_list_screen.dart';

class Veolia_screen extends StatelessWidget {
  const Veolia_screen({Key? key, required User user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veolia Management',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const Veolia_info(),
    );
  }
}

class Veolia_info extends StatelessWidget {
  const Veolia_info({super.key});

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    _requestPermissions(); // Demande les permissions lors de l'ouverture de l'application
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 198, 222, 226),
          leading: const ConfirmLogout(),
          title: Center(
            child: Image.asset('lib/assets/icons/BinTech_Logo.jpg',
                height: 50, width: 50, fit: BoxFit.cover),
          ),
          actions: const [
            SizedBox(width: 57),
          ]),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlanningPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Planning'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FacturesPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Factures'),
            ),
            const SizedBox(height: 10),
            const FacturesPreview(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StatistiquesPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              child: const Text('Statistiques'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VeoliaBenneListScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Liste des bennes'),
            ),
          ],
        ),
      ),
    );
  }
}

class FacturesPreview extends StatelessWidget {
  const FacturesPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final factureServices = FactureServices();

    return FutureBuilder<List<Facture>>(
      future: factureServices.getAllFactures(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading spinner while waiting for data
        } else if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Show error message if there's an error
        } else {
          final factures = snapshot.data;
          if (factures == null || factures.isEmpty) {
            return const Text(
                'Pas de factures disposables'); // Show message if no factures are found
          } else {
            return Column(
              children: factures.map((facture) {
                return ListTile(
                  title: Text(facture.title),
                  subtitle: Text('Quantité: ${facture.amount} €'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FactureDetailPage(facture: facture.toJson()),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          }
        }
      },
    );
  }
}