const mongoose = require('mongoose');
const batteryLogSchema = new mongoose.Schema({
  device: { type: String, default: 'unknown' },
  platform: { type: String, default: 'unknown' },
  level: { type: Number, required: true, min: 0, max: 100 },
  isCharging: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now }
});
module.exports = mongoose.model('BatteryLog', batteryLogSchema);
