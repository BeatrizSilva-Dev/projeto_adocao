import 'package:adocao/shared/custom_text_field.dart';
import 'package:adocao/view/tela_cadastro.dart';
import 'package:adocao/view/tela_menu_adotante.dart';
import 'package:adocao/view/tela_menu_ong.dart';
import 'package:adocao/view/tela_recuperar_senha.dart'; // ⬅️ IMPORTANTE
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void _mostrarDialogoRecuperarSenha(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaRecuperarSenha()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "assets/gatinho_cachorrinho.png",
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.45,
                fit: BoxFit.cover,
              ),
              const Text("E-mail"),
              const SizedBox(height: 10.0),
              CustomTextField(
                controller: _emailController,
                hintText: 'jane@gmail.com',
                onTap: () {},
              ),
              const SizedBox(height: 10.0),
              const Text("Senha"),
              const SizedBox(height: 10.0),
              TextField(
                controller: _senhaController,
                cursorColor: Color(0xFF4359E8),
                decoration: const InputDecoration(
                  hintText: '123',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF4359E8)),
                  ),
                ),
                obscureText: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _mostrarDialogoRecuperarSenha(context),
                  child: const Text(
                    'Esqueceu a senha?',
                    style: TextStyle(color: Color(0xFF4359E8)),
                  ),
                ),
              ),
              const SizedBox(height: 150),
              Center(
                child: TextButton(
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    final senha = _senhaController.text.trim();

                    try {
                      UserCredential userCredential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(email: email, password: senha);

                      final querySnapshot = await FirebaseFirestore.instance
                          .collection('usuarios')
                          .where('email', isEqualTo: email)
                          .limit(1)
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        final userData = querySnapshot.docs.first.data();
                        final tipo = userData['tipo'];

                        if (tipo == 'adotante') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => TelaMenu()),
                          );
                        } else if (tipo == 'ong') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => TelaMenuOng()),
                          );
                        } else {
                          _mostrarErro('Tipo de usuário desconhecido.');
                        }
                      } else {
                        _mostrarErro('Dados do usuário não encontrados.');
                      }
                    } on FirebaseAuthException catch (e) {
                      String message = '';
                      if (e.code == 'user-not-found') {
                        message = 'Usuário não encontrado.';
                      } else if (e.code == 'wrong-password') {
                        message = 'Senha incorreta.';
                      } else {
                        message = 'Erro: ${e.message}';
                      }
                      _mostrarErro(message);
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF4359E8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Entrar"),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TelaCadastro()),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Color(0xFF4359E8),
                  ),
                  child: const Text("Cadastre-se"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarErro(String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erro'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }
}
