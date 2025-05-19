import 'package:adocao/view/tela_redirecionamento.dart';
import 'package:flutter/material.dart';
import 'package:adocao/view/tela_menu_adotante.dart'; // Certifique-se que essa tela existe e está importada corretamente

class TelaIndividual extends StatelessWidget {
  final String nome;
  final String info;
  final String imagem;

  const TelaIndividual({
    super.key,
    required this.nome,
    required this.info,
    required this.imagem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0E8FF),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Image.asset(
                    imagem,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    nome,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    info,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      // Aqui você pode colocar uma lógica real, ou apenas navegar
                     Navigator.push(
                      context,
                       MaterialPageRoute(builder: (context) => const TelaRedirecionamento()),
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
            ),
          ],
        ),
      ),
    );
  }
}

