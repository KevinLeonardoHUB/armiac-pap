import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Esp32WifiService {
  Esp32WifiService._();
  static final Esp32WifiService instance = Esp32WifiService._();

  static const String baseUrl = 'http://192.168.4.1';
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);

  Future<void> connect() async {
    final ok = await ping();
    isConnected.value = ok;
    if (!ok) throw Exception('ARMIAC_WIFI_NOT_CONNECTED');
  }

  Future<bool> ping() async {
    try {
      final r = await http.get(Uri.parse('$baseUrl/ping')).timeout(const Duration(seconds: 2));
      return r.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> status() async {
    try {
      final r = await http.get(Uri.parse('$baseUrl/status')).timeout(const Duration(seconds: 2));
      if (r.statusCode != 200) return null;
      return jsonDecode(r.body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> action(String a) async {
    final uri = Uri.parse('$baseUrl/action').replace(queryParameters: {'a': a});
    final r = await http.get(uri).timeout(const Duration(seconds: 3));
    if (r.statusCode != 200) {
      throw Exception('ARMIAC_ACTION_FAILED');
    }
  }
}
