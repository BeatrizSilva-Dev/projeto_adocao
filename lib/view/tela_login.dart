import 'package:adocao/view/tela_menu.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
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
              Image.asset("assets/gatinho_cachorrinho.png", width: 430, height: 400,),
              const Text("E-mail"),
              const SizedBox(height: 10.0),
              TextField(
                controller: _emailController,
                cursorColor: Color(0xFF4359E8),
                decoration: const InputDecoration(
                  hintText: 'jane@gmail.com',

                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF4359E8)
                    )
                  ),
                ),

                onTap: () {
                  // Remove hintText temporariamente se quiser
                },
              ),
              const SizedBox(height: 20.0),
              const Text("Senha"),
              const SizedBox(height: 10.0),
              TextField(
                controller: _senhaController,
                cursorColor: Color(0xFF4359E8),

                decoration: const InputDecoration(
                  hintText: '123',
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFF4359E8)
                      )
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30.0),
              Center(
                child: TextButton(
                  onPressed: () {
                    // ação do botão
                    final email = _emailController.text;
                    final senha = _senhaController.text;
                    print('Login: $email / $senha');

                    // Navega para a TelaMenu
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TelaMenu()),
                    );
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
              const SizedBox(height: 20.0),

              // Segundo botão
              Center(
                child: TextButton(
                  onPressed: () {

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
}
