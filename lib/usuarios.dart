class Usuario {
  final int id;
  final String usuario;
  final String password;
  final String email;

  Usuario({
    required this.id,
    required this.usuario,
    required this.password,
    required this.email,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      usuario: map['usuario'],
      password: map['password'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario': usuario,
      'password': password,
      'email': email,
    };
  }
}