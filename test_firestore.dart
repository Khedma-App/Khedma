import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

void main() async {
  try {
    final serviceAccountJson = await File('assets/serviceAccountKey.json').readAsString();
    final accountCredentials = auth.ServiceAccountCredentials.fromJson(serviceAccountJson);

    final scopes = ['https://www.googleapis.com/auth/datastore'];
    final authClient = await auth.clientViaServiceAccount(accountCredentials, scopes);
    final accessToken = authClient.credentials.accessToken.data;

    final Map<String, dynamic> accountData = jsonDecode(serviceAccountJson);
    final projectId = accountData['project_id'];

    final url = 'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users';
    
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final docs = data['documents'] as List<dynamic>?;
      if (docs == null || docs.isEmpty) {
        print('No users found.');
        return;
      }
      for (var doc in docs) {
        final fields = doc['fields'] as Map<String, dynamic>? ?? {};
        final email = fields['email']?['stringValue'] ?? 'Unknown';
        final role = fields['role']?['stringValue'] ?? 'Unknown';
        final fcm = fields['fcmToken']?['stringValue'];
        print('User: $email | Role: $role | FCM Token: ${fcm != null ? 'EXISTS' : 'MISSING'}');
      }
    } else {
      print('Failed to fetch users: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Error: $e');
  }
}
