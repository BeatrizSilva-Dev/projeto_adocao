import 'package:adocao/shared/custom_text_field.dart';
import 'package:adocao/view/tela_menu_adotante.dart';
import 'package:adocao/view/tela_menu_ong.dart';
import 'package:flutter/material.dart';

class TelaLoginOng extends StatelessWidget {
  TelaLoginOng({super.key});
  final TextEditingController _login_adotante_Controller = TextEditingController();
  final TextEditingController _nome_adotante_Controller = TextEditingController();
  final TextEditingController _cpf_adotante_Controller = TextEditingController();
  final TextEditingController _cel_adotante_Controller = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            //const SizedBox(height: 5),
            Image.asset(
              "assets/gatinho_cachorrinho.png",
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            //const SizedBox(height: 20),
            const Text("Nome"),
            CustomTextField(controller: _nome_adotante_Controller, hintText: 'jane', onTap: (){}, ),
            const SizedBox(height: 10),
            const Text("E-mail"),
            CustomTextField(controller: _login_adotante_Controller, hintText: 'jane@gmail.com', onTap: (){}, ),
            const SizedBox(height: 10),
            const Text("CFP/CNPJ"),
            CustomTextField(controller: _cpf_adotante_Controller, hintText: '000.000.000-00/00.000.000/0001-00', onTap: (){}, ),
            const SizedBox(height: 10),
            const Text("Celular"),
            CustomTextField(controller: _cel_adotante_Controller, hintText: '00000-0000', onTap: (){}, ),
            const SizedBox(height: 10),
            const Text("Senha"),
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
            const SizedBox(height: 40),
            _buildButton(context, "CADASTRAR"),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        obscureText: isPassword,
        cursorColor: Color(0xFF4359E8),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TelaMenuOng()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4359E8),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(label.toUpperCase()),
    );
  }
}
