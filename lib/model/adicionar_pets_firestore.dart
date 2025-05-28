import 'package:adocao/model/lista_pets_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

Future<void> adicionarPetsAoFirestore() async {
  for (var pet in pets) {
    // Carrega a imagem dos assets como bytes
    final byteData = await rootBundle.load(pet.imagem);
    final bytes = byteData.buffer.asUint8List();

    // Define o caminho no Storage
    final storageRef = FirebaseStorage.instance.ref().child('pets/${pet.nome}.jpg');

    try {
      // Faz o upload
      final uploadTask = await storageRef.putData(bytes);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // Cria o documento no Firestore com a URL da imagem
      await FirebaseFirestore.instance.collection('pets').add({
        'nome': pet.nome,
        'info': pet.info,
        'imagem': downloadUrl, // agora é uma URL pública
        'tipo': pet.tipo,
      });
    } catch (e) {
      print('Erro ao enviar ${pet.nome}: $e');
    }
  }
}
