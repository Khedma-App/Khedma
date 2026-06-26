import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background message handling
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // 1. Request Permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Initialize Local Notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);
    await _localNotificationsPlugin.initialize(settings: initSettings);

    // 3. Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });

    // 4. Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 5. Save Token initially and on refresh
    await saveFCMToken();
    _messaging.onTokenRefresh.listen((token) {
      _saveTokenToFirestore(token);
    });
  }

  static Future<void> saveFCMToken() async {
    final token = await _messaging.getToken();
    if (token != null) {
      await _saveTokenToFirestore(token);
    }
  }

  static Future<void> _saveTokenToFirestore(String token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final clientDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (clientDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({'fcmToken': token});
      } else {
        await FirebaseFirestore.instance.collection('providers').doc(uid).update({'fcmToken': token});
      }
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'khedma_channel',
      'Khedma Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      id: message.messageId.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: details,
    );
  }

  // -------------------------------------------------------------
  // SEND NOTIFICATIONS VIA FCM HTTP v1
  // -------------------------------------------------------------

  static Future<String> _getAccessToken() async {
    try {
      final serviceAccountJson =
          await rootBundle.loadString('assets/serviceAccountKey.json');
      final accountCredentials = auth.ServiceAccountCredentials.fromJson(serviceAccountJson);

      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      final authClient = await auth.clientViaServiceAccount(accountCredentials, scopes);
      
      return authClient.credentials.accessToken.data;
    } catch (e) {
      print('Error getting access token: Make sure assets/serviceAccountKey.json is configured properly.');
      return '';
    }
  }

  static Future<void> sendPushNotification({
    required String targetUid,
    required String title,
    required String body,
  }) async {
    try {
      if (targetUid.isEmpty) return;

      // Get target token
      String? targetToken;
      final clientDoc = await FirebaseFirestore.instance.collection('users').doc(targetUid).get();
      if (clientDoc.exists) {
        targetToken = clientDoc.data()?['fcmToken'];
      } else {
        final providerDoc = await FirebaseFirestore.instance.collection('providers').doc(targetUid).get();
        if (providerDoc.exists) {
          targetToken = providerDoc.data()?['fcmToken'];
        }
      }

      if (targetToken == null || targetToken.isEmpty) return;

      // Send payload
      final accessToken = await _getAccessToken();
      if (accessToken.isEmpty) return;
      
      final serviceAccountJson = await rootBundle.loadString('assets/serviceAccountKey.json');
      final Map<String, dynamic> accountData = jsonDecode(serviceAccountJson);
      final projectId = accountData['project_id'];

      final endpoint = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

      final payload = {
        'message': {
          'token': targetToken,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          }
        }
      };

      await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
      );
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }
}
