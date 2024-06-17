import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/benneModel.dart';
import '../models/entrepriseModel.dart';

//classe du service de gestion des entreprises
class EntrepriseServices {
  final CollectionReference _entrepriseCollection =
      FirebaseFirestore.instance.collection('entreprise');

  //ajout d'une entreprise
  Future<void> addEntreprise(Entreprise entreprise) {
    return _entrepriseCollection
        .doc(entreprise.id)
        .set({
          'nom': entreprise.nom,
          'adresse': entreprise.adresse,
          'ville': entreprise.ville,
          'listBenne':
              entreprise.listBenne.map((benne) => benne.toJson()).toList(),
        })
        .then((value) => print('Entreprise added'))
        .catchError((error) => print('Failed to add entreprise: $error'));
  }

  //mise à jour d'une entreprise
  Future<void> updateEntreprise(Entreprise entreprise) {
    return _entrepriseCollection
        .doc(entreprise.id)
        .update({
          'nom': entreprise.nom,
          'adresse': entreprise.adresse,
          'ville': entreprise.ville,
          'listBenne': entreprise.listBenne,
        })
        .then((value) => print('Entreprise updated'))
        .catchError((error) => print('Failed to update entreprise: $error'));
  }

  //suppression d'une entreprise
  Future<void> deleteEntreprise(String id) {
    return _entrepriseCollection
        .doc(id)
        .delete()
        .then((value) => print('Entreprise deleted'))
        .catchError((error) => print('Failed to delete entreprise: $error'));
  }

  //suppression de toutes les entreprises
  Future<void> deleteAllEntreprise() {
    return _entrepriseCollection.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  //suppression de toutes les entreprises d'une ville
  Future<void> removeBenneFromEntreprise(String entrepriseId, Benne bin) {
    return _entrepriseCollection
        .doc(entrepriseId)
        .update({
          'listBenne': FieldValue.arrayRemove([bin.toJson()]),
        })
        .then((value) => print('Benne removed'))
        .catchError((error) => print('Failed to remove benne: $error'));
  }

  //mise à jour de la liste des bennes d'une entreprise
  Future<void> updateBenneList(String entrepriseId, List<String> listBenne) {
    return _entrepriseCollection.doc(entrepriseId).update({
      'listBenne': listBenne,
    });
  }

  //suppression de toutes les bennes d'une entreprise
  Future<void> deleteAllBenneFromEntreprise(String entrepriseId) {
    return _entrepriseCollection.doc(entrepriseId).update({
      'listBenne': [],
    });
  }

  //suppression de toutes les bennes de toutes les entreprises
  Future<void> deleteAllBenne() {
    return _entrepriseCollection.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({
          'listBenne': [],
        });
      }
    });
  }

  //récupération d'une entreprise par son id
  Future<Entreprise> getEntrepriseById(String id) async {
    DocumentSnapshot documentSnapshot =
        await _entrepriseCollection.doc(id).get();
    List<dynamic> listBenneDynamic = documentSnapshot['listBenne'];
    List<Benne> listBenne =
        listBenneDynamic.map((benne) => Benne.fromJson(benne)).toList();
    Entreprise entreprise = Entreprise(
      id: documentSnapshot.id,
      nom: documentSnapshot['nom'],
      adresse: documentSnapshot['adresse'],
      ville: documentSnapshot['ville'],
      listBenne: listBenne,
    );
    return entreprise;
  }

  //récupération d'une entreprise par son nom
  Future<Entreprise> getEntreprise(String nom) async {
    QuerySnapshot querySnapshot =
        await _entrepriseCollection.where('nom', isEqualTo: nom).get();
    List<dynamic> listBenneDynamic = querySnapshot.docs[0]['listBenne'];
    List<Benne> listBenne =
        listBenneDynamic.map((benne) => Benne.fromJson(benne)).toList();
    Entreprise entreprise = Entreprise(
      id: querySnapshot.docs[0].id,
      nom: querySnapshot.docs[0]['nom'],
      adresse: querySnapshot.docs[0]['adresse'],
      ville: querySnapshot.docs[0]['ville'],
      listBenne: listBenne,
    );
    return entreprise;
  }

  //récupération de toutes les entreprises
  Future<List<Entreprise>> getAllEntreprise() async {
    QuerySnapshot querySnapshot = await _entrepriseCollection.get();
    List<Entreprise> listEntreprise = [];
    for (var doc in querySnapshot.docs) {
      List<dynamic> listBenneDynamic = doc['listBenne'];
      List<Benne> listBenne =
          listBenneDynamic.map((benne) => Benne.fromJson(benne)).toList();
      listEntreprise.add(Entreprise(
        id: doc.id,
        nom: doc['nom'],
        adresse: doc['adresse'],
        ville: doc['ville'],
        listBenne: listBenne,
      ));
    }
    return listEntreprise;
  }

  //récupération de toutes les bennes de toutes les entreprises
  Future<List<Benne>> getAllBenne() async {
    QuerySnapshot querySnapshot = await _entrepriseCollection.get();
    List<Benne> listBenne = [];
    for (var doc in querySnapshot.docs) {
      List<dynamic> listBenneDynamic = doc['listBenne'];
      listBenne.addAll(
          listBenneDynamic.map((benne) => Benne.fromJson(benne)).toList());
    }
    return listBenne;
  }

  //ajout d'une benne à une entreprise
  Future<void> addBenneToEntreprise(String entrepriseId, Benne benne) {
    return _entrepriseCollection.doc(entrepriseId).update({
      'listBenne': FieldValue.arrayUnion([benne.toJson()]),
    });
  }

  //mise à jour d'une benne d'une entreprise
  Future<void> updateBenneFromEntreprise(
      String entrepriseId, Benne newBenne) async {
    newBenne.emptying = false;
    newBenne.lastUpdate = DateTime.now();
    DocumentSnapshot docSnapshot =
        await _entrepriseCollection.doc(entrepriseId).get();
    List<dynamic> listBenneDynamic = docSnapshot['listBenne'];
    List<Benne> listBenne =
        listBenneDynamic.map((benne) => Benne.fromJson(benne)).toList();

    int indexToUpdate =
        listBenne.indexWhere((benne) => benne.id == newBenne.id);
    if (indexToUpdate != -1) {
      listBenne[indexToUpdate] = newBenne;

      await _entrepriseCollection.doc(entrepriseId).update({
        'listBenne': listBenne.map((benne) => benne.toJson()).toList(),

      });
      print('Benne with id ${newBenne.id} updated in entreprise with id $entrepriseId');
    } else {
      print(
          'Benne with id ${newBenne.id} not found in entreprise with id $entrepriseId');
    }
  }
}
