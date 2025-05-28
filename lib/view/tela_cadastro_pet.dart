import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaCadastroPet extends StatefulWidget {
  const TelaCadastroPet({super.key});

  @override
  State<TelaCadastroPet> createState() => _TelaCadastroPetState();
}

class _TelaCadastroPetState extends State<TelaCadastroPet> {
  final nomeController = TextEditingController();
  final infoController = TextEditingController();
  String tipo = 'cachorro';
  File? imagemSelecionada;

  final picker = ImagePicker();

  Future<void> escolherImagem() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagemSelecionada = File(pickedFile.path);
      });
    }
  }

  Future<void> salvarPet() async {
    if (imagemSelecionada == null) return;

    // Upload da imagem
    final nomeArquivo = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance.ref().child('pets/$nomeArquivo.jpg');
    await storageRef.putFile(imagemSelecionada!);
    final urlImagem = await storageRef.getDownloadURL();

    // Salvar dados no Firestore
    await FirebaseFirestore.instance.collection('pets').add({
      'nome': nomeController.text,
      'info': infoController.text,
      'imagem': urlImagem,
      'tipo': tipo,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pet cadastrado com sucesso!')),
    );

    nomeController.clear();
    infoController.clear();
    setState(() {
      imagemSelecionada = null;
      tipo = 'cachorro';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Pet')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome')),
              TextField(controller: infoController, decoration: const InputDecoration(labelText: 'Info')),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: tipo,
                onChanged: (value) => setState(() => tipo = value!),
                items: ['cachorro', 'gato'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: escolherImagem,
                child: const Text('Selecionar Imagem'),
              ),
              if (imagemSelecionada != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.file(imagemSelecionada!, height: 100),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: salvarPet,
                child: const Text('Salvar Pet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
