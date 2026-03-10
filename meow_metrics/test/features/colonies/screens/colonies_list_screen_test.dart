import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meow_metrics/features/colonies/screens/colonies_list_screen.dart';
import 'package:meow_metrics/config/theme.dart';

void main() {
  group('ColoniesListScreen', () {
    testWidgets('displays app bar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ColoniesListScreen(),
          theme: AppTheme.lightTheme,
        ),
      );

      expect(find.text('Colonies'), findsWidgets);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays search field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ColoniesListScreen(),
          theme: AppTheme.lightTheme,
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('displays empty state when no colonies', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ColoniesListScreen(),
          theme: AppTheme.lightTheme,
        ),
      );

      expect(find.text('No colonies yet'), findsOneWidget);
      expect(find.byIcon(Icons.location_city), findsOneWidget);
    });

    testWidgets('displays floating action button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ColoniesListScreen(),
          theme: AppTheme.lightTheme,
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('can search for colonies', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ColoniesListScreen(),
          theme: AppTheme.lightTheme,
        ),
      );

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'test colony');

      expect(find.text('test colony'), findsOneWidget);
    });
  });
}
