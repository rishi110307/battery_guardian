import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import '../services/battery_service.dart';
import '../services/api_service.dart';
import '../widgets/battery_indicator.dart';
import 'block_screen.dart';

class BatteryHomeScreen extends StatefulWidget {
  const BatteryHomeScreen({super.key});
  @override
  State<BatteryHomeScreen> createState() => _BatteryHomeScreenState();
}

class _BatteryHomeScreenState extends State<BatteryHomeScreen> with WidgetsBindingObserver {
  final _battery = BatteryService();
  final _api = ApiService();
  Timer? _timer;
  int _level = 100;
  BatteryState _state = BatteryState.unknown;
  bool _busy = false;

  bool get _charging => _state == BatteryState.charging || _state == BatteryState.full;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
    _timer = Timer.periodic(const Duration(seconds: 15), (_) => _refresh());
    _battery.onStateChanged.listen((state) {
      if (mounted) setState(() => _state = state);
      _refresh();
    });
  }

  Future<void> _refresh() async {
    if (_busy) return;
    _busy = true;
    try {
      final level = await _battery.level();
      final state = await _battery.state();
      if (!mounted) return;
      setState(() { _level = level; _state = state; });
      await _api.logBattery(level: level, isCharging: _charging, platform: _platformName());
    } catch (_) {
      // Some desktop environments may not expose battery information.
    } finally {
      _busy = false;
    }
  }

  String _platformName() {
    // Avoid dart:io platform checks to keep the sample simple.
    return Theme.of(context).platform.name;
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_level < 15) {
      return BlockScreen(level: _level, charging: _charging, onRefresh: _refresh);
    }
    final full = _level >= 100;
    return Scaffold(
      appBar: AppBar(title: const Text('Battery Guardian'), centerTitle: true),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BatteryIndicator(level: _level),
                const SizedBox(height: 28),
                Text(full ? 'Battery is 100% charged!' : 'Battery level: $_level%',
                  style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text(_charging ? 'Charger connected' : 'Not charging',
                  style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 20),
                Text(full ? 'You can unplug your charger.' :
                  (_level < 30 ? 'Consider connecting your charger soon.' : 'Battery status is being monitored.'),
                  textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton.icon(onPressed: _refresh, icon: const Icon(Icons.refresh), label: const Text('Refresh status')),
                const SizedBox(height: 12),
                const Text('Keep this app open for in-app low-battery reminders.',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
