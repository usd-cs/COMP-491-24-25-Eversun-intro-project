import 'package:chitchat_app/global_variables.dart';
import 'package:chitchat_app/services/user_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:chitchat_app/home_page.dart';
import 'package:chitchat_app/services/post_service.dart';
import 'mock_services.dart';

void main() {
  setUp(() {
    PostService.getAllPosts = MockQueryService.getMockPosts;
    PostService.getAllComments = MockQueryService.getMockComments;
  });

  group('HomePage Widget Tests with Mocked Server', () {
    testWidgets('Posts are loaded and displayed correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage(posts: [])));
      await tester.pumpAndSettle();

      expect(find.text('Test post content 1'), findsOneWidget);
      expect(find.text('testUser1'), findsOneWidget);
    });

    testWidgets('Admin can delete posts', (WidgetTester tester) async {
      isAdmin = true;
      UserService.isAdmin = true;

      await tester.pumpWidget(const MaterialApp(
        home: ScaffoldMessenger(
          child: Scaffold(
            body: HomePage(posts: []),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Delete Post'), findsWidgets);
      await tester.tap(find.text('Delete Post').first);
      await tester.pumpAndSettle();
    });

    testWidgets('Logged-in user can add comments', (WidgetTester tester) async {
      isLoggedIn = true;
      UserService.isLoggedIn = true;
      currentUsername = 'testUser';

      await tester.pumpWidget(const MaterialApp(
        home: ScaffoldMessenger(
          child: Scaffold(
            body: HomePage(posts: []),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('View Comments').first);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'New test comment');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Test post content 1'), findsOneWidget);
    });
  });

  group('PostService Tests', () {
    test('getAllPosts returns correct Post objects', () async {
      final posts = await PostService.getAllPosts();
      expect(posts, isA<List<Post>>());
      if (posts.isNotEmpty) {
        expect(posts.first.username, isNotEmpty);
        expect(posts.first.content, isNotEmpty);
        expect(posts.first.postId, isNotEmpty);
      }
    });

    test('getAllComments returns correct Comment objects', () async {
      final comments = await PostService.getAllComments(1);
      expect(comments, isA<List<Comment>>());
      if (comments.isNotEmpty) {
        expect(comments.first.username, isNotEmpty);
        expect(comments.first.content, isNotEmpty);
        expect(comments.first.commentId, isNotEmpty);
      }
    });
  });

  group('UserService Tests', () {
    setUp(() {
      // Reset state before each test
      UserService.isLoggedIn = false;
      UserService.currentUsername = '';
      UserService.isAdmin = false;
    });

    test('login sets correct user state', () async {
      final success = await MockQueryService.getMockLogin('test@test.com', 'test123');
      expect(success, isTrue);
      expect(UserService.isLoggedIn, isTrue);
      expect(UserService.currentUsername, equals('testUser'));
      expect(UserService.isAdmin, isFalse);
    });

    test('admin login sets correct state', () async {
      final success = await MockQueryService.getMockLogin('admin@test.com', 'test123');
      expect(success, isTrue);
      expect(UserService.isLoggedIn, isTrue);
      expect(UserService.currentUsername, equals('adminUser'));
      expect(UserService.isAdmin, isTrue);
    });

    test('login fails with invalid credentials', () async {
      final success = await MockQueryService.getMockLogin('invalid@test.com', 'wrong');
      expect(success, isFalse);
      expect(UserService.isLoggedIn, isFalse);
      expect(UserService.currentUsername, isEmpty);
      expect(UserService.isAdmin, isFalse);
    });
  });
}
