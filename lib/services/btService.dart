import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

//classe de gestion du bluetooth
class BtService {
  //constructeur privé de la classe BtService
  BtService._privateConstructor();
  //singleton de la classe BtService
  static final BtService _instance = BtService._privateConstructor();
  //factory de la classe BtService
  factory BtService() {
    return _instance;
  }

  //initialisation du bluetooth et gestion de l'état du bluetooth
  final StreamController<bool> _bluetoothStateController =
      StreamController<bool>.broadcast();

  //état du bluetooth
  Stream<bool> get bluetoothState => _bluetoothStateController.stream;

  //instance de la classe FlutterBluetoothSerial
  static final FlutterBluetoothSerial _bluetooth =
      FlutterBluetoothSerial.instance;
  static BluetoothConnection? _connection;
  static List<BluetoothDevice> _devicesList = [];
  static BluetoothDevice? _device;

  //contrôleur de flux de données du périphérique connecté
  static final StreamController<BluetoothDevice> _connectedDeviceController =
      StreamController<BluetoothDevice>.broadcast();

  //flux de données du périphérique connecté
  Stream<BluetoothDevice> get connectedDevice =>
      _connectedDeviceController.stream;

  //initialisation du bluetooth
  Future<void> initBluetooth() async {
    bool? initialState = await getsBluetoothState();
    _bluetoothStateController.add(initialState ?? false);

    _bluetooth.onStateChanged().listen((BluetoothState state) {
      _bluetoothStateController.add(state == BluetoothState.STATE_ON);
    });
  }

  //obtention de l'état du bluetooth
  static Future<bool?> getsBluetoothState() async {
    return await _bluetooth.isEnabled;
  }

  //changement de l'état du bluetooth
  Future<void> changeBluetoothState(bool enable) async {
    if (enable) {
      await _bluetooth.requestEnable();
    } else {
      await _bluetooth.requestDisable();
    }
    bool? newState = await getsBluetoothState();
    _bluetoothStateController.add(newState ?? false);
  }

  //recherche des périphériques bluetooth
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

  //obtention de la liste des périphériques connectés
  List<BluetoothDevice> getConnecectedDevice() {
    return _devicesList;
  }

  //connexion à un périphérique bluetooth
  List<BluetoothDevice> getDevicesList() {
    return _devicesList;
  }

  //connexion à un périphérique bluetooth
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

  //déconnexion du périphérique bluetooth
  static Future<void> disconnect() async {
    await _connection?.close();
    _connection = null;
    _device = null;
  }

  //envoi de données au périphérique bluetooth
  static Future<void> send(String data) async {
    _connection?.output.add(utf8.encode("$data\r\n"));
    await _connection?.output.allSent;
  }

  //envoi de données au périphérique bluetooth
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

  //réception de données du périphérique bluetooth
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

  //obtention des données du périphérique bluetooth (numéro de série et taux de remplissage)
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

  //obtention du numéro de série du périphérique bluetooth
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
