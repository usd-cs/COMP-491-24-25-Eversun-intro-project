import 'dart:math';

/// Generates a random date within the last 30 days
/// Returns a formatted date string in 'MM/dd/yyyy' format
String randomDate() {
  final Random random = Random();
  final DateTime now = DateTime.now();
  final DateTime randomDate = now.subtract(Duration(days: random.nextInt(30)));

  // Format the date as a string (e.g., 'MM/dd/yyyy')
  return "${randomDate.month.toString().padLeft(2, '0')}/${randomDate.day.toString().padLeft(2, '0')}/${randomDate.year}";
}

/// Global flag indicating if the current user has admin privileges
bool isAdmin = false;

/// Global flag indicating if a user is currently logged in
bool isLoggedIn = false;

/// Stores the username of the currently logged in user
String currentUsername = " ";

/// Updates the admin status of the current user
/// @param setAdmin - The new admin status to set
void updateAdmin(bool setAdmin) {
  isAdmin = setAdmin;
}

/// Updates the login status of the current user
/// @param setLoggin - The new login status to set
void updateLoggedIn(bool setLoggin) {
  isLoggedIn = setLoggin;
}

/// Updates the username of the current user
/// @param newUsername - The new username to set
void updateCurrentUser(String newUsername) {
  currentUsername = newUsername;
}