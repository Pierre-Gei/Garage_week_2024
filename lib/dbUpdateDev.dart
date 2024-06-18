// import 'package:garage_week_2024/models/benneModel.dart';
// import 'package:garage_week_2024/models/entrepriseModel.dart';
// import 'package:garage_week_2024/services/entrepriseServices.dart';
// import 'package:garage_week_2024/services/factureService.dart';
// import 'package:garage_week_2024/services/userServices.dart';
//
// import 'models/factureModel.dart';
// import 'models/userModel.dart';
//
// //ajout des données de test dans la base de données
// //pour les tests UNIQUEMENT !
// void addUserToDatabase() async {
//   var userServices = UserServices();
//   await userServices.addUser(User(
//     id: '1',
//     login: 'client1',
//     password: 'client1',
//     nom: 'Client 1',
//     ville: 'Toulon',
//     role: 'client',
//     entrepriseId: '1',
//   ));
//   var entrepriseServices = EntrepriseServices();
//   await entrepriseServices.addEntreprise(Entreprise(
//     id: '1',
//     nom: 'Entreprise 1',
//     adresse: '1 rue de la Paix',
//     ville: 'Toulon',
//     listBenne: [],
//   ));
//   await userServices.addUser(User(
//     id: '4',
//     login: 'client2',
//     password: 'client2',
//     nom: 'Client 2',
//     ville: 'Toulon',
//     role: 'client',
//     entrepriseId: '2',
//   ));
//   await entrepriseServices.addEntreprise(Entreprise(
//     id: '2',
//     nom: 'Entreprise 2',
//     adresse: '2 rue de la Paix',
//     ville: 'Toulon',
//     listBenne: [],
//   ));
//   await userServices.addUser(User(
//     id: '2',
//     login : 'driver1',
//     password : 'driver1',
//     nom : 'Michel',
//     ville : 'Toulon',
//     role : 'chauffeur',
//     entrepriseId : 'NA',
//   ));
//   await userServices.addUser(User(
//     id: '3',
//     login : 'admin1',
//     password : 'admin1',
//     nom : 'Admin 1',
//     ville : 'Toulon',
//     role : 'veolia',
//     entrepriseId : 'NA',
//   ));
//   var factureServices = FactureServices();
//   await factureServices.addFacture(Facture(
//     id: '1',
//     title: 'Facture 1',
//     amount: '1000',
//     details: [
//       {
//         'item': 'Plastique',
//         'quantity': 10,
//         'unitPrice': 1.0,
//         'total': 10.0,
//       },
//       {
//         'item': 'Verre',
//         'quantity': 5,
//         'unitPrice': 2.0,
//         'total': 10.0,
//       },
//     ],
//   ));
//   await factureServices.addFacture(Facture(
//     id: '2',
//     title: 'Facture 2',
//     amount: '2000',
//     details: [
//       {
//         'item': 'Plastique',
//         'quantity': 20,
//         'unitPrice': 1.0,
//         'total': 20.0,
//       },
//       {
//         'item': 'Verre',
//         'quantity': 10,
//         'unitPrice': 2.0,
//         'total': 20.0,
//       },
//     ],
//   ));
// }