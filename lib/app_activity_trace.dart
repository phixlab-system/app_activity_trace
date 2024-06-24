library user_activity_tracer;

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppActivityTrace extends NavigatorObserver {
  final String apiKey;
  final String userId;

  AppActivityTrace({required this.apiKey, required this.userId});

  void _sendActivity(String activity, String path, String status, [String? errorMessage]) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8080/api/activities'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tenantApiKey': apiKey,
        'userId': userId,
        'activity': activity,
        'path': path,
        'status': status,
        'errorMessage': errorMessage ?? '',
      }),
    );
    if (response.statusCode != 200) {
      print('Failed to send activity');
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _sendActivity('push', route.settings.name ?? '', 'happy');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _sendActivity('pop', route.settings.name ?? '', 'happy');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _sendActivity('remove', route.settings.name ?? '', 'happy');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _sendActivity('replace', newRoute?.settings.name ?? '', 'happy');
  }

  void recordError(String errorMessage) {
    _sendActivity('error', '', 'unhappy', errorMessage);
  }
}