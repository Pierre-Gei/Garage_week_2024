import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/factureModel.dart';

//classe du service de gestion des factures
class FactureServices {
  final CollectionReference _factureCollection = FirebaseFirestore.instance.collection('factures');

  //ajout d'une facture
  Future<void> addFacture(Facture facture) {
    return _factureCollection.doc(facture.id).set(facture.toJson())
        .then((value) => print('Facture added'))
        .catchError((error) => print('Failed to add facture: $error'));
  }

  //mise à jour d'une facture
  Future<Facture> getFactureById(String id) async {
    DocumentSnapshot documentSnapshot = await _factureCollection.doc(id).get();
    return Facture.fromJson(documentSnapshot.data() as Map<String, dynamic> ?? {});
  }

  //suppression d'une facture
  Future<List<Facture>> getAllFactures() async {
    QuerySnapshot querySnapshot = await _factureCollection.get();
    return querySnapshot.docs.map((doc) => Facture.fromJson(doc.data() as Map<String, dynamic> ?? {})).toList();
  }
}