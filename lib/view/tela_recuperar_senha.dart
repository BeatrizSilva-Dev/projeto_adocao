import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TelaRecuperarSenha extends StatefulWidget {
  const TelaRecuperarSenha({super.key});

  @override
  State<TelaRecuperarSenha> createState() => _TelaRecuperarSenhaState();
}

class _TelaRecuperarSenhaState extends State<TelaRecuperarSenha> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _enviando = false;

  Future<void> _enviarLinkRecuperacao() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enviando = true);

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link enviado! Verifique seu e-mail.')),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro ao enviar link.';
      if (e.code == 'user-not-found') {
        msg = 'E-mail não cadastrado.';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }

    setState(() => _enviando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCE6FF), // Fundo azul claro
      appBar: AppBar(
        title: const Text(
          "Redefinição de senha",
          style: TextStyle(
            color: Color(0xFF003366), // Azul escuro
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(color: Color(0xFF003366)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Redefinição de senha!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Informe um email e enviaremos um link para recuperação da sua senha.",
                style: TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: const Color(0xFF4359E8),
                decoration: InputDecoration(
                  hintText: "Email",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4359E8)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite seu e-mail';
                  }
                  if (!value.contains('@')) {
                    return 'Digite um e-mail válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _enviando ? null : _enviarLinkRecuperacao,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4359E8), // Azul forte
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _enviando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Enviar link de recuperação",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
