import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adocao/main.dart';

void main() {
  testWidgets('SplashScreen shows loading text', (WidgetTester tester) async {
    // Inicializa a aplicação
    await tester.pumpWidget(MyApp());

    // Verifica se o texto "Carregando..." está presente na SplashScreen
    expect(find.text('Carregando...'), findsOneWidget);
  });
}
