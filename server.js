const express = require('express');
const path = require('path');
const Cordic = require('./cordic');

const app = express();
const port = 3000;

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

// Endpoint for CORDIC calculations
app.get('/cordic', (req, res) => {
    const { x, y, iterations } = req.query;
    const cordic = new Cordic();
    const result = cordic.cordic(parseFloat(x), parseFloat(y), parseInt(iterations));
    res.json(result);
});

// Start server
app.listen(port, () => {
    console.log(`CORDIC visualizer running at http://localhost:${port}`);
});
