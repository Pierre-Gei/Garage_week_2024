import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_week_2024/models/entrepriseModel.dart';

import '../models/benneModel.dart';


class EntrepriseServices {
  final CollectionReference _entrepriseCollection = FirebaseFirestore.instance
      .collection('entreprise');

  Future<void> addEntreprise(Entreprise entreprise) {
    return _entrepriseCollection.doc(entreprise.id).set({
      'nom': entreprise.nom,
      'adresse': entreprise.adresse,
      'ville': entreprise.ville,
      'listBenne': entreprise.listBenne.map((benne) => benne.toJson()).toList(),
    })
        .then((value) => print('Entreprise added'))
        .catchError((error) => print('Failed to add entreprise: $error'));
  }

  Future<void> updateEntreprise(Entreprise entreprise) {
    return _entrepriseCollection.doc(entreprise.id).update({
      'nom': entreprise.nom,
      'adresse': entreprise.adresse,
      'ville': entreprise.ville,
      'listBenne': entreprise.listBenne,
    })
    .then((value) => print('Entreprise updated'))
    .catchError((error) => print('Failed to update entreprise: $error'));
  }

  Future<void> deleteEntreprise(String id) {
    return _entrepriseCollection.doc(id).delete()
    .then((value) => print('Entreprise deleted'))
    .catchError((error) => print('Failed to delete entreprise: $error'));
  }

  Future<void> deleteAllEntreprise() {
    return _entrepriseCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
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

Future<Entreprise> getEntrepriseById(String id) async {
  DocumentSnapshot documentSnapshot = await _entrepriseCollection.doc(id).get();
  List<dynamic> listBenneDynamic = documentSnapshot['listBenne'];
  List<Benne> listBenne = listBenneDynamic.map((benne) => Benne.fromJson(benne)).toList();
  Entreprise entreprise = Entreprise(
    id: documentSnapshot.id,
    nom: documentSnapshot['nom'],
    adresse: documentSnapshot['adresse'],
    ville: documentSnapshot['ville'],
    listBenne: listBenne,
  );
  return entreprise;
}

  Future<Entreprise> getEntreprise(String nom) async {
    QuerySnapshot querySnapshot = await _entrepriseCollection.where('nom', isEqualTo: nom).get();
    List<Benne> listBenne = querySnapshot.docs[0]['listBenne'].map((benne) => Benne.fromJson(benne)).toList();  // Convert each Map<String, dynamic> to Benne
    Entreprise entreprise = Entreprise(
      id: querySnapshot.docs[0].id,
      nom: querySnapshot.docs[0]['nom'],
      adresse: querySnapshot.docs[0]['adresse'],
      ville: querySnapshot.docs[0]['ville'],
      listBenne: listBenne,
    );
    return entreprise;
  }

  Future<List<Entreprise>> getAllEntreprise() async {
    QuerySnapshot querySnapshot = await _entrepriseCollection.get();
    List<Entreprise> listEntreprise = [];
    querySnapshot.docs.forEach((doc) {
      List<dynamic> listBenneDynamic = doc['listBenne'];
      List<Benne> listBenne = listBenneDynamic.map((benne) => Benne.fromJson(benne)).toList();
      listEntreprise.add(Entreprise(
        id: doc.id,
        nom: doc['nom'],
        adresse: doc['adresse'],
        ville: doc['ville'],
        listBenne: listBenne,
      ));
    });
    return listEntreprise;
  }

Future<List<Benne>> getAllBenne() async {
  QuerySnapshot querySnapshot = await _entrepriseCollection.get();
  List<Benne> listBenne = [];
  querySnapshot.docs.forEach((doc) {
    List<dynamic> listBenneDynamic = doc['listBenne'];
    listBenne.addAll(listBenneDynamic.map((benne) => Benne.fromJson(benne)).toList());
  });
  return listBenne;
}

  Future<void> addBenneToEntreprise(String entrepriseId, Benne benne) {
    return _entrepriseCollection.doc(entrepriseId).update({
      'listBenne': FieldValue.arrayUnion([benne.toJson()]),
    });
  }

  Future<void> updateBenneFromEntreprise(String entrepriseId, Benne benne) {
    return _entrepriseCollection.doc(entrepriseId).update({
      'listBenne': FieldValue.arrayUnion([benne.toJson()]),
    });
  }
}
