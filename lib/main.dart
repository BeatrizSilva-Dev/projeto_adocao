import 'package:flutter/material.dart';
import 'view/login_view.dart'; // ou o caminho correto

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginView(), // aqui vai o seu Scaffold
    );
  }
}
