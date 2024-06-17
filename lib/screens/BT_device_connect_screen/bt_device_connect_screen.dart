import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../../services/btService.dart';
import '../bin_update_screen/bin_update_screen.dart';

//écran de connexion au périphérique Bluetooth
class BtDeviceConnectScreen extends StatefulWidget {
  var entreprise;

  static const routeName = '/btDeviceConnectScreen';

  BtDeviceConnectScreen({super.key, required this.entreprise});
  @override
  _BtDeviceConnectScreenState createState() => _BtDeviceConnectScreenState();
}

class _BtDeviceConnectScreenState extends State<BtDeviceConnectScreen> {
  late StreamSubscription<bool> _bluetoothStateSubscription;
  bool isBluetoothEnabled = false;
  bool isScanInitiated = false;

  @override
  void initState() {
    super.initState();
    BtService().initBluetooth();
    _bluetoothStateSubscription = BtService().bluetoothState.listen((state) {
      setState(() {
        isBluetoothEnabled = state;
      });
    });
  }

  @override
  void dispose() {
    _bluetoothStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Bluetooth ${isBluetoothEnabled ? 'activé' : 'désactivé'}'),
              Switch(
                value: isBluetoothEnabled,
                onChanged: (value) async {
                  await BtService().changeBluetoothState(value);
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: isBluetoothEnabled
                ? () async {
                    await BtService().initBluetooth();
                    await BtService.scan();
                    print('Scanning');
                    setState(() {
                      isScanInitiated =
                          true;
                    });
                  }
                : null,
            child: const Text('rechercher les appareils'),
          ),
          ElevatedButton(
            onPressed: BtService().connectedDevice != null
                ? () async {
                    await BtService.disconnect();
                    print(BtService().connectedDevice);
                    print('Disconnected');
                  }
                : null,
            child: const Text('Déconnecter le périphérique'),
          ),
          Expanded(
            child: StreamBuilder<List<BluetoothDevice>>(
              stream: BtService.scan(),
              builder: (context, snapshot) {
                if (isBluetoothEnabled &&
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!isBluetoothEnabled) {
                  return const Center(child: Text('Bluetooth is disabled'));
                } else if (isBluetoothEnabled &&
                    snapshot.connectionState == ConnectionState.active &&
                    !isScanInitiated) {
                  return const Center(
                      child: Text(
                          'No scan initiated'));
                } else {
                  return ListView.builder(
                    itemCount: (snapshot.data?.length ?? 0) +
                        (snapshot.connectionState == ConnectionState.active
                            ? 1
                            : 0),
                    itemBuilder: (context, index) {
                      if (index < (snapshot.data?.length ?? 0)) {
                        BluetoothDevice device = snapshot.data![index];
                        bool isConnected =
                            device == BtService().connectedDevice;
                        return ListTile(
                          tileColor: isConnected
                              ? Colors.green
                              : null,
                          title: Text(device.name ?? ''),
                          subtitle: Text(device.address),
                          onTap: () async {
                            await BtService.connect(device);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BinUpdateScreen(
                                    entreprise: widget.entreprise),
                              ),
                            );
                          },
                        );
                      } else {
                        if (isBluetoothEnabled) {
                          return const ListTile(
                            title: Text('Scanning...'),
                            trailing: CircularProgressIndicator(),
                          );
                        } else {
                          return const ListTile(
                            title: Text('Bluetooth is disabled'),
                          );
                        }
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
