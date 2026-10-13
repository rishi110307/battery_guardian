import 'package:flutter/material.dart';

class BlockScreen extends StatelessWidget {
  final int level;
  final bool charging;
  final Future<void> Function() onRefresh;
  const BlockScreen({super.key, required this.level, required this.charging, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15191E),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.battery_alert_rounded, size: 96, color: Colors.orangeAccent),
                const SizedBox(height: 24),
                const Text('BATTERY LOW', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('Battery is at $level%', style: const TextStyle(color: Colors.white70, fontSize: 20)),
                const SizedBox(height: 24),
                const Text('To continue, please connect your charger.',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22)),
                const SizedBox(height: 16),
                Text(charging ? 'Charger connected — keep charging.' : 'Please connect your charger.',
                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.orangeAccent, fontSize: 16)),
                const SizedBox(height: 28),
                FilledButton.icon(onPressed: onRefresh, icon: const Icon(Icons.refresh), label: const Text('Check battery again')),
                const SizedBox(height: 20),
                const Text('This warning covers the app window only; it does not lock the entire device.',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
