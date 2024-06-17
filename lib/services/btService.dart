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
  }

  List<BluetoothDevice> getConnecectedDevice() {
    return _devicesList;
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
    final serialNumberRegex = RegExp(r'Numéro de série: (\w+),');
    final fillRateRegex = RegExp(r'Taux de remplissage: (\d+) %');

    final serialNumberMatch = serialNumberRegex.firstMatch(data);
    final fillRateMatch = fillRateRegex.firstMatch(data);

    String serialNumber = serialNumberMatch?.group(1) ?? '';
    String fillRate = fillRateMatch?.group(1) ?? '';
    return {
      'serialNumber': serialNumber,
      'fillRate': fillRate,
    };
  }

  Stream<Map<String, String>> get receiveData {
    return _connection?.input?.transform(
          StreamTransformer.fromHandlers(
            handleData: (Uint8List data, EventSink<Map<String, String>> sink) {
              final String incomingData = utf8.decode(data);
              Map<String, String> parsedData = parseArduinoData(incomingData);
              sink.add(parsedData);
            },
          ),
        ) ??
        const Stream.empty();
  }

  Future<Map<String, String>> getBluetoothData() async {
  Map<String, String> bluetoothData = {'serialNumber': '', 'fillRate': ''};
  if (_connection == null) {
    return bluetoothData;
  }
  await Future.any([
    receiveData.first.then((data) {
      bluetoothData = data;
    }).onError((error, stackTrace) {
    }),
    Future.delayed(const Duration(seconds: 10), () {
      if (bluetoothData['serialNumber'] == '' || bluetoothData['fillRate'] == '') {
        throw TimeoutException('Failed to get Bluetooth data within 10 seconds');
      }
    })
  ]);
  return bluetoothData;
}

  Future<String> getBluetoothTauxRemplissage() async {
    String fillRate = '';
    if (_connection == null) {
      return fillRate;
    }
    await receiveData.first.then((data) {
      fillRate = data['fillRate'] ?? '';
    }).onError((error, stackTrace) {
    });
    return fillRate;
  }
}
