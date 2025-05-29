import 'package:adocao/controller/pet_controller.dart';
import 'package:adocao/model/lista_pets_model.dart';
import 'package:adocao/model/pet_card.dart';
import 'package:adocao/model/pet_model.dart';
import 'package:adocao/view/tela_gato.dart';
import 'package:adocao/view/tela_individual.dart';
import 'package:adocao/view/tela_menu_adotante.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final petController = PetController();

class TelaCachorro extends StatelessWidget {
  const TelaCachorro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0E8FF),
        elevation: 0,
        automaticallyImplyLeading: false, // Remove a seta
        title: Row(
          children: [
            IconButton(
              icon: Image.asset('assets/icone_pata.png', height: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TelaMenu()),
                );
              },
            ),
            const SizedBox(width: 8),
            const Text(
              'Menu',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text(
                'Encontre o seu melhor amigo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     await petController.atualizarPetsExistentes();
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text("Pets atualizados com sucesso")),
          //     );
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: const Color(0xFF4359E8),
          //     foregroundColor: Colors.white,
          //   ),
          //   child: const Text('Atualizar Pets no Firebase'),
          // ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('pets')
                  .where('tipo', isEqualTo: 'cachorro')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final documentos = snapshot.data!.docs;
                final cachorros = documentos
                    .map((doc) => Pet.fromMap(doc.data()))
                    .toList();

                return GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: List.generate(documentos.length, (index) {
                    final doc = documentos[index];
                    final pet = Pet.fromMap(doc.data());

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaIndividual(petId: doc.id),
                          ),
                        );
                      },
                      child: PetCard(
                        nome: pet.nome,
                        info: pet.info,
                        imagem: pet.imagem,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/icone_cachorro.png', height: 40),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaGato()),
                );
              },
              child: Image.asset('assets/icone_gato.png', height: 40),
            ),
          ],
        ),
      ),
    );
  }
}
