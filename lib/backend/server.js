const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 3000;

// Kích hoạt CORS để cho phép gọi từ Flutter web/mobile
app.use(cors({
  origin: '*', // hoặc bạn chỉ định cụ thể origin client
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// Cho phép xử lý dữ liệu JSON từ client
app.use(bodyParser.json());

// Kết nối với MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',        // thay đổi nếu bạn có user khác
  password: '',        // nếu có mật khẩu thì điền vào đây
  database: 'appxekhach',
});

// Mở kết nối database
db.connect((err) => {
  if (err) {
    console.error('Lỗi kết nối MySQL:', err);
  } else {
    console.log('✅ Kết nối MySQL thành công');
  }
});

// API thêm bến xe
app.post('/add-bx', (req, res) => {
  const { MaBX, TenBX, DiaChi, TinhThanh } = req.body;

  if (!MaBX || !TenBX || !DiaChi || !TinhThanh) {
    return res.status(400).json({ success: false, message: 'Thiếu dữ liệu đầu vào' });
  }

  const sql = 'INSERT INTO BENXE (MaBX, TenBX, DiaChi, TinhThanh) VALUES (?, ?, ?, ?)';
  db.query(sql, [MaBX, TenBX, DiaChi, TinhThanh], (err, result) => {
    if (err) {
      console.error('Lỗi khi thêm dữ liệu:', err);
      return res.status(500).json({ success: false, message: 'Không thể thêm bến xe' });
    }

    res.json({ success: true, message: 'Thêm bến xe thành công' });
  });
});

// Đọc bến xe
app.get('/benxe', (req, res) => {
  const sql = 'SELECT * FROM BENXE';
  db.query(sql, (err, results) => {
    if (err) {
      console.error('Lỗi khi lấy dữ liệu:', err);
      return res.status(500).json({ success: false, message: 'Không thể lấy dữ liệu' });
    }

    res.json(results); // Trả về mảng các bến xe
  });
});

// API cập nhật bến xe theo mã bến xe (PUT)
app.put('/benxe/:maBX', (req, res) => {
  const maBX = req.params.maBX;
  const { TenBX, DiaChi, TinhThanh } = req.body;

  if (!TenBX || !DiaChi || !TinhThanh) {
    return res.status(400).json({ error: 'Thiếu dữ liệu' });
  }

  const sql = `UPDATE BENXE SET TenBX = ?, DiaChi = ?, TinhThanh = ? WHERE MaBX = ?`;
  const params = [TenBX, DiaChi, TinhThanh, maBX];

  db.query(sql, params, (error, results) => {
    if (error) {
      console.error(error);
      return res.status(500).json({ error: 'Lỗi server' });
    }
    if (results.affectedRows === 0) {
      return res.status(404).json({ error: 'Không tìm thấy bến xe' });
    }
    res.json({ message: 'Cập nhật thành công' });
  });
});
//Xóa bến xe
app.delete('/benxe/:maBX', (req, res) => {
  const maBX = req.params.maBX;

  const sql = 'DELETE FROM BENXE WHERE MaBX = ?';
  db.query(sql, [maBX], (err, result) => {
    if (err) {
      console.error('Lỗi xóa bến xe:', err);
      return res.status(500).json({ error: 'Lỗi server khi xóa' });
    }
    if (result.affectedRows === 0) {
      // Không tìm thấy mã bến xe trong DB
      return res.status(404).json({ error: 'Không tìm thấy bến xe để xóa' });
    }
    res.json({ message: 'Xóa thành công' });
  });
})

// Khởi động server
app.listen(port, '0.0.0.0', () => {
  console.log(`🚀 Server đang chạy tại http://0.0.0.0:${port}`);
});