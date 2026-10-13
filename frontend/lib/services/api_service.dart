import 'dart:convert';
import 'package:http/http.dart' as http;

// Change this to your deployed backend URL or your computer's LAN IP.
// For local Windows testing: http://localhost:3000
const String apiBaseUrl = 'http://localhost:3000';

class ApiService {
  Future<void> logBattery({required int level, required bool isCharging, required String platform}) async {
    try {
      await http.post(
        Uri.parse('$apiBaseUrl/api/battery'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'device': 'Battery Guardian device',
          'platform': platform,
          'level': level,
          'isCharging': isCharging,
        }),
      ).timeout(const Duration(seconds: 4));
    } catch (_) {
      // Battery monitoring remains usable if the optional backend is offline.
    }
  }
}
