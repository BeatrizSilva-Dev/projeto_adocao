import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show File;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adocao/model/pet_model.dart';
import 'package:adocao/view/tela_menu_ong.dart';

class TelaAdicionarPet extends StatefulWidget {
  const TelaAdicionarPet({super.key});

  @override
  State<TelaAdicionarPet> createState() => _TelaAdicionarPetState();
}

class _TelaAdicionarPetState extends State<TelaAdicionarPet> {
  final _formKey = GlobalKey<FormState>();

  final picker = ImagePicker();
  File? imagemSelecionada;
  Uint8List? imagemSelecionadaBytes;

  String nome = '';
  String especie = 'cachorro';
  String raca = '';
  String idade = '';
  String porte = 'Pequeno';
  String descricao = '';

  Future<void> _selecionarImagem() async {
    try {
      if (kIsWeb) {
        // Web usa image_picker
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            imagemSelecionada = null;
            imagemSelecionadaBytes = bytes;
          });
        }
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Desktop usa file_selector
        final typeGroup = XTypeGroup(label: 'images', extensions: ['jpg', 'jpeg', 'png']);
        final file = await openFile(acceptedTypeGroups: [typeGroup]);

        if (file != null) {
          final bytes = await file.readAsBytes();
          setState(() {
            imagemSelecionada = null;
            imagemSelecionadaBytes = bytes;
          });
        }
      } else {
        // Mobile usa image_picker
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            imagemSelecionada = File(pickedFile.path);
            imagemSelecionadaBytes = null;
          });
        }
      }
    } catch (e) {
      print('Erro ao selecionar imagem: $e');
    }
  }

  Future<String?> _uploadImagem() async {
    final clientId = 'f597663af74bbc4';

    try {
      if (kIsWeb && imagemSelecionadaBytes != null) {
        final response = await http.post(
          Uri.parse('https://api.imgur.com/3/image'),
          headers: {
            'Authorization': 'Client-ID $clientId',
          },
          body: {
            'image': base64Encode(imagemSelecionadaBytes!),
            'type': 'base64',
          },
        );

        final data = jsonDecode(response.body);
        return data['data']['link'];
      } else if (!kIsWeb && imagemSelecionada != null) {
        final bytes = await imagemSelecionada!.readAsBytes();
        final response = await http.post(
          Uri.parse('https://api.imgur.com/3/image'),
          headers: {
            'Authorization': 'Client-ID $clientId',
          },
          body: {
            'image': base64Encode(bytes),
            'type': 'base64',
          },
        );

        final data = jsonDecode(response.body);
        return data['data']['link'];
      } else {
        return null;
      }
    } catch (e) {
      print("Erro ao enviar imagem para o Imgur: $e");
      return null;
    }
  }

  Future<void> _salvarPet() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final urlImagem = await _uploadImagem();
    final ongId = FirebaseAuth.instance.currentUser?.uid;

    final pet = Pet(
      nome: nome,
      tipo: especie,
      info: '$raca, $idade',
      imagem: urlImagem ?? '',
      porte: '$porte',
      raca: '$raca',
      descricao: '$descricao',
    );

    await FirebaseFirestore.instance.collection('pets').add({
      ...pet.toMap(),
      'ongId': ongId,
      'dataCadastro': Timestamp.now(),
      'descricao': descricao,
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
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          width: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),

          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/icone_pata.png', height: 30),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const TelaMenuOng()),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Adoções",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      'assets/cachorro_gato2.png',
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.30,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      hintText: 'Ex: Bob',
                    ),
                    onSaved: (val) => nome = val ?? '',
                    validator: (val) => val == null || val.isEmpty ? 'Digite o nome' : null,
                  ),
                  const SizedBox(height: 20),
                  const Text("Espécie"),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => setState(() => especie = 'cachorro'),
                        icon: Image.asset('assets/icone_cachorro.png', height: 40),
                      ),
                      const Text("Cachorro"),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () => setState(() => especie = 'gato'),
                        icon: Image.asset('assets/icone_gato.png', height: 40),
                      ),
                      const Text("Gato"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Raça',
                      hintText: 'Ex: Labrador',
                    ),
                    onSaved: (val) => raca = val ?? '',
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Idade',
                      hintText: 'Ex: 2 (anos)',
                    ),
                    onSaved: (val) => idade = val ?? '',
                  ),
                  const SizedBox(height: 10),
                  const Text('Porte'),
                  Column(
                    children: ['Pequeno', 'Médio', 'Grande']
                        .map((p) => RadioListTile(
                      title: Text(p),
                      value: p,
                      groupValue: porte,
                      activeColor: primaryColor,
                      onChanged: (value) => setState(() => porte = value!),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _selecionarImagem,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Adicionar Foto"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(40),
                    ),
                  ),
                  if ((kIsWeb && imagemSelecionadaBytes != null) ||
                      (!kIsWeb && imagemSelecionada != null))
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: kIsWeb
                          ? Image.memory(imagemSelecionadaBytes!, height: 100)
                          : Image.file(imagemSelecionada!, height: 100),
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      hintText: 'Conte um pouco sobre o pet...',
                    ),
                    onSaved: (val) => descricao = val ?? '',
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _salvarPet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(45),
                    ),
                    child: const Text('SALVAR'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
