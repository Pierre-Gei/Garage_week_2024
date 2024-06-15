import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BtService {
  BtService._privateConstructor();
  static final BtService _instance = BtService._privateConstructor();
  factory BtService() {
    return _instance;
  }

  final StreamController<bool> _bluetoothStateController =
      StreamController<bool>.broadcast();

  Stream<bool> get bluetoothState => _bluetoothStateController.stream;

  static final FlutterBluetoothSerial _bluetooth =
      FlutterBluetoothSerial.instance;
  static BluetoothConnection? _connection;
  static List<BluetoothDevice> _devicesList = [];
  static BluetoothDevice? _device;

  static final StreamController<BluetoothDevice> _connectedDeviceController =
      StreamController<BluetoothDevice>.broadcast();

  Stream<BluetoothDevice> get connectedDevice =>
      _connectedDeviceController.stream;

  Future<void> initBluetooth() async {
    bool? initialState = await getsBluetoothState();
    _bluetoothStateController.add(initialState ?? false);

    _bluetooth.onStateChanged().listen((BluetoothState state) {
      _bluetoothStateController.add(state == BluetoothState.STATE_ON);
    });
  }

  static Future<bool?> getsBluetoothState() async {
    return await _bluetooth.isEnabled;
  }

  Future<void> changeBluetoothState(bool enable) async {
    if (enable) {
      await _bluetooth.requestEnable();
    } else {
      await _bluetooth.requestDisable();
    }
    bool? newState = await getsBluetoothState();
    _bluetoothStateController.add(newState ?? false);
  }

  static Stream<List<BluetoothDevice>> scan() async* {
    bool isDiscovering = true;
    do {
      // Stop any ongoing scan
      await _bluetooth.cancelDiscovery();

      _devicesList = [];
      yield* _bluetooth.startDiscovery().map((result) {
        if (result.device.name != null && result.device.name!.isNotEmpty) {
          _devicesList.add(result.device);
        }
        return _devicesList;
      });

      isDiscovering = (await _bluetooth.isDiscovering)!;
    } while (isDiscovering);
    isDiscovering = false;
    print('Scanning done');
  }

  List<BluetoothDevice> getDevicesList() {
    return _devicesList;
  }

  static Future<void> connect(BluetoothDevice device) async {
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      _device = device;
      _connectedDeviceController.add(device);
    } catch (e) {
      if (e is PlatformException) {
        print('Failed to connect: ${e.message}');
        // Handle the exception, e.g., by showing an error message to the user
      } else {
        rethrow;
      }
    }
  }

  static Future<void> disconnect() async {
    await _connection?.close();
    _connection = null;
    _device = null;
  }

  static Future<void> send(String data) async {
    _connection?.output.add(utf8.encode(data + "\r\n"));
    await _connection?.output.allSent;
  }

  Map<String, String> parseArduinoData(String data) {
    print('Raw data: $data'); // Print the raw data

    final serialNumberRegex = RegExp(r'Numéro de série: (\w+),');
    final fillRateRegex = RegExp(r'Taux de remplissage: (\d+) %');

    final serialNumberMatch = serialNumberRegex.firstMatch(data);
    final fillRateMatch = fillRateRegex.firstMatch(data);

    String serialNumber = serialNumberMatch?.group(1) ?? '';
    String fillRate = fillRateMatch?.group(1) ?? '';

    print(
        'Parsed serial number: $serialNumber'); // Print the parsed serial number
    print('Parsed fill rate: $fillRate'); // Print the parsed fill rate

    return {
      'serialNumber': serialNumber,
      'fillRate': fillRate,
    };
  }

  Stream<Map<String, String>> get receiveData {
    return _connection?.input?.transform(
          StreamTransformer.fromHandlers(
            handleData: (Uint8List data, EventSink<Map<String, String>> sink) {
              // Decode the incoming data
              final String incomingData = utf8.decode(data);
              print('Incoming data: $incomingData');

              // Parse the incoming data
              Map<String, String> parsedData = parseArduinoData(incomingData);

              // Print the parsed data
              print('Parsed data: $parsedData');

              // Add the parsed data to the sink
              sink.add(parsedData);
            },
          ),
        ) ??
        Stream.empty();
  }

  Future<Map<String, String>> getBluetoothData() async {
  print('Getting Bluetooth data');
  print('getBluetoothData called from ${StackTrace.current}'); // Add this line
  Map<String, String> bluetoothData = {'serialNumber': '', 'fillRate': ''};
  if (_connection == null) {
    print('No Bluetooth device connected');
    return bluetoothData;
  }
  await Future.any([
    receiveData.first.then((data) {
      bluetoothData = data;
    }).onError((error, stackTrace) {
      print('Error receiving data: $error');
    }),
    Future.delayed(Duration(seconds: 10), () {
      if (bluetoothData['serialNumber'] == '' || bluetoothData['fillRate'] == '') {
        throw TimeoutException('Failed to get Bluetooth data within 10 seconds');
      }
    })
  ]);
  print('Bluetooth data: $bluetoothData');
  return bluetoothData;
}

  Future<String> getBluetoothTauxRemplissage() async {
    print('Getting fill rate');
    String fillRate = '';
    if (_connection == null) {
      print('No Bluetooth device connected');
      return fillRate;
    }
    await receiveData.first.then((data) {
      fillRate = data['fillRate'] ?? '';
    }).onError((error, stackTrace) {
      print('Error receiving data: $error');
    });
    print('Fill rate: $fillRate');
    return fillRate;
  }
}
