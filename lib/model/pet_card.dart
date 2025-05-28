import 'package:flutter/cupertino.dart';

class PetCard extends StatelessWidget {
  final String nome;
  final String info;
  final String imagem;

  const PetCard({
    super.key,
    required this.nome,
    required this.info,
    required this.imagem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(  // Use Image.network se 'imagem' for URL do Firestore Storage
            imagem,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(info),
      ],
    );
  }
}
