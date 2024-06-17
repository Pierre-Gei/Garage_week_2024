import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


import '../../globals.dart';
import '../../models/benneModel.dart';
import '../../models/entrepriseModel.dart';
import '../../services/btService.dart';
import '../../services/entrepriseServices.dart';

class BinUpdateScreen extends StatefulWidget {
  final Entreprise entreprise;

  BinUpdateScreen({required this.entreprise});

  @override
  _BinUpdateScreenState createState() => _BinUpdateScreenState();
}

class _BinUpdateScreenState extends State<BinUpdateScreen> {

  BluetoothConnection? connection;
  List<Benne> bins = [];
  Benne? selectedBin;
  Map<String, String> bluetoothData = {'serialNumber': '', 'fillRate': ''};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<Benne> fetchedBins = await EntrepriseServices().getAllBenne();
    bluetoothData = await BtService().getBluetoothData();
    String btDeviceSerial = bluetoothData['serialNumber'] ?? '';
    selectedBin = fetchedBins.firstWhere(
            (bin) => bin.BluetoothDeviceSerial == btDeviceSerial,
        orElse: () => Benne(
          id: '',
          fullness: 0.0,
          type: '',
          location: '',
          client: '',
          emptying: false,
        ));

    if (selectedBin!.id.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirmer la mise à jour de la benne'),
            content: Text('Voulez-vous mettre à jour la benne n°${selectedBin!.id} ?'
                'Nouveau taux de remplissage: ${bluetoothData['fillRate']}'),
            actions: <Widget>[
              TextButton(
                child: const Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () async {
                  selectedBin!.fullness = double.parse(bluetoothData['fillRate'] ?? '0');
                  selectedBin!.BluetoothDeviceSerial = bluetoothData['serialNumber'] ?? '';
                  await EntrepriseServices().updateBenneFromEntreprise(widget.entreprise.id, selectedBin!);
                  Navigator.of(context).pop();
                  binUpdateNotifier.value = selectedBin;
                },
              ),
            ],
          );
        },
      );
    }

    setState(() {
      bins = fetchedBins;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mise à jour des bennes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('Taux de remplissage: ${bluetoothData['fillRate']}'),
            Text('Bluetooth Serial: ${bluetoothData['serialNumber']}'),
            const Text('Selectionnez la benne à mettre à jour:',
                style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: bins.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: bins[index] == selectedBin
                        ? Colors.blue[100]
                        : null,
                    child: ListTile(
                      title: Text('Benne de ${bins[index].type}'),
                      subtitle: Text('Benne n° : ${bins[index].id}'),
                      onTap: () {
                        setState(() {
                          selectedBin = bins[index];
                        });
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Metre à jour la benne'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('Benne n°${selectedBin!.id}'),
                                  Text('Type: ${selectedBin!.type}'),
                                  Text('Emplacement: ${selectedBin!.location}'),
                                  Column(
                                    children: [
                                      Text('Taux de remplissage: ${bluetoothData['fillRate']}'),
                                      Text('Bluetooth Serial: ${bluetoothData['serialNumber']}'),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      selectedBin!.fullness = double.parse(bluetoothData['fillRate'] ?? '0');
                                      selectedBin!.BluetoothDeviceSerial = bluetoothData['serialNumber'] ?? '';
                                      EntrepriseServices().updateBenneFromEntreprise(widget.entreprise.id, selectedBin!);
                                      binUpdateNotifier.value = selectedBin;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Benne n°${selectedBin!.id} mise à jour'),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Mettre à jour'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}