import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ATENÇÃO: Certifique-se de que 'nome_que_copiou_aqui' é o nome correto do seu projeto.
// Se o nome do projeto no seu ficheiro pubspec.yaml for outro, altere aqui.
import 'package:lampada_inteligente/main.dart';void main() {
  testWidgets('Teste de interação e estado da Lanterna Inteligente', (WidgetTester tester) async {
    // 1. INICIALIZAÇÃO
    // Constrói a nossa aplicação e aciona o primeiro frame
   await tester.pumpWidget(const MainApp());

    // Verifica se o título da App está no ecrã
    expect(find.text('🔦 Lanterna'), findsOneWidget);

    // 2. VERIFICA O ESTADO INICIAL
    // A lanterna deve começar desligada
    expect(find.text('DESLIGADA'), findsOneWidget);
    expect(find.text('LIGADA'), findsNothing);

    // O Modo Automático deve começar desativado (Switch com valor false)
    final switchFinder = find.byType(Switch);
    expect(tester.widget<Switch>(switchFinder).value, isFalse);

    // 3. TESTA LIGAR A LANTERNA
    // Procura o botão principal de ligar/desligar através do ícone e simula um toque
    await tester.tap(find.byIcon(Icons.power_settings_new));
    await tester.pumpAndSettle(); // Aguarda as animações de cor/tamanho terminarem

    // Verifica se o estado mudou corretamente na interface
    expect(find.text('LIGADA'), findsOneWidget);
    expect(find.text('DESLIGADA'), findsNothing);

    // 4. TESTA O MODO AUTOMÁTICO
    // Toca no interruptor (Switch) para ativar o modo automático
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    // Verifica se o interruptor agora está ativado (true)
    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    // 5. TESTA DESLIGAR A LANTERNA
    // Toca novamente no botão principal
    await tester.tap(find.byIcon(Icons.power_settings_new));
    await tester.pumpAndSettle();

    // Confirma que a etiqueta voltou a indicar que está desligada
    expect(find.text('DESLIGADA'), findsOneWidget);
  });
}