class Benne{
  final String id;
  final double fullness;
  final String type;
  final String location;
  final String client;
  final bool emptying;
  final String? emptyingDate;
  final String? lastUpdate;

  Benne({
    required this.id,
    required this.fullness,
    required this.type,
    required this.location,
    required this.client,
    required this.emptying,
    this.emptyingDate,
    this.lastUpdate,
  });

  factory Benne.fromJson(Map<String, dynamic> json) {
    return Benne(
      id: json['id'],
      fullness: json['fullness'],
      type: json['type'],
      location: json['location'],
      client: json['client'],
      emptying: json['emptying'],
      emptyingDate: json['emptyingDate'],
      lastUpdate: json['lastUpdate'],
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
    };
  }
}