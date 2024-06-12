class User{
  final String id;
  final String login;
  final String password;
  final String email;
  final String nom;
  final String prenom;
  final String adresse;
  final String ville;
  final int role; // 0 = client, 1 = chauffeur, 2 = admin

  User({
    required this.id,
    required this.login,
    required this.password,
    required this.email,
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.ville,
    required this.role,
  });
}