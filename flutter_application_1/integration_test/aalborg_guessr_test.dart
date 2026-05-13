import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_application_1/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  testWidgets('full game flow — 5 rounds then return to home', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // Start game from home
  await tester.tap(find.text('NEW GAME'));
  await tester.pump(const Duration(seconds: 3));

  for (int round = 1; round <= 5; round++) {
    // Verify round counter
    expect(find.text('$round/5'), findsOneWidget);

    // Make a guess
    await tester.tap(find.text('GUESS!'));
    await tester.pumpAndSettle();

    // Verify score page
    expect(find.text('SCORE'), findsOneWidget);
    expect(find.text('Accuracy'), findsOneWidget);
    expect(find.textContaining('Time:'), findsOneWidget);

    if (round < 5) {
      // Go to next round
      await tester.tap(find.text('NEXT'));
      await tester.pump(const Duration(seconds: 3));
    } else {
      // Last round — expect well done page
      await tester.tap(find.text('NEXT'));
      await tester.pumpAndSettle();
      expect(find.text('WELL DONE!'), findsOneWidget);
    }
  }

  // Return to home
  await tester.tap(find.text('FINISH'));
  await tester.pumpAndSettle();
  expect(find.text('Aalborg\nGuessr'), findsOneWidget);
});
}


