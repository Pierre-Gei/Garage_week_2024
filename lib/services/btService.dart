import 'dart:convert';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class btService {
  static FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  static BluetoothConnection? _connection;
  static List<BluetoothDevice> _devicesList = [];
  static BluetoothDevice? _device;

  static Future<void> init() async {
    // Initialize the phone bluetooth device
    await _bluetooth.requestEnable();
  }

  static Future<void> scan() async {
    // Scan for bluetooth devices
    _devicesList = await _bluetooth.getBondedDevices();
  }

  static Future<void> connect(BluetoothDevice device) async {
    // Connect to the bluetooth device
    _connection = await BluetoothConnection.toAddress(device.address);
    _device = device;
  }

  static Future<void> disconnect() async {
    // Disconnect from the bluetooth device
    await _connection?.close();
    _connection = null;
    _device = null;
  }

  static Future<void> send(String data) async {
    // Send data to the bluetooth device
    _connection?.output.add(utf8.encode(data + "\r\n"));
    await _connection?.output.allSent;
  }

  static Future<void> receive() async {
    // Receive data from the bluetooth device
    _connection?.input?.listen((data) {
      print('Received: ${utf8.decode(data)}');
    }).onDone(() {
      print('Disconnected by remote request');
    });
  }
}