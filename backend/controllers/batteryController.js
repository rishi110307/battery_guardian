const BatteryLog = require('../models/BatteryLog');

exports.logBattery = async (req, res) => {
  try {
    const { device, platform, level, isCharging } = req.body;
    if (!Number.isFinite(Number(level)) || Number(level) < 0 || Number(level) > 100) {
      return res.status(400).json({ success: false, message: 'level must be between 0 and 100' });
    }
    const log = await BatteryLog.create({ device, platform, level: Number(level), isCharging: Boolean(isCharging) });
    res.status(201).json({ success: true, log });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

exports.getLatest = async (_req, res) => {
  try {
    const log = await BatteryLog.findOne().sort({ createdAt: -1 });
    res.json({ success: true, log });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};

exports.getHistory = async (req, res) => {
  try {
    const limit = Math.min(Number(req.query.limit) || 100, 500);
    const logs = await BatteryLog.find().sort({ createdAt: -1 }).limit(limit);
    res.json({ success: true, logs });
  } catch (err) { res.status(500).json({ success: false, message: err.message }); }
};
