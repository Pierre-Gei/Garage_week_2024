class Benne{
  String id;
  double fullness;
  String type;
  String location;
  String client;
  bool emptying;
  DateTime? emptyingDate;
  DateTime? lastUpdate;
  String? BluetoothDeviceSerial;

  Benne({
    required this.id,
    required this.fullness,
    required this.type,
    required this.location,
    required this.client,
    required this.emptying,
    this.emptyingDate,
    this.lastUpdate,
    this.BluetoothDeviceSerial,
  });

  factory Benne.fromJson(Map<String, dynamic> json) {
    return Benne(
      id: json['id'],
      fullness: json['fullness'],
      type: json['type'],
      location: json['location'],
      client: json['client'],
      emptying: json['emptying'],
      emptyingDate: json['emptyingDate']?.toDate(),
      lastUpdate: json['lastUpdate']?.toDate(),
      BluetoothDeviceSerial: json['BluetoothDeviceSerial'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullness': fullness,
      'type': type,
      'location': location,
      'client': client,
      'emptying': emptying,
      'emptyingDate': emptyingDate,
      'lastUpdate': lastUpdate,
      'BluetoothDeviceSerial': BluetoothDeviceSerial,
    };
  }
}