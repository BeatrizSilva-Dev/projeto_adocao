import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adocao/shared/custom_text_field.dart';
import 'package:adocao/view/tela_menu_adotante.dart';

class TelaCadastroOng extends StatelessWidget {
  TelaCadastroOng({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ValueNotifier<bool> _carregando = ValueNotifier(false);

  Future<void> _cadastrarUsuario(BuildContext context) async {
    final email = _emailController.text.trim();
    final cnpj = _cnpjController.text.trim();
    final senha = _senhaController.text.trim();
    final nome = _nomeController.text.trim();
    final celular = _celularController.text.trim();

    if (email.isEmpty || senha.isEmpty || nome.isEmpty || celular.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos.")),
      );
      return;
    }

    _carregando.value = true;

    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await FirebaseFirestore.instance.collection('usuarios').doc(cred.user!.uid).set({
        'nome': nome,
        'cnpj/cpf': cnpj,
        'email': email,
        'celular': celular,
        'tipo': 'adotante',
        'criadoEm': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cadastro realizado com sucesso!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TelaMenu()),
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
        const SnackBar(content: Text("Erro inesperado ao cadastrar.")),
      );
    } finally {
      _carregando.value = false;
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
            CustomTextField(controller: _nomeController, hintText: 'jane', onTap: () {}),
            const SizedBox(height: 10),
            const Text("CNPJ/CPF"),
            CustomTextField(controller: _cnpjController, hintText: '000.000.000-00/00.000.000/0001-00', onTap: () {}),
            const SizedBox(height: 10),
            const Text("E-mail"),
            CustomTextField(controller: _emailController, hintText: 'jane@gmail.com', onTap: () {}),
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
            ValueListenableBuilder<bool>(
              valueListenable: _carregando,
              builder: (context, carregando, _) {
                return ElevatedButton(
                  onPressed: carregando ? null : () => _cadastrarUsuario(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4359E8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: carregando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("CADASTRAR"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
