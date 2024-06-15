import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:garage_week_2024/models/benneModel.dart';
import 'package:garage_week_2024/services/entrepriseServices.dart';

import '../../models/entrepriseModel.dart';
import '../../services/btService.dart';

class BinUpdateScreen extends StatefulWidget {
  final Entreprise entreprise;

  BinUpdateScreen({required this.entreprise});

  @override
  _BinUpdateScreenState createState() => _BinUpdateScreenState();
}

class _BinUpdateScreenState extends State<BinUpdateScreen> {

  BluetoothConnection? connection;
  List<Benne> bins = []; // This will hold the bins
  Benne? selectedBin;
  Map<String, String> bluetoothData = {'serialNumber': '', 'fillRate': ''};

  @override
  void initState() {
    super.initState();
    _loadData(); // Load the data when the widget is initialized
  }

  Future<void> _loadData() async {
    // Fetch the bins from the company's data
    List<Benne> fetchedBins = await EntrepriseServices().getAllBenne();

    // Get the Bluetooth device data
    bluetoothData = await BtService().getBluetoothData();

    // Get the Bluetooth device serial number
    String btDeviceSerial = bluetoothData['serialNumber'] ?? '';

    // Check if any of the fetched bins have a BluetoothDeviceSerial that matches the one from the Bluetooth device
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
    setState(() {
      bins = fetchedBins;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bin Update Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Add your desired padding here
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
                        : null, // Highlight the selected bin
                    child: ListTile(
                      title: Text('Benne de ${bins[index].type}'),
                      subtitle: Text('Benne n° : ${bins[index].id}'),
                      onTap: () {
                        setState(() {
                          selectedBin = bins[index];
                        });
                        // Update the database with the selected bin and data from Bluetooth
                        // Use a alertDialog to confirm the update and show the data to be updated
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Mettre à jour la benne'),
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
                                      // Update the database with the selected bin and data from Bluetooth
                                      selectedBin!.fullness = double.parse(bluetoothData['fillRate'] ?? '0');
                                      selectedBin!.BluetoothDeviceSerial = bluetoothData['serialNumber'] ?? '';
                                      EntrepriseServices().updateBenneFromEntreprise(widget.entreprise.id, selectedBin!);
                                      // Show a snackbar to confirm the update
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Benne n°${selectedBin!.id} mise à jour'),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: Text('Mettre à jour'),
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