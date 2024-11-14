import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chitchat_app/main.dart';
import 'package:chitchat_app/home_page.dart';
import 'package:chitchat_app/account_page.dart';

void main() {
  testWidgets('Navigation bar interaction test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Tap on the Home icon
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);

    // Tap on the Account icon
    await tester.tap(find.byIcon(Icons.account_circle));
    await tester.pumpAndSettle();
    expect(find.byType(AccountPage), findsOneWidget);
  });
} 