// tela_cadastro.dart
import 'package:adocao/view/tela_login_adotante.dart';
import 'package:adocao/view/tela_login_ong.dart';
import 'package:flutter/material.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  String? tipoSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Image.asset(
              'assets/cachorros_gato.png',
              width: double.infinity,
              height: 450,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            const Text(
              "Eu sou",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4359E8),
              ),
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSelecaoBotao("INTERESSADO EM ADOTAR"),
                  _buildSelecaoBotao("ONG/TUTOR DOADOR"),
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                onPressed: () {
                  if (tipoSelecionado == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Selecione um tipo de cadastro.")),
                    );
                    return;
                  }

                  if (tipoSelecionado!.toUpperCase().contains("ADOTAR")) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TelaLoginAdotante()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TelaCadastroOng()),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4359E8),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "PRÓXIMO",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelecaoBotao(String texto) {
    final bool selecionado = tipoSelecionado == texto;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            tipoSelecionado = texto;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF4359E8),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
            color: selecionado ? const Color(0xFF4359E8) : Colors.transparent,
          ),
          child: Center(
            child: Text(
              texto,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selecionado ? Colors.white : const Color(0xFF4359E8),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
