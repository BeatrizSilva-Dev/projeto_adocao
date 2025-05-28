import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
    required String tipo, // "ong" ou "adotante"
  }) async {
    try {
      // Cria o usuário com Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Salva os dados no Firestore
      await _firestore.collection('usuarios').doc(cred.user!.uid).set({
        'email': email,
        'nome': nome,
        'tipo': tipo,
      });

      print('Usuário cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar: $e');
      rethrow;
    }
  }
}
