const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Trang chính của server Node.js');
});

app.get('/api/hello', (req, res) => {
  res.json({ message: 'Xin chào từ Node.js!' });
});

app.listen(port, () => {
  console.log(`Server đang chạy tại http://localhost:${port}`);
})