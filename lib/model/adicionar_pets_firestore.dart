import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> salvarPetNoFirebase({
  required String nome,
  required String info,
  required String tipo,
  required String porte,
  required String raca,
  required String descricao,
  required File imagemFile, // Imagem do dispositivo
}) async {
  try {
    // 1. Upload para Firebase Storage
    final storageRef = FirebaseStorage.instance.ref().child('pets/$nome.jpg');
    final uploadTask = await storageRef.putFile(imagemFile);
    final downloadUrl = await uploadTask.ref.getDownloadURL();

    // 2. Salvar no Firestore
    await FirebaseFirestore.instance.collection('pets').add({
      'nome': nome,
      'info': info,
      'tipo': tipo,
      'porte': porte,
      'raca': raca,
      'descricao': descricao,
      'imagem': downloadUrl, // URL gerada pelo Storage
    });

    print('Pet salvo com sucesso!');
  } catch (e) {
    print('Erro ao salvar pet: $e');
  }
}
