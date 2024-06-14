import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:garage_week_2024/models/benneModel.dart';
import 'package:garage_week_2024/services/entrepriseServices.dart';

import '../../services/btService.dart';

class BinUpdateScreen extends StatefulWidget {
  @override
  _BinUpdateScreenState createState() => _BinUpdateScreenState();
}

class _BinUpdateScreenState extends State<BinUpdateScreen> {
  BluetoothConnection? connection;
  List<Benne> bins = []; // This will hold the bins
  Benne? selectedBin;

  @override
  void initState() {
    super.initState();
    _loadData(); // Load the data when the widget is initialized
  }

  Future<void> _loadData() async {
    // Fetch the bins from the company's data
    List<Benne> fetchedBins = await EntrepriseServices().getAllBenne();

    // Get the Bluetooth device serial number
    String btDeviceSerial = await BtService().getBluetoothDeviceSerial();

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
                                  FutureBuilder<String>(
                                    future: BtService()
                                        .getBluetoothTauxRemplissage(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else {
                                        return Text(
                                            'Taux de remplissage: ${snapshot.data}');
                                      }
                                    },
                                  ),
                                  FutureBuilder<String>(
                                    future:
                                        BtService().getBluetoothDeviceSerial(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else {
                                        return Text(
                                            'Bluetooth Serial: ${snapshot.data}');
                                      }
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Update the database with the selected bin and data from Bluetooth

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
