require('dotenv').config();
const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const connectDB = require('./config/db');
const batteryRoutes = require('./routes/battery');

const app = express();
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));
app.get('/health', (_req, res) => res.json({ success: true, service: 'Battery Guardian API' }));
app.use('/api/battery', batteryRoutes);

const PORT = process.env.PORT || 3000;
if (process.env.MONGO_URI) connectDB();
app.listen(PORT, () => console.log(`Battery Guardian API listening on ${PORT}`));
