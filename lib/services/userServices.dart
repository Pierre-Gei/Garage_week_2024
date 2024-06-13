import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_week_2024/models/userModel.dart';

class UserServices {
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(User user) {
    return _userCollection.add({
      'id': user.id,
      'login': user.login,
      'password': user.password,
      'nom': user.nom,
      'ville': user.ville,
      'role': user.role,
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateUser(User user) {
    return _userCollection.doc(user.id).update({
      'login': user.login,
      'password': user.password,
      'nom': user.nom,
      'ville': user.ville,
      'role': user.role,
    });
  }

  Future<void> deleteUser(String id) {
    return _userCollection.doc(id).delete();
  }

  Future<void> deleteAllUser() {
    return _userCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  Future<void> deleteAllUserFromRole(int role) {
    return _userCollection.where('role', isEqualTo: role).get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  Future<User> getUser(String id) async {
    DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();
    return User(
      id: documentSnapshot.id,
      login: documentSnapshot['login'],
      password: documentSnapshot['password'],
      nom: documentSnapshot['nom'],
      ville: documentSnapshot['ville'],
      role: documentSnapshot['role'],
    );
  }

  Future<List<User>> getAllUser() async {
    QuerySnapshot querySnapshot = await _userCollection.get();
    List<User> users = [];
    querySnapshot.docs.forEach((doc) {
      users.add(User(
        id: doc.id,
        login: doc['login'],
        password: doc['password'],
        nom: doc['nom'],
        ville: doc['ville'],
        role: doc['role'],
      ));
    });
    return users;
  }

  Future<bool> checkUser(String login, String password, String role) async {
    QuerySnapshot querySnapshot = await _userCollection.where('login', isEqualTo: login).where('password', isEqualTo: password).where('role', isEqualTo: role).get();
    return querySnapshot.docs.isNotEmpty;
  }
}