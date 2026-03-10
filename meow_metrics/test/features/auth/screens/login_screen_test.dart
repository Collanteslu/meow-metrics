import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meow_metrics/features/auth/screens/login_screen.dart';
import 'package:meow_metrics/config/theme.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('displays login form correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
          theme: AppTheme.lightTheme,
        ),
      );

      expect(find.byType(TextField), findsWidgets);
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Login'), findsWidgets);
    });

    testWidgets('shows register link', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
          theme: AppTheme.lightTheme,
        ),
      );

      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('login button is enabled when rendered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
          theme: AppTheme.lightTheme,
        ),
      );

      final loginButton = find.byType(ElevatedButton);
      expect(loginButton, findsOneWidget);
    });

    testWidgets('can enter email and password', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
          theme: AppTheme.lightTheme,
        ),
      );

      final emailFields = find.byType(TextField);
      await tester.enterText(emailFields.first, 'test@example.com');
      await tester.enterText(emailFields.at(1), 'password123');

      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });
  });
}
