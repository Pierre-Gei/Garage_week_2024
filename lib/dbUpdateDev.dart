import 'package:garage_week_2024/services/userServices.dart';
import 'package:garage_week_2024/models/userModel.dart';

void addUserToDatabase() async {
  var userServices = UserServices();
  await userServices.addUser(User(
    id: '1',
    login: 'client1',
    password: 'client1',
    nom: 'Client 1',
    ville: 'Toulon',
    role: 'client',
  ));
}