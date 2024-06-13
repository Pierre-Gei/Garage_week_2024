import 'benneModel.dart';

class Entreprise{
  final String id;
  final String nom;
  final String adresse;
  final String ville;
  final List<Benne> listBenne;

  Entreprise({
    required this.id,
    required this.nom,
    required this.adresse,
    required this.ville,
    required this.listBenne,
  });

  List<Benne> get bennes => listBenne;
}