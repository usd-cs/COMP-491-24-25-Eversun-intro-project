import '../query_attempts.dart';

class UserService {
  static String? currentUsername;
  static int? currentUserId;
  static bool isLoggedIn = false;
  static bool isAdmin = false;

  static Future<bool> login(String email, String password) async {
    List<bool> result = await loginAttempt(email, password);
    isLoggedIn = result[0];
    isAdmin = result[1];
    return isLoggedIn;
  }

  static Future<String> getUsername(int userId) async {
    return await retrieveUsername(userId);
  }
} 