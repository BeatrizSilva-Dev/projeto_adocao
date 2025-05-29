import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adocao/view/tela_redirecionamento.dart';

class TelaIndividual extends StatelessWidget {
  final String petId;

  const TelaIndividual({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('pets').doc(petId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Animal não encontrado'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final nome = data['nome'] ?? 'Sem nome';
          final info = data['info'] ?? 'Sem info';
          final imagem = data['imagem'] ?? '';

          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.network(
                      imagem,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 40, // Abaixado para evitar corte
                      left: 16,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          'assets/botao_voltar.png', // sua imagem personalizada
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  nome,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    info,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TelaRedirecionamento(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF4359E8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Adotar"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
