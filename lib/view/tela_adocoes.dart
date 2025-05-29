import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:adocao/view/tela_add_pet.dart';
import 'package:adocao/view/tela_menu_ong.dart';

class TelaAdocoes extends StatefulWidget {
  const TelaAdocoes({super.key});

  @override
  State<TelaAdocoes> createState() => _TelaAdocoesState();
}

class _TelaAdocoesState extends State<TelaAdocoes> {
  void deletarPet(String docId) async {
    await FirebaseFirestore.instance.collection('pets').doc(docId).delete();
  }

  void editarPet(BuildContext context, String docId, String nome, String info) {
    final nomeController = TextEditingController(text: nome);
    final infoController = TextEditingController(text: info);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar Pet"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              cursorColor: const Color(0xFF4359E8),
              decoration: const InputDecoration(
                labelText: 'Nome',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4359E8)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: infoController,
              cursorColor: const Color(0xFF4359E8),
              decoration: const InputDecoration(
                labelText: 'Informações',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4359E8)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('pets').doc(docId).update({
                'nome': nomeController.text,
                'info': infoController.text,
              });
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF4359E8),
              foregroundColor: Colors.white,
            ),
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4E7FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Adoções", style: TextStyle(color: Colors.black)),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pets').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Nenhum pet cadastrado."));
          }

          final pets = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final doc = pets[index];
              final data = doc.data() as Map<String, dynamic>;
              final nome = data['nome'] ?? 'Sem nome';
              final info = data['info'] ?? 'Sem info';
              final imagem = data['imagem'] ?? '';

              return GestureDetector(
                onTap: () => editarPet(context, doc.id, nome, info),
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
                      imagem.isNotEmpty
                          ? Image.network(imagem, width: 80, height: 80, fit: BoxFit.cover)
                          : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(info),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deletarPet(doc.id),
                      ),
                    ],
                  ),
                ),
              );
            },
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
