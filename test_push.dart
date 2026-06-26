import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

void main() async {
  try {
    final serviceAccountJson = await File('assets/serviceAccountKey.json').readAsString();
    final accountCredentials = auth.ServiceAccountCredentials.fromJson(serviceAccountJson);

    final scopes = ['https://www.googleapis.com/auth/datastore', 'https://www.googleapis.com/auth/firebase.messaging'];
    final authClient = await auth.clientViaServiceAccount(accountCredentials, scopes);
    final accessToken = authClient.credentials.accessToken.data;

    final Map<String, dynamic> accountData = jsonDecode(serviceAccountJson);
    final projectId = accountData['project_id'];

    // 1. Fetch youssefmahran's token
    final url = 'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users';
    final response = await http.get(Uri.parse(url), headers: {'Authorization': 'Bearer $accessToken'});

    String? targetToken;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final docs = data['documents'] as List<dynamic>? ?? [];
      for (var doc in docs) {
        final fields = doc['fields'] as Map<String, dynamic>? ?? {};
        final email = fields['email']?['stringValue'] ?? '';
        if (email == 'youssefmahran889@gmail.com') {
          targetToken = fields['fcmToken']?['stringValue'];
          break;
        }
      }
    }

    if (targetToken == null) {
      print('Could not find token for youssefmahran');
      return;
    }

    print('Found token for youssefmahran. Sending push notification...');

    // 2. Send push notification
    final endpoint = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
    final payload = {
      'message': {
        'token': targetToken,
        'notification': {
          'title': 'Test Push',
          'body': 'This is a test notification from Antigravity!',
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        }
      }
    };

    final sendResp = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(payload),
    );

    print('FCM Response Status: ${sendResp.statusCode}');
    print('FCM Response Body: ${sendResp.body}');
  } catch (e) {
    print('Error: $e');
  }
}
