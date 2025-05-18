import 'package:adocao/model/lista_pets_model.dart';
import 'package:adocao/view/tela_individual.dart';
import 'package:adocao/view/tela_menu.dart';
import 'package:flutter/material.dart';
import 'tela_cachorro.dart';

class TelaGato extends StatelessWidget {
  const TelaGato({super.key});

  @override
  Widget build(BuildContext context) {
    final gatos = pets.where((p) => p.tipo == 'gato').toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0E8FF),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/icone_pata.png', height: 30),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TelaMenu()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text(
                'Encontre o seu melhor amigo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: List.generate(gatos.length, (index) {
                final pet = gatos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaIndividual(
                          nome: pet.nome,
                          info: pet.info,
                          imagem: pet.imagem,
                        ),
                      ),
                    );
                  },
                  child: PetCard(
                    nome: pet.nome,
                    info: pet.info,
                    imagem: pet.imagem,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaCachorro()),
                );
              },
              child: Image.asset('assets/icone_cachorro.png', height: 40),
            ),

            // Ícone gato - sem clique (já está na tela gato)
            Image.asset('assets/icone_gato.png', height: 40),
          ],
        ),
      ),
    );
  }
}

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
          child: Image.asset(
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
