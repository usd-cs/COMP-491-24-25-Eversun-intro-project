import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chitchat_app/main.dart';
import 'package:chitchat_app/global_variables.dart';
import 'package:chitchat_app/account_page.dart';

void main() {
  testWidgets('Post submission test', (WidgetTester tester) async {
    updateLoggedIn(true);
    updateCurrentUser('testUser');

    await tester.pumpWidget(const MyApp());

    // Navigate to HomePage
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();

    // Open create post dialog
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Enter post content and submit
    await tester.enterText(find.byType(TextField), 'New post content');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    // Verify the post is added
    expect(AccountPage.recentPosts.any((post) => post['content'] == 'New post content'), isTrue);
  });
} 