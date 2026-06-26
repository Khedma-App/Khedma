import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

void main() async {
  try {
    final serviceAccountJson = await File(
      'assets/serviceAccountKey.json',
    ).readAsString();
    final accountCredentials = auth.ServiceAccountCredentials.fromJson(
      serviceAccountJson,
    );

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final authClient = await auth.clientViaServiceAccount(
      accountCredentials,
      scopes,
    );
    final accessToken = authClient.credentials.accessToken.data;

    final Map<String, dynamic> accountData = jsonDecode(serviceAccountJson);
    final projectId = accountData['project_id'];

    print('Access token retrieved successfully.');

    final endpoint =
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

    final payload = {
      'message': {
        'token': 'dummy_token_to_test_auth',
        'notification': {'title': 'Test', 'body': 'Test Body'},
      },
    };

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(payload),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
  } catch (e) {
    print('Error: $e');
  }
}
