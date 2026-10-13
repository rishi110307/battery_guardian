import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'screens/home_screen.dart';

void main() => runApp(const BatteryGuardianApp());

class BatteryGuardianApp extends StatelessWidget {
  const BatteryGuardianApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battery Guardian',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), useMaterial3: true),
      home: const BatteryHomeScreen(),
    );
  }
}
