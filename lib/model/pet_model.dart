class Pet {
  final String nome;
  final String info;
  final String imagem;
  final String tipo;

  Pet({
    required this.nome,
    required this.info,
    required this.imagem,
    required this.tipo,
  });

  // Construtor para criar um Pet a partir de dados do Firebase
  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      nome: map['nome'] ?? '',
      info: map['info'] ?? '',
      imagem: map['imagem'] ?? '',
      tipo: map['tipo'] ?? '',
    );
  }

  // Método para enviar dados ao Firebase
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'info': info,
      'imagem': imagem,
      'tipo': tipo,
    };
  }
}
