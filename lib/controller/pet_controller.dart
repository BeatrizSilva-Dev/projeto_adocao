import 'package:adocao/model/lista_pets_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetController {
  final CollectionReference petsRef =
  FirebaseFirestore.instance.collection('pets');

  Future<void> atualizarPetsComDadosLocais() async {
    final snapshot = await petsRef.get();

    for (var pet in pets) {
      // Encontrar no Firestore o doc que corresponde ao pet pelo nome (exemplo)
      final query = snapshot.docs.where((doc) => doc['nome'] == pet.nome);
      if (query.isNotEmpty) {
        final docRef = query.first.reference;
        await docRef.update(pet.toMap());
      } else {
        // Se não existir, adicionar novo documento
        await petsRef.add(pet.toMap());
      }
    }
  }

// Future<void> atualizarPetsAntigos() async {
  //   final snapshot = await petsRef.get();
  //
  //   for (var doc in snapshot.docs) {
  //     final data = doc.data() as Map<String, dynamic>;
  //
  //     try {
  //       await doc.reference.update({
  //         'porte': data.containsKey('porte') && data['porte'] != null ? data['porte'] : 'Médio',
  //         'raca': data.containsKey('raca') && data['raca'] != null ? data['raca'] : 'Sem raça definida',
  //         'descricao': data.containsKey('descricao') && data['descricao'] != null ? data['descricao'] : 'Pet em busca de um lar amoroso!',
  //       });
  //     } catch (e) {
  //       print('Erro ao atualizar doc ${doc.id}: $e');
  //     }
  //   }
  // }
}
