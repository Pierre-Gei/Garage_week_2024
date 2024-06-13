class User{
  final String id;
  final String login;
  final String password;
  final String nom;
  final String ville;
  final String role;
  final String entrepriseId;

  User({
    required this.id,
    required this.login,
    required this.password,
    required this.nom,
    required this.ville,
    required this.role,
    required this.entrepriseId,
  });
}