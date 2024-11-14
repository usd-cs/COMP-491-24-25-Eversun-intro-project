import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chitchat_app/main.dart';
import 'package:chitchat_app/global_variables.dart';

void main() {
  testWidgets('User login and logout test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Tap on the Account icon to open login dialog
    await tester.tap(find.byIcon(Icons.account_circle));
    await tester.pumpAndSettle();

    // Enter credentials and submit
    await tester.enterText(find.byType(TextField).first, 'user');
    await tester.enterText(find.byType(TextField).last, 'userpass');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Check if login was successful
    expect(isLoggedIn, isTrue);
    expect(find.text('Logout'), findsOneWidget);

    // Perform logout
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    // Check if logout was successful
    expect(isLoggedIn, isFalse);
    expect(find.text('Login'), findsOneWidget);
  });
} 