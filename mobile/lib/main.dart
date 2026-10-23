import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(const BatteryGuardianApp());

class BatteryGuardianApp extends StatelessWidget {
  const BatteryGuardianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battery Guardian',
      home: const BatteryMonitorPage(),
    );
  }
}

class BatteryMonitorPage extends StatefulWidget {
  const BatteryMonitorPage({super.key});

  @override
  State<BatteryMonitorPage> createState() => _BatteryMonitorPageState();
}

class _BatteryMonitorPageState extends State<BatteryMonitorPage> {
  final Battery _battery = Battery();
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  int _level = 0;
  bool _isCharging = false;
  bool _fullAlertSent = false;
  bool _lowWarningShown = false;

  @override
  void initState() {
    super.initState();
    _initNotifications();
    _listenBattery();
  }

  Future<void> _initNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _notifications.initialize(const InitializationSettings(
      android: androidInit,
    ));
  }

  void _listenBattery() {
    _battery.onBatteryStateChanged.listen((state) async {
      final level = await _battery.batteryLevel;
      final charging = state == BatteryState.charging;

      setState(() {
        _level = level;
        _isCharging = charging;
      });

      // 100% alert
      if (level >= 100 && !_fullAlertSent) {
        _fullAlertSent = true;
        _showNotification('Battery Full', 'Your battery is at 100%. Unplug to protect battery health.');
      }
      if (level < 100) _fullAlertSent = false;

      // 15% low-battery full-screen warning
      if (level <= 15 && !charging && !_lowWarningShown) {
        _lowWarningShown = true;
        _showLowBatteryDialog();
      }
      if (level > 15) _lowWarningShown = false;
    });
  }

  Future<void> _showNotification(String title, String body) async {
    await _notifications.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'battery_channel',
          'Battery Alerts',
          importance: Importance.high,
        ),
      ),
    );
  }

  void _showLowBatteryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Low Battery'),
        content: const Text(
          'Battery is below 15%. Please connect your charger to continue working.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('I Understand'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battery Guardian')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$_level%', style: const TextStyle(fontSize: 64)),
            Text(_isCharging ? 'Charging' : 'Not Charging'),
            if (_level <= 15 && !_isCharging)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  '⚠️ Low battery! Connect charger.',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
