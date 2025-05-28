class Usuario {
  final String email;
  final String tipo; // "adotante" ou "ong"
  final String nome;

  Usuario({
    required this.email,
    required this.tipo,
    required this.nome,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'tipo': tipo,
      'nome': nome,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      email: map['email'] ?? '',
      tipo: map['tipo'] ?? '',
      nome: map['nome'] ?? '',
    );
  }
}
