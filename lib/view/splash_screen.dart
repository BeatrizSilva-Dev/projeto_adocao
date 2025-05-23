import 'dart:async';
import 'package:flutter/material.dart';
import 'tela_login.dart'; // sua tela de login

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //Espera 3 segundos antes de redirecionar para a tela de login
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
       context,
       MaterialPageRoute(builder: (context) => const LoginView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffcfe7ff),
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Coloque esse arquivo dentro da pasta assets
          height: MediaQuery.of(context).size.height * 0.45,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
