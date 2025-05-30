import 'package:flutter/cupertino.dart';

class PetCard extends StatelessWidget {
  final String nome;
  final String info;
  final String imagem;
  final String porte;
  final String raca;
  final String descricao;

  const PetCard({
    super.key,
    required this.nome,
    required this.info,
    required this.imagem,
    required this.porte,
    required this.raca,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imagem,
                height: 150, // maior imagem
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              nome,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              info,
              style: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text('Porte: $porte', style: const TextStyle(fontSize: 12)),
            Text('Raça: $raca', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              descricao,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

}
