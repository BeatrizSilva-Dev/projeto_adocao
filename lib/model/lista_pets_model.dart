import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/pet_model.dart';

final List<Pet> pets = [
  Pet(nome: 'Théo', info: 'Macho, 7 meses', imagem: 'https://upload.wikimedia.org/wikipedia/commons/7/70/Serena_REFON.jpg', tipo: 'cachorro', porte: 'médio', raca: 'caramelo', descricao:"carinhoso" ),
  Pet(nome: 'Alice', info: 'Fêmea, 6 meses', imagem: 'https://static.wixstatic.com/media/e2e4ef_0b360155ffdd45858ac4204bdf67d053~mv2.jpeg/v1/fill/w_1200,h_1600,al_c,q_85/Zeus-cachorro_10.jpeg', tipo: 'cachorro',porte: 'médio', raca: 'caramelo',descricao:"amorosa"),
  Pet(nome: 'Tor', info: 'Macho, 7 meses', imagem: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbd9dRZPOjkzlnNO_JtRYcjW1ia-iIuibGO0eXlKrc7RUJ6JxpDtvvhRnSKX-TuzagGvo&usqp=CAU', tipo: 'cachorro',porte: 'médio', raca: 'rottweiler',descricao:"carinhoso"),
  Pet(nome: 'Lilica', info: 'Fêmea, 2 meses', imagem: 'https://optimumpet.com.br/media/uploads/2023/03/por-que-o-filhote-de-cachorro-chora-01.webp', tipo: 'cachorro',porte: 'médio', raca: 'golden',descricao:"carinhosa"),
  Pet(nome: 'Edgar', info: 'Macho, 2 meses', imagem: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxchJ0ZYBrrHwUWZuK0Cw-zPWoj43-0-sHww&s', tipo: 'gato',porte: 'pequeno', raca: 'branco',descricao:"carinhoso"),
  Pet(nome: 'Luna', info: 'Fêmea, 6 meses', imagem: 'https://www.patasdacasa.com.br/sites/default/files/styles/article_detail_1200/public/2024-09/gato-preto.jpg.webp?itok=VI-YbRBa', tipo: 'gato',porte: 'pequeno', raca: 'preto',descricao:"Ela é carinhosa e muito amorosa"),
  Pet(nome: 'Ateez', info: 'Macho, 7 meses', imagem: 'https://images.pexels.com/photos/172023/pexels-photo-172023.jpeg', tipo: 'gato',porte: 'pequeno', raca: 'branco',descricao:"carinhoso"),
  Pet(nome: 'Julia', info: 'Fêmea, 6 meses', imagem: 'https://images.unsplash.com/photo-1626647666201-2792a28ffb95?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE1fHx8ZW58MHx8fHx8', tipo: 'gato',porte: 'pequeno', raca: 'tricolor',descricao:"carinhosa"),
  Pet(nome: 'Draco', info: 'Macho, 7 meses', imagem: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSswwvA9WWb2e3ZfFOEMZHik4jQ9MgJGCEDbg&s', tipo: 'gato',porte: 'pequeno', raca: 'rajado',descricao:"carinhoso"),
  Pet(nome: 'Doce de Leite', info: 'Fêmea, 6 meses', imagem: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSYzs3nKGVQz9Ah4huAqRWfItaoMIhAIexew&s', tipo: 'gato',porte: 'pequeno', raca: 'laranja',descricao:"carinhosa"),
];

Future<void> adicionarPetsAoFirestore() async {
  for (var pet in pets) {
    await FirebaseFirestore.instance.collection('pets').add(pet.toMap());
  }
}
