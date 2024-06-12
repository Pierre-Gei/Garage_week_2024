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
}