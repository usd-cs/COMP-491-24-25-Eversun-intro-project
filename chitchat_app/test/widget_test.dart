// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chitchat_app/main.dart';
import 'package:chitchat_app/global_variables.dart';
import 'package:chitchat_app/home_page.dart';
import 'package:chitchat_app/post_card.dart';
import 'package:chitchat_app/account_page.dart';

void main() {
  // Helper function to create a widget under test with necessary providers
  Widget createTestableWidget(Widget child) {
    return MaterialApp(
      home: child,
    );
  }

  group('MainPage Tests', () {
    testWidgets('Navigates to HomePage when Home is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const MainPage()));
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('Shows login dialog when not logged in and Account is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const MainPage()));
      await tester.tap(find.byIcon(Icons.account_circle));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextButton, 'Login'), findsOneWidget);
    });

    testWidgets('Creates a post when logged in and add button is pressed', (WidgetTester tester) async {
      // Set logged in status
      isLoggedIn = true;
      currentUsername = 'testUser';

      await tester.pumpWidget(createTestableWidget(const MainPage()));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill in the post creation form
      await tester.enterText(find.byType(TextField).at(0), 'Test Title');
      await tester.enterText(find.byType(TextField).at(1), 'Test Content');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Verify the post is added
      expect(AccountPage.recentPosts.any((post) => post['title'] == 'Test Title' && post['content'] == 'Test Content'), isTrue);
    });
  });

  group('HomePage Tests', () {
    testWidgets('Displays random posts correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const HomePage()));
      await tester.pumpAndSettle();
      expect(find.byType(PostCard), findsWidgets);
    });
  });
}
