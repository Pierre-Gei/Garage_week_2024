import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BtDeviceConnectScreen extends StatelessWidget {
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
        actions: const [//place holder to keep the title centered
          SizedBox(width: 57),
        ],
      ),
      //slider button to enable bluetooth
        //then a scan button to scan for devices
        //then a list of devices to connect to
        //then click on a device to connect and when connected, highlight the device and show a disconnect button
      body:
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Bluetooth is disabled'),
              Switch(
                value: false,
                onChanged: (value) {
                  //enable bluetooth
                  
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              //scan for devices
            },
            child: const Text('Scan for devices'),
          ),
          //list of devices
          //click on a device to connect
          //when connected, highlight the device and show a disconnect button
        ],
      ),
    );
  }
}