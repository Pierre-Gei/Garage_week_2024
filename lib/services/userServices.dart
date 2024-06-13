import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_week_2024/models/userModel.dart';

class UserServices {
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(User user) {
    return _userCollection.doc(user.id).set({
      'id': user.id,
      'login': user.login,
      'password': user.password,
      'nom': user.nom,
      'ville': user.ville,
      'role': user.role,
      'entrepriseId': user.entrepriseId,
    })
    .then((value) => print('User added'))
    .catchError((error) => print('Failed to add user: $error'));
  }

  Future<void> updateUser(User user) {
    return _userCollection.doc(user.id).update({
      'login': user.login,
      'password': user.password,
      'nom': user.nom,
      'ville': user.ville,
      'role': user.role,
      'entrepriseId': user.entrepriseId,
    })
    .then((value) => print('User updated'))
    .catchError((error) => print('Failed to update user: $error'));
  }

  Future<void> deleteUser(String id) {
    return _userCollection.doc(id).delete()
    .then((value) => print('User deleted'))
    .catchError((error) => print('Failed to delete user: $error'));
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

  Future<User> getUser(String login) async {
    QuerySnapshot querySnapshot = await _userCollection.where('login', isEqualTo: login).get();
    User user = User(
      id: querySnapshot.docs[0].id,
      login: querySnapshot.docs[0]['login'],
      password: querySnapshot.docs[0]['password'],
      nom: querySnapshot.docs[0]['nom'],
      ville: querySnapshot.docs[0]['ville'],
      role: querySnapshot.docs[0]['role'],
      entrepriseId: querySnapshot.docs[0]['entrepriseId'],
    );
    return user;
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
        entrepriseId: doc['entrepriseId'],
      ));
    });
    return users;
  }

  Future<bool> checkUser(String login, String password, String role) async {
    QuerySnapshot querySnapshot = await _userCollection.where('login', isEqualTo: login).where('password', isEqualTo: password).where('role', isEqualTo: role).get();
    return querySnapshot.docs.isNotEmpty;
  }
}