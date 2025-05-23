//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adocao/shared/custom_text_field.dart';
import 'package:adocao/view/tela_menu_ong.dart';

class TelaLoginOng extends StatelessWidget {
  TelaLoginOng({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfCnpjController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _cadastrarUsuario(BuildContext context) async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    final nome = _nomeController.text.trim();
    final cpfCnpj = _cpfCnpjController.text.trim();
    final celular = _celularController.text.trim();

    if (email.isEmpty || senha.isEmpty || nome.isEmpty || cpfCnpj.isEmpty || celular.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos.")),
      );
      return;
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Salvar dados extras no Firestore na coleção 'ongs'
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cadastro realizado com sucesso!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TelaMenuOng()),
      );
    } on FirebaseAuthException catch (e) {
      String mensagem = "Erro ao cadastrar.";
      if (e.code == 'email-already-in-use') {
        mensagem = "E-mail já está em uso.";
      } else if (e.code == 'weak-password') {
        mensagem = "Senha muito fraca (mínimo 6 caracteres).";
      } else if (e.code == 'invalid-email') {
        mensagem = "E-mail inválido.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro inesperado: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Image.asset(
              "assets/gatinho_cachorrinho.png",
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            const Text("Nome"),
            CustomTextField(controller: _nomeController, hintText: 'Jane ONG', onTap: () {}),
            const SizedBox(height: 10),
            const Text("E-mail"),
            CustomTextField(controller: _emailController, hintText: 'jane@gmail.com', onTap: () {}),
            const SizedBox(height: 10),
            const Text("CFP/CNPJ"),
            CustomTextField(controller: _cpfCnpjController, hintText: '000.000.000-00 / 00.000.000/0001-00', onTap: () {}),
            const SizedBox(height: 10),
            const Text("Celular"),
            CustomTextField(controller: _celularController, hintText: '00000-0000', onTap: () {}),
            const SizedBox(height: 10),
            const Text("Senha"),
            TextField(
              controller: _senhaController,
              cursorColor: const Color(0xFF4359E8),
              decoration: const InputDecoration(
                hintText: '••••••••',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4359E8)),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _cadastrarUsuario(context);
                  print("Cadastro OK, navegando...");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const TelaMenuOng()),
                  );
                } catch (e) {
                  print("Erro: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Erro: $e")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4359E8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("CADASTRAR"),
            ),
          ],
        ),
      ),
    );
  }
}
