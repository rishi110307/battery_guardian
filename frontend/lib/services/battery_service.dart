import 'package:battery_plus/battery_plus.dart';

class BatteryService {
  final Battery _battery = Battery();

  Future<int> level() => _battery.batteryLevel;
  Future<BatteryState> state() => _battery.batteryState;
  Stream<BatteryState> get onStateChanged => _battery.onBatteryStateChanged;
}
