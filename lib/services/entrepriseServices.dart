import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_week_2024/models/entrepriseModel.dart';


class EntrepriseServices {
  final CollectionReference _entrepriseCollection = FirebaseFirestore.instance
      .collection('entreprise');

  Future<void> addEntreprise(Entreprise entreprise) {
    return _entrepriseCollection.add({
      'id': entreprise.id,
      'nom': entreprise.nom,
      'adresse': entreprise.adresse,
      'ville': entreprise.ville,
      'listBenne': entreprise.listBenne,
    })
        .then((value) => print("Entreprise Added"))
        .catchError((error) => print("Failed to add entreprise: $error"));
  }

  Future<void> updateEntreprise(Entreprise entreprise) {
    return _entrepriseCollection.doc(entreprise.id).update({
      'nom': entreprise.nom,
      'adresse': entreprise.adresse,
      'ville': entreprise.ville,
      'listBenne': entreprise.listBenne,
    });
  }

  Future<void> deleteEntreprise(String id) {
    return _entrepriseCollection.doc(id).delete();
  }

  Future<void> addBenneToEntreprise(String entrepriseId, String benneId) {
    return _entrepriseCollection.doc(entrepriseId).update({
      'listBenne': FieldValue.arrayUnion([benneId]),
    });
  }

  Future<void> removeBenneFromEntreprise(String entrepriseId, String benneId) {
    return _entrepriseCollection.doc(entrepriseId).update({
      'listBenne': FieldValue.arrayRemove([benneId]),
    });
  }

  Future<void> updateBenneList(String entrepriseId, List<String> listBenne) {
    return _entrepriseCollection.doc(entrepriseId).update({
      'listBenne': listBenne,
    });
  }

  Future<void> deleteAllBenneFromEntreprise(String entrepriseId) {
    return _entrepriseCollection.doc(entrepriseId).update({
      'listBenne': [],
    });
  }

  Future<void> deleteAllBenne() {
    return _entrepriseCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({
          'listBenne': [],
        });
      });
    });
  }

  Future<Entreprise> getEntreprise(String id) async {
    DocumentSnapshot doc = await _entrepriseCollection.doc(id).get();
    return Entreprise(
      id: id,
      nom: doc['nom'],
      adresse: doc['adresse'],
      ville: doc['ville'],
      listBenne: doc['listBenne'],
    );
  }

  Future<List<Entreprise>> getAllEntreprise() async {
    QuerySnapshot querySnapshot = await _entrepriseCollection.get();
    List<Entreprise> listEntreprise = [];
    querySnapshot.docs.forEach((doc) {
      listEntreprise.add(Entreprise(
        id: doc.id,
        nom: doc['nom'],
        adresse: doc['adresse'],
        ville: doc['ville'],
        listBenne: doc['listBenne'],
      ));
    });
    return listEntreprise;
  }
}
