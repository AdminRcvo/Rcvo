// API Express (exemple)
const express = require('express');
const app = express();
app.get('/health', (req,res) => res.send('OK'));
module.exports = app;
