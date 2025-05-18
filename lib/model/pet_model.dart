class Pet {
  final String nome;
  final String info;
  final String imagem;
  final String tipo; // novo campo

  Pet({
    required this.nome,
    required this.info,
    required this.imagem,
    required this.tipo, // obrigatório agora
  });
}
