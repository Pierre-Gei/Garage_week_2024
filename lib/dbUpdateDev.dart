import 'package:garage_week_2024/services/entrepriseServices.dart';
import 'package:garage_week_2024/services/userServices.dart';
import 'package:garage_week_2024/models/userModel.dart';

import 'models/benneModel.dart';
import 'models/entrepriseModel.dart';

void addUserToDatabase() async {
  var userServices = UserServices();
  await userServices.addUser(User(
    id: '1',
    login: 'client1',
    password: 'client1',
    nom: 'Client 1',
    ville: 'Toulon',
    role: 'client',
    entrepriseId: '1',
  ));
  var entrepriseServices = EntrepriseServices();
  await entrepriseServices.addEntreprise(Entreprise(
    id: '1',
    nom: 'Entreprise 1',
    adresse: '1 rue de la Paix',
    ville: 'Toulon',
    listBenne: [
      Benne(
        id: '1',
        type: 'plastique',
        fullness: 0.8,
        location: 'Toulon',
        client: 'Entreprise 1',
        emptying: false,
      ),
      Benne(
        id: '2',
        type: 'verre',
        fullness: 0.5,
        location: 'Toulon',
        client: 'Entreprise 1',
        emptying: false,
      ),
    ],
  ));
}