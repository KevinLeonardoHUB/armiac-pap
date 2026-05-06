import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Esp32WifiService {
  Esp32WifiService._();
  static final Esp32WifiService instance = Esp32WifiService._();

  static const String baseUrl = "http://192.168.4.1";
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);

  Future<void> connect() async {
    final ok = await ping();
    isConnected.value = ok;
    if (!ok) throw Exception("Conecte no Wi-Fi ARMIAC_ESP32 e tente novamente.");
  }

  Future<bool> ping() async {
    try {
      final r = await http
          .get(Uri.parse("$baseUrl/ping"))
          .timeout(const Duration(seconds: 2));
      return r.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> action(String a) async {
    final r = await http
        .get(Uri.parse("$baseUrl/action?a=$a"))
        .timeout(const Duration(seconds: 3));
    if (r.statusCode != 200) {
      throw Exception("Falha ao enviar ação ($a): HTTP ${r.statusCode}");
    }
  }
}
