import 'package:adocao/model/lista_pets_model.dart';
import 'package:adocao/model/pet_model.dart';
import 'package:flutter/material.dart';

class TelaAdicionarPet extends StatefulWidget {
  const TelaAdicionarPet({super.key});

  @override
  State<TelaAdicionarPet> createState() => _TelaAdicionarPetState();
}

class _TelaAdicionarPetState extends State<TelaAdicionarPet> {
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();
  final porteController = TextEditingController();
  String tipoSelecionado = 'cachorro'; // padrão
  String imagemSelecionada = 'assets/cachorro1.jpg'; // pode ser escolhido

  final List<String> imagensCachorro = [
    'assets/cachorro1.jpg',
    'assets/cachorro2.jpg',
    'assets/cachorro3.jpg',
  ];

  final List<String> imagensGato = [
    'assets/gato1.jpg',
    'assets/gato2.jpg',
    'assets/gato3.jpg',
  ];

  void salvarPet() {
    final novoPet = Pet(
      nome: nomeController.text,
      info: 'Idade: ${idadeController.text}\nPorte: ${porteController.text}',
      imagem: imagemSelecionada,
      tipo: tipoSelecionado,
    );

    setState(() {
      pets.add(novoPet);
    });

    Navigator.pop(context); // volta para tela anterior
  }

  @override
  Widget build(BuildContext context) {
    List<String> imagensDisponiveis =
    tipoSelecionado == 'cachorro' ? imagensCachorro : imagensGato;

    return Scaffold(
      appBar: AppBar(title: const Text("Adicionar Pet")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Pet'),
            ),
            TextField(
              controller: idadeController,
              decoration: const InputDecoration(labelText: 'Idade'),
            ),
            TextField(
              controller: porteController,
              decoration: const InputDecoration(labelText: 'Porte'),
            ),
            const SizedBox(height: 16),
            const Text("Tipo do Pet:"),
            Row(
              children: [
                Radio(
                  value: 'cachorro',
                  groupValue: tipoSelecionado,
                  onChanged: (value) {
                    setState(() {
                      tipoSelecionado = value!;
                      imagemSelecionada = imagensCachorro.first;
                    });
                  },
                ),
                const Text("Cachorro"),
                Radio(
                  value: 'gato',
                  groupValue: tipoSelecionado,
                  onChanged: (value) {
                    setState(() {
                      tipoSelecionado = value!;
                      imagemSelecionada = imagensGato.first;
                    });
                  },
                ),
                const Text("Gato"),
              ],
            ),
            const SizedBox(height: 16),
            const Text("Escolha uma imagem:"),
            Wrap(
              spacing: 10,
              children: imagensDisponiveis.map((img) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      imagemSelecionada = img;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: imagemSelecionada == img ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Image.asset(img, width: 80, height: 80, fit: BoxFit.cover),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: salvarPet,
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
