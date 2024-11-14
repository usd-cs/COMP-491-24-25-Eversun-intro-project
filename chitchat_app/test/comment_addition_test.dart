import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chitchat_app/main.dart';
import 'package:chitchat_app/global_variables.dart';
import 'package:chitchat_app/post_card.dart';

void main() {
  testWidgets('Comment addition test', (WidgetTester tester) async {
    updateLoggedIn(true);
    updateCurrentUser('testUser');

    await tester.pumpWidget(const MyApp());

    // Assume there is already a post available
    await tester.tap(find.byType(PostCard).last);
    await tester.pumpAndSettle();

    // Tap to add a comment
    await tester.tap(find.text('Add Comment'));
    await tester.pumpAndSettle();

    // Enter comment and submit
    await tester.enterText(find.byType(TextField), 'Great post!');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    // Verify the comment is added
    expect(find.text('Great post!'), findsOneWidget);
  });
} 