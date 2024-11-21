import '../query_attempts.dart';

/// Service class for managing user authentication and user-related operations
/// Provides static methods and properties for user management throughout the app
class UserService {
  /// The username of the currently logged in user
  /// Null if no user is logged in
  static String? currentUsername;

  /// The unique identifier of the currently logged in user
  /// Null if no user is logged in
  static int? currentUserId;

  /// Flag indicating whether a user is currently logged in
  static bool isLoggedIn = false;

  /// Flag indicating whether the current user has admin privileges
  static bool isAdmin = false;

  /// Attempts to log in a user with the provided credentials
  /// @param email - The user's email address
  /// @param password - The user's password
  /// @returns Future<bool> - True if login successful, false otherwise
  static Future<bool> login(String email, String password) async {
    List<bool> result = await loginAttempt(email, password);
    isLoggedIn = result[0];  
    isAdmin = result[1];    
    return isLoggedIn;
  }

  /// Retrieves a username for a given user ID
  /// @param userId - The ID of the user to look up
  /// @returns Future<String> - The username associated with the ID
  static Future<String> getUsername(int userId) async {
    return await retrieveUsername(userId);
  }
} 