import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_application_1/features/home/view/home_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full game flow — 5 rounds then return to home', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Start game from home
    await tester.tap(find.text('NEW GAME'));
    await tester.pumpAndSettle(const Duration(seconds: 15)); // venter på billede fra PocketBase

    for (int round = 1; round <= 5; round++) {
      // Verify round counter
      expect(find.text('$round/5'), findsOneWidget);

      // Make a guess
      await tester.tap(find.text('GUESS!'));
      await tester.pumpAndSettle(const Duration(seconds: 15)); // venter på GPS + navigation

      // Verify score page
      expect(find.text('SCORE'), findsOneWidget);
      expect(find.text('Accuracy'), findsOneWidget);
      expect(find.textContaining('Time:'), findsOneWidget);

      // Go to next round / well done
      await tester.tap(find.text('NEXT'));
      await tester.pumpAndSettle(const Duration(seconds: 15)); // venter på næste billede

      if (round == 5) {
        expect(find.text('WELL DONE!'), findsOneWidget);
      }
    }

    // Return to home
    await tester.tap(find.text('FINISH'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text('Aalborg\nGuessr'), findsOneWidget);
  });
}