import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_week_2024/models/benneModel.dart';

class benneServices {
  final CollectionReference _benneCollection = FirebaseFirestore.instance.collection('benne');

  Future<void> addBenne(Benne benne) {
    return _benneCollection.add({
      'id': benne.id,
      'type': benne.type,
      'client': benne.client,
      'fullness': benne.fullness,
      'location': benne.location,
      'emptying': benne.emptying,
      'emptyingDate': benne.emptyingDate ?? '',
      'date': DateTime.now(),
    })
    .then((value) => print("Benne Added"))
    .catchError((error) => print("Failed to add benne: $error"));
  }

  Future<void> updateBenne(Benne benne) {
    return _benneCollection.doc(benne.id).update({
      'type': benne.type,
      'client': benne.client,
      'fullness': benne.fullness,
      'location': benne.location,
      'emptying': benne.emptying,
    });
  }

  Future<void> deleteBenne(String id) {
    return _benneCollection.doc(id).delete();
  }

}