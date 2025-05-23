import 'dart:io';
import 'package:adocao/view/tela_menu_ong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TelaAdicionarPet extends StatefulWidget {
  const TelaAdicionarPet({Key? key}) : super(key: key);

  @override
  State<TelaAdicionarPet> createState() => _TelaAdicionarPetState();
}

class _TelaAdicionarPetState extends State<TelaAdicionarPet> {
  final _formKey = GlobalKey<FormState>();

  String nome = '';
  String especie = 'cachorro';
  String raca = '';
  String idade = '';
  String porte = 'Pequeno';
  String descricao = '';
  File? imagemSelecionada;

  final picker = ImagePicker();

  Future<void> _selecionarImagem() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagemSelecionada = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImagem() async {
    if (imagemSelecionada == null) return null;

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child('pets/$fileName.jpg');
    await ref.putFile(imagemSelecionada!);
    return await ref.getDownloadURL();
  }

  Future<void> _salvarPet() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final urlImagem = await _uploadImagem();

    await FirebaseFirestore.instance.collection('pets').add({
      'nome': nome,
      'especie': especie,
      'raca': raca,
      'idade': idade,
      'porte': porte,
      'descricao': descricao,
      'imagemUrl': urlImagem ?? '',
      'dataCadastro': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pet salvo com sucesso!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4359E8);

    return Scaffold(
      backgroundColor: const Color(0xFFD4E7FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            SizedBox(width: 5),
            Text("Adoções", style: TextStyle(color: Colors.black)),
          ],
        ),
        leading: IconButton(
          icon: Image.asset('assets/icone_pata.png', height: 30),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TelaMenuOng()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/cachorro_gato2.png',
                    height: MediaQuery.of(context).size.height * 0.28,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  labelStyle: TextStyle(color: primaryColor),
                ),
                cursorColor: primaryColor,
                onSaved: (value) => nome = value ?? '',
                validator: (value) =>
                value == null || value.isEmpty ? 'Digite o nome' : null,
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Espécie"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Image.asset('assets/icone_cachorro.png', height: 40),
                    onPressed: () => setState(() => especie = 'cachorro'),
                    color: especie == 'cachorro' ? primaryColor : null,
                  ),
                  IconButton(
                    icon: Image.asset('assets/icone_gato.png', height: 40),
                    onPressed: () => setState(() => especie = 'gato'),
                    color: especie == 'gato' ? primaryColor : null,
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Raça',
                  labelStyle: TextStyle(color: primaryColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                ),
                cursorColor: primaryColor,
                onSaved: (value) => raca = value ?? '',
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Idade',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        labelStyle: TextStyle(color: primaryColor),
                      ),
                      cursorColor: primaryColor,
                      onSaved: (value) => idade = value ?? '',
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text("Porte:"),
                  Expanded(
                    child: Column(
                      children: [
                        RadioListTile(
                          title: const Text('Pequeno'),
                          value: 'Pequeno',
                          groupValue: porte,
                          activeColor: primaryColor,
                          onChanged: (value) => setState(() => porte = value!),
                        ),
                        RadioListTile(
                          title: const Text('Médio'),
                          value: 'Médio',
                          groupValue: porte,
                          activeColor: primaryColor,
                          onChanged: (value) => setState(() => porte = value!),
                        ),
                        RadioListTile(
                          title: const Text('Grande'),
                          value: 'Grande',
                          groupValue: porte,
                          activeColor: primaryColor,
                          onChanged: (value) => setState(() => porte = value!),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Foto"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _selecionarImagem,
                  ),
                  const SizedBox(width: 10),
                  if (imagemSelecionada != null)
                    Image.file(imagemSelecionada!, height: 80),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  labelStyle: TextStyle(color: primaryColor),
                ),
                cursorColor: primaryColor,
                onSaved: (value) => descricao = value ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarPet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('SALVAR'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
