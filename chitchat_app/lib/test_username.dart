import 'query_attempts.dart';

void main() async {
  try {
    String username = await retrieveUsername(1); // Retrieves username for user ID 1
    print('Username: $username');
  } catch (e) {
    print('Error retrieving username: $e');
  }
}
