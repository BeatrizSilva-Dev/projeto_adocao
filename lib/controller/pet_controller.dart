// lib/controller/pet_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PetController {
  Future<void> atualizarPetsExistentes() async {
    final petsRef = FirebaseFirestore.instance.collection('pets');
    final snapshot = await petsRef.get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({
        'porte': 'Médio',
        'raca': 'Sem raça definida',
      });
    }
  }
}
