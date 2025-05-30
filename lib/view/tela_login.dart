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

  // void _realizarLogin(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const TelaCadastro()),
  //   );
  // }
  void _mostrarDialogoRecuperarSenha(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaRecuperarSenha()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFE7FF), // cor de fundo suave como na imagem
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🐶🐱 imagem
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    "assets/gatinho_cachorrinho.png",
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.45,
                    fit: BoxFit.cover,

                  ),
                ),
                const SizedBox(height: 20),

                // 📧 Campo de e-mail
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("E-mail", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Color(0xFF4359E8),
                  decoration: InputDecoration(
                    hintText: 'jane@gmail.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4359E8)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),


                // 🔒 Campo de senha
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Senha", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  cursorColor: Color(0xFF4359E8),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4359E8)),
                    ),
                  ),
                ),

                // 🔗 Link "Esqueceu a senha?"
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

                const SizedBox(height: 12),

                // 🔘 Botão Entrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4359E8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Entrar", style: TextStyle(fontSize: 16)),
                  ),
                ),


                const SizedBox(height: 16),

                // 📝 Link "Cadastre-se"
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Não tem uma conta? "),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TelaCadastro()),
                        );
                      },
                      child: const Text(
                        "Cadastre-se",
                        style: TextStyle(color: Color(0xFF4359E8)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
