import 'package:adocao/view/tela_menu_adotante.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaRedirecionamento extends StatelessWidget {
  const TelaRedirecionamento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0E8FF),
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/botao_voltar.png', height: 30),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TelaMenu()),
            );
          },
        ),
      ),
      backgroundColor: const Color(0xFFD0E8FF),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Image(
                    image: AssetImage("assets/chat.png"),
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Conversar no WhatsApp',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 120),
                  const Text(
                    'Você será redirecionado para uma conversa\ncom o responsável por este pet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 140),
                  OutlinedButton(
                    onPressed: () async {
                      const telefone = '5587991842218'; // Coloque o número real aqui com DDI+DDD
                      final url = Uri.parse('whatsapp://send?phone=$telefone&text=${Uri.encodeComponent("Olá! Gostaria de falar sobre o pet.")}');

                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Não foi possível abrir o WhatsApp.')),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF4359E8)),
                      backgroundColor: const Color(0xFF4359E8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Conversar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
