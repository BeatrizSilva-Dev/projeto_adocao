import 'package:adocao/model/lista_pets_model.dart';
import 'package:adocao/model/pet_model.dart';
import 'package:adocao/view/tela_add_pet.dart';
import 'package:adocao/view/tela_menu_adotante.dart';
import 'package:adocao/view/tela_menu_ong.dart';
import 'package:flutter/material.dart';
import 'package:adocao/model/pet_model.dart';


class TelaAdocoes extends StatefulWidget {
  const TelaAdocoes({super.key});

  @override
  State<TelaAdocoes> createState() => _TelaAdocoesState();
}

class _TelaAdocoesState extends State<TelaAdocoes> {
  List<Pet> listaPets = List.from(pets); // cópia editável da lista

  void deletarPet(int index) {
    setState(() {
      listaPets.removeAt(index);
    });
  }

  void editarPet(int index) {
    final pet = listaPets[index];
    showDialog(
      context: context,
      builder: (context) {
        final nomeController = TextEditingController(text: pet.nome);
        final infoController = TextEditingController(text: pet.info);

        return AlertDialog(
          title: const Text("Editar Pet"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome')),
              TextField(controller: infoController, decoration: const InputDecoration(labelText: 'Informações')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  listaPets[index] = Pet(
                    nome: nomeController.text,
                    info: infoController.text,
                    imagem: pet.imagem,
                    tipo: pet.tipo,
                  );
                });
                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4E7FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const SizedBox(width: 5),
            const Text("Adoções", style: TextStyle(color: Colors.black)),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listaPets.length,
        itemBuilder: (context, index) {
          final pet = listaPets[index];
          return GestureDetector(
            onTap: () => editarPet(index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF4359E8)),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Image.asset(pet.imagem, width: 80, height: 80, fit: BoxFit.cover),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pet.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(pet.info),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deletarPet(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4359E8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TelaAdicionarPet()),
            );
          },
          child: const Text(
            "ADICIONAR PET",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
