class Pet {
  final String nome;
  final String info;
  final String imagem;
  final String tipo;
  final String porte;
  final String raca;
  final String descricao;

  Pet({
    required this.nome,
    required this.info,
    required this.imagem,
    required this.tipo,
    required this.porte,
    required this.raca,
    required this.descricao,
  });

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      nome: map['nome'] ?? '',
      info: map['info'] ?? '',
      imagem: map['imagem'] ?? '',
      tipo: map['tipo'] ?? '',
      porte: map['porte'] ?? '',
      raca: map['raca'] ?? '',
      descricao: map['descricao'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'info': info,
      'imagem': imagem,
      'tipo': tipo,
      'porte': porte,
      'raca': raca,
      'descricao': descricao,
    };
  }
}
