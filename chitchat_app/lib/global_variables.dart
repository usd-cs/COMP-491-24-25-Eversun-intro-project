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