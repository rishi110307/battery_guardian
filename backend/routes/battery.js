const router = require('express').Router();
const controller = require('../controllers/batteryController');
router.post('/', controller.logBattery);
router.get('/latest', controller.getLatest);
router.get('/history', controller.getHistory);
module.exports = router;
