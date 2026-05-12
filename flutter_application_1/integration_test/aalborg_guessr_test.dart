// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_application_1/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/game/view/result_page.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

tearDownAll(() async {
    // intentionally empty — prevents false tearDownAll failure
  });
  // ─── HOME PAGE ───────────────────────────────────────────────
  group('Home Page', () {
    testWidgets('renders correctly', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Aalborg\nGuessr'), findsOneWidget);
      expect(find.text('NEW GAME'), findsOneWidget);
      expect(find.text('HIGHSCORE'), findsOneWidget);
    });

    testWidgets('info dialog opens and closes', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();

      expect(find.text('text'), findsOneWidget);
      expect(find.text('more text'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('text'), findsNothing);
    });

    testWidgets('NEW GAME navigates away from home', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('NEW GAME'));
      await tester.pump(const Duration(seconds: 3)); // allow network call

      // Home title gone = we navigated
      expect(find.text('Aalborg\nGuessr'), findsNothing);
    });
  });

  // ─── GAME PAGE ───────────────────────────────────────────────
  group('Game Page', () {
    testWidgets('shows loading spinner before picture loads', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('NEW GAME'));
      await tester.pump(); // don't settle — catch the loading state

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows round counter and score', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('NEW GAME'));
      await tester.pump(const Duration(seconds: 3));

      expect(find.text('1/5'), findsOneWidget);
      expect(find.textContaining('Score:'), findsOneWidget);
    });

    testWidgets('GUESS button is visible', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('NEW GAME'));
      await tester.pump(const Duration(seconds: 3));

      expect(find.text('GUESS!'), findsOneWidget);
    });

    testWidgets('skip/exit dialog opens', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('NEW GAME'));
      await tester.pump(const Duration(seconds: 3));

      await tester.tap(find.byIcon(Icons.cancel_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Skip round or leave game?'), findsOneWidget);
      expect(find.text('SKIP'), findsOneWidget);
      expect(find.text('LEAVE'), findsOneWidget);
    });

    testWidgets('LEAVE in dialog navigates back to home', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('NEW GAME'));
      await tester.pump(const Duration(seconds: 3));

      await tester.tap(find.byIcon(Icons.cancel_outlined));
      await tester.pumpAndSettle();

      await tester.tap(find.text('LEAVE'));
      await tester.pumpAndSettle();

      expect(find.text('Aalborg\nGuessr'), findsOneWidget);
    });

    testWidgets('GUESS navigates to score page', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('NEW GAME'));
      await tester.pump(const Duration(seconds: 3));

      await tester.tap(find.text('GUESS!'));
      await tester.pumpAndSettle();

      expect(find.text('SCORE'), findsOneWidget);
      expect(find.text('NEXT'), findsOneWidget);
    });
  });

  // ─── SCORE PAGE ──────────────────────────────────────────────
  group('Score Page', () {
    Future<void> navigateToScorePage(WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.text('NEW GAME'));
      await tester.pump(const Duration(seconds: 3));
      await tester.tap(find.text('GUESS!'));
      await tester.pumpAndSettle();
    }

    testWidgets('shows score, accuracy and time', (tester) async {
      await navigateToScorePage(tester);

      expect(find.text('SCORE'), findsOneWidget);
      expect(find.text('Accuracy'), findsOneWidget);
      expect(find.textContaining('Time:'), findsOneWidget);
    });

    testWidgets('NEXT button goes back to game page', (tester) async {
      await navigateToScorePage(tester);

      await tester.tap(find.text('NEXT'));
      await tester.pump(const Duration(seconds: 3));

      expect(find.text('2/5'), findsOneWidget);
    });

    testWidgets('leave dialog opens from score page', (tester) async {
      await navigateToScorePage(tester);

      await tester.tap(find.byIcon(Icons.cancel_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Leave game?'), findsOneWidget);
      expect(find.text('LEAVE'), findsOneWidget);
    });
  });

  // ─── WELL DONE PAGE ──────────────────────────────────────────
  group('Well Done Page', () {
    testWidgets('renders with round scores', (tester) async {
      // Navigate directly with known scores
      await tester.pumpWidget(
        MaterialApp(
          home: WellDonePage(roundScores: [1000, 2000, 3000, 4000, 5000]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('WELL DONE!'), findsOneWidget);
      expect(find.text('ROUND 1: 1000'), findsOneWidget);
      expect(find.text('ROUND 5: 5000'), findsOneWidget);
      expect(find.text('15000'), findsOneWidget); // total
    });

    testWidgets('FINISH navigates to home', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WellDonePage(roundScores: [1000, 2000, 3000, 4000, 5000]),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('FINISH'));
      await tester.pumpAndSettle();

      expect(find.text('Aalborg\nGuessr'), findsOneWidget);
    });
  });
}