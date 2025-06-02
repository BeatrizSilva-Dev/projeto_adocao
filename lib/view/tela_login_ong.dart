import 'package:adocao/view/tela_menu_adotante.dart';
import 'package:adocao/view/tela_menu_ong.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class TelaLoginOng extends StatelessWidget {
  TelaLoginOng({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpfCnpjController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ValueNotifier<bool> _carregando = ValueNotifier(false);

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  Future<void> _cadastrarUsuario(BuildContext context) async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    final nome = _nomeController.text.trim();
    final celular = _celularController.text.trim();
    final cpfCnpj = _cpfCnpjController.text.trim();

    if (email.isEmpty ||
        senha.isEmpty ||
        nome.isEmpty ||
        celular.isEmpty ||
        cpfCnpj.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos.")),
      );
      return;
    }
    final celularNumerico = celular.replaceAll(RegExp(r'\D'), '');
    if (celularNumerico.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("O celular deve conter exatamente 11 dígitos."),
        ),
      );
      return;
    }
    if (!isEmailValid(email)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("E-mail inválido.")));
      return;
    }

    _carregando.value = true;

    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(cred.user!.uid)
          .set({
            'nome': nome,
            'email': email,
            'cpf/cnpj': cpfCnpj,
            'celular': celular,
            'tipo': 'adotante',
            'criadoEm': FieldValue.serverTimestamp(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cadastro realizado com sucesso!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TelaMenuOng()),
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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensagem)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro inesperado ao cadastrar.")),
      );
    } finally {
      _carregando.value = false;
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF4359E8)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4359E8);

    return Scaffold(
      backgroundColor: const Color(0xFFCFE7FF),
      // cor de fundo suave como na imagem
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          "assets/gatinho_cachorrinho.png",
                          height: MediaQuery.of(context).size.height * 0.35,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Preencha os dados abaixo para se cadastrar",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                const Text("Nome"),
                TextField(
                  controller: _nomeController,
                  decoration: _inputDecoration("Ex: Jane"),
                ),
                const SizedBox(height: 12),

                const Text("CPF/CNPJ"),
                _CpfCnpjField(
                  controller: _cpfCnpjController,
                  decoration: _inputDecoration(
                    "000.000.000-00 ou 00.000.000/0000-00",
                  ),
                ),
                const SizedBox(height: 12),

                const Text("E-mail"),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("jane@gmail.com"),
                ),
                const SizedBox(height: 12),

                const Text("Celular"),
                TextField(
                  controller: _celularController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    PhoneInputFormatter(
                      defaultCountryCode: 'BR',
                      allowEndlessPhone: true,
                    ),
                  ],
                  decoration: _inputDecoration("(99) 99999-9999"),
                ),
                const SizedBox(height: 12),

                const Text("Senha"),
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: _inputDecoration("••••••••"),
                ),

                const SizedBox(height: 30),

                ValueListenableBuilder<bool>(
                  valueListenable: _carregando,
                  builder: (context, carregando, _) {
                    return ElevatedButton(
                      onPressed:
                          carregando ? null : () => _cadastrarUsuario(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          carregando
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "CADASTRAR",
                                style: TextStyle(fontSize: 16),
                              ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CpfCnpjField extends StatefulWidget {
  final TextEditingController controller;
  final InputDecoration decoration;

  const _CpfCnpjField({
    Key? key,
    required this.controller,
    required this.decoration,
  }) : super(key: key);

  @override
  __CpfCnpjFieldState createState() => __CpfCnpjFieldState();
}

class __CpfCnpjFieldState extends State<_CpfCnpjField> {
  late List<TextInputFormatter> _formatters;
  String _mask = '000.000.000-00';

  @override
  void initState() {
    super.initState();
    _formatters = [MaskedInputFormatter(_mask)];
    widget.controller.addListener(_updateFormatter);
  }

  void _updateFormatter() {
    final numeric = toNumericString(widget.controller.text);

    if (numeric.length > 11 && _mask != '00.000.000/0000-00') {
      _mask = '00.000.000/0000-00';
      _formatters = [MaskedInputFormatter(_mask)];
      final text = widget.controller.text;
      widget.controller
        ..removeListener(_updateFormatter)
        ..text = text
        ..selection = TextSelection.collapsed(offset: text.length)
        ..addListener(_updateFormatter);
      setState(() {});
    } else if (numeric.length <= 11 && _mask != '000.000.000-00') {
      _mask = '000.000.000-00';
      _formatters = [MaskedInputFormatter(_mask)];
      final text = widget.controller.text;
      widget.controller
        ..removeListener(_updateFormatter)
        ..text = text
        ..selection = TextSelection.collapsed(offset: text.length)
        ..addListener(_updateFormatter);
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateFormatter);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: _formatters,
      decoration: widget.decoration,
    );
  }
}
