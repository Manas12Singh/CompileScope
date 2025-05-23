const express = require('express');
const cors = require('cors');
const fs = require('fs');
const { exec } = require('child_process');

const app = express();
app.use(cors());
app.use(express.json());

app.post('/compile', (req, res) => {
  const code = req.body.code;
  fs.writeFileSync('cfiles/temp.c', code);

  exec('cd cfiles && make && ./a.out', (err, stdout, stderr) => {
    if (err) {
      return res.status(400).json({ error: stderr || err.message });
    }
    res.json({ output: stdout });
  });
});

// Serve tokens.json after compilation
app.get('/tokens', (req, res) => {
  const path = 'cfiles/tokens.json';
  if (fs.existsSync(path)) {
    res.sendFile(path, { root: __dirname });
  } else {
    res.status(404).json({ error: 'tokens.json not found' });
  }
});

// Delete tokens.json when code is updated
app.post('/reset-tokens', (req, res) => {
  const path = 'cfiles/tokens.json';
  if (fs.existsSync(path)) {
    fs.unlinkSync(path);
  }
  res.json({ success: true });
});

app.listen(5000, () => console.log('Server running on http://localhost:5000'));
