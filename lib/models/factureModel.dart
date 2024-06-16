class Facture {
  final String id;
  final String title;
  final String amount;
  final List<Map<String, dynamic>> details;

  Facture({
    required this.id,
    required this.title,
    required this.amount,
    required this.details,
  });

  factory Facture.fromJson(Map<String, dynamic> json) {
    return Facture(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      details: List<Map<String, dynamic>>.from(json['details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'details': details,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'details': details,
    };
  }
}
