import 'package:flutter/material.dart';

class BatteryIndicator extends StatelessWidget {
  final int level;
  const BatteryIndicator({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final color = level < 15 ? Colors.red : level < 35 ? Colors.orange : Colors.teal;
    return SizedBox(
      width: 190, height: 190,
      child: Stack(alignment: Alignment.center, children: [
        SizedBox.expand(child: CircularProgressIndicator(
          value: level.clamp(0, 100) / 100,
          strokeWidth: 14,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        )),
        Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.battery_charging_full, color: color, size: 38),
          Text('$level%', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
        ]),
      ]),
    );
  }
}
