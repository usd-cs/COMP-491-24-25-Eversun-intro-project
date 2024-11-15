import 'dart:math';


  String randomDate() {
  final Random random = Random();
  final DateTime now = DateTime.now();
  final DateTime randomDate = now.subtract(Duration(days: random.nextInt(30)));

  // Format the date as a string (e.g., 'MM/dd/yyyy')
  return "${randomDate.month.toString().padLeft(2, '0')}/${randomDate.day.toString().padLeft(2, '0')}/${randomDate.year}";
}

bool isAdmin = false;
bool isLoggedIn = false;
String currentUsername = " ";

void updateAdmin(bool setAdmin) {
  isAdmin = setAdmin;
}
void updateLoggedIn(bool setLoggin) {
  isLoggedIn = setLoggin;
}
void updateCurrentUser(String newUsername) {
  currentUsername = newUsername;
}