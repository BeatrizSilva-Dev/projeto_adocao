import 'package:adocao/view/tela_adocoes.dart';
import 'package:adocao/view/tela_cachorro.dart';
import 'package:flutter/material.dart';

class TelaMenuOng extends StatelessWidget {
  const TelaMenuOng({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0E8FF), // azul claro
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0E8FF),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              "assets/icone_pata.png", // ícone de pata
              height: 30,
            ),
            const SizedBox(width: 8),
            const Text(
              'Menu',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TelaAdocoes()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF4359E8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Color(0xFF4359E8)), // <-- aqui
                    ),
                  ),
                  child: const Text(
                    'ADOÇÕES',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Image.asset(
            "assets/cao_gatinho.png",
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width * 0.9,
          ),
        ],
      ),
    );
  }
}
