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

//Gửi gmail đến server thật
const nodemailer = require('nodemailer');

app.post('/send-ticket', async (req, res) => {
  const {
    fullName,
    email,
    phone,
    route,
    date,
    time,
    seats,
    totalPrice
  } = req.body;

  try {
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: 'baon68579@gmail.com', // Gmail thật
        pass: 'yvejlyxdsxibtpon',    // Mật khẩu ứng dụng
      },
    });

    const mailOptions = {
      from: 'Nhà xe Nam Hải <baon68579@gmail.com>',
      to: email,
      subject: 'Vé xe điện tử - Nhà Xe Nam Hải',
      html: `
        <h3 style="color: #000000;">
          Kính chào Quý khách, cảm ơn Quý khách đã tin tưởng và sử dụng dịch vụ của Nhà xe Nam Hải. Dưới đây là thông tin vé xe Quý khách vừa đặt.
        </h3>
        <h2 style="color: #000000;">Thông tin vé xe</h2>
        <p><strong style="color: #000000;">Họ tên:</strong> ${fullName}</p>
        <p><strong style="color: #000000;">Số điện thoại:</strong> ${phone}</p>
        <p><strong style="color: #000000;">Tuyến:</strong> ${route}</p>
        <p><strong style="color: #000000;">Thời gian:</strong> ${time} ${date}</p>
        <p><strong style="color: #000000;">Số ghế:</strong> ${seats}</p>
        <p><strong style="color: #000000;">Tổng tiền:</strong> ${totalPrice.toLocaleString()} VND</p>
        <p><i style="color: #000000;">Vui lòng trình email này tại quầy vé hoặc soát vé khi lên xe.</i></p>
        <p><i style="color: #000000;">Trân trọng cảm ơn Quý khách đã tin tưởng và sử dụng dịch vụ của chúng tôi.</i></p>
        <h6 style="color: #000000;">---------------------------------------------------------</h6>
        <h2 style="color: #006400;">CÔNG TY CỔ PHẦN XE KHÁCH NAM HẢI</h2>
        <h6 style="color: #000000;">Địa chỉ: 458 Trường Chinh, phường Tân Bình, Thành phố Hồ Chí Minh</h6>
        <h6 style="color: #000000;">Email: xekhachnamhai@gmail.com</h6>
        <h6 style="color: #000000;">Điện thoại: 02843512123</h6>
        <h6 style="color: #000000;">Fax: 02843512124</h6>
      `,
    };

    await transporter.sendMail(mailOptions);
    res.status(200).json({ message: 'Gửi email thành công' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Gửi email thất bại', error });
  }
});

// GET chuyến xe
app.get('/chuyenxe', (req, res) => {
  const sql = `SELECT * FROM CHUYENXE`;

  db.query(sql, (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn CHUYENXE:', err);
      return res.status(500).json({ error: 'Lỗi server' });
    }
    res.json(result);
  });
});

// Thêm chuyến xe
app.post('/add-chuyenxe', (req, res) => {
  const {
    MaCX,
    BienSoXe,
    ThoiGianDi,
    ThoiGianVe,
    DiemDi,
    DiemDen,
    LoaiHinhChuyenDi,
    GiaVe,
    SoChoNgoi
  } = req.body;

  if (!MaCX || !BienSoXe || !ThoiGianDi || !ThoiGianVe || !DiemDi || !DiemDen || !LoaiHinhChuyenDi || !GiaVe || !SoChoNgoi) {
    return res.status(400).json({ error: 'Thiếu dữ liệu bắt buộc' });
  }

  const sql = `
    INSERT INTO CHUYENXE 
    (MaCX, BienSoXe, ThoiGianDi, ThoiGianVe, DiemDi, DiemDen, LoaiHinhChuyenDi, GiaVe, SoChoNgoi)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  db.query(sql, [MaCX, BienSoXe, ThoiGianDi, ThoiGianVe, DiemDi, DiemDen, LoaiHinhChuyenDi, GiaVe, SoChoNgoi], (err, result) => {
    if (err) {
      console.error('Lỗi thêm chuyến xe:', err);
      return res.status(500).json({ error: 'Lỗi máy chủ' });
    }
    res.json({ message: 'Thêm chuyến xe thành công' });
  });
});

// Xem danh sách xe
app.get('/xe', (req, res) => {
  const sql = `SELECT * FROM XE`;

  db.query(sql, (err, results) => {
    if (err) {
      console.error('Lỗi khi lấy danh sách XE:', err);
      return res.status(500).json({ error: 'Lỗi server' });
    }
    res.status(200).json(results);
  });
});

//Thêm xe mới
app.post('/xe', (req, res) => {
  const { BienSoXe, LoaiXe, SoChoNgoi, HangSanXuat, NamSanXuat, MaBX } = req.body;

  console.log("Dữ liệu gửi lên:", req.body); // 👈 để debug

  if (!BienSoXe || !LoaiXe || !SoChoNgoi || !HangSanXuat || !NamSanXuat || !MaBX) {
    return res.status(400).json({ error: 'Thiếu thông tin xe' });
  }

  const sql = `INSERT INTO XE (BienSoXe, LoaiXe, SoChoNgoi, HangSanXuat, NamSanXuat, MaBX)
               VALUES (?, ?, ?, ?, ?, ?)`;

  db.query(sql, [BienSoXe, LoaiXe, SoChoNgoi, HangSanXuat, NamSanXuat, MaBX], (err, result) => {
    if (err) {
      console.error('Lỗi khi thêm xe:', err);
      return res.status(500).json({ error: 'Không thể thêm xe', detail: err.sqlMessage });
    }
    res.status(201).json({ message: 'Thêm xe thành công' });
  });
});


//Sửa xe
app.put('/xe/:BienSoXe', (req, res) => {
  const bienSoXe = req.params.BienSoXe;
  const { LoaiXe, SoChoNgoi, HangSanXuat, NamSanXuat, MaBX } = req.body;

  const sql = `UPDATE XE SET LoaiXe = ?, SoChoNgoi = ?, HangSanXuat = ?, NamSanXuat = ?, MaBX = ? WHERE BienSoXe = ?`;

  db.query(sql, [LoaiXe, SoChoNgoi, HangSanXuat, NamSanXuat, MaBX, bienSoXe], (err, result) => {
    if (err) {
      console.error('Lỗi khi cập nhật xe:', err);
      return res.status(500).json({ error: 'Không thể cập nhật xe' });
    }
    res.status(200).json({ message: 'Cập nhật xe thành công' });
  });
});

//Xóa xe
app.delete('/xe/:BienSoXe', (req, res) => {
  const bienSoXe = req.params.BienSoXe;

  const sql = `DELETE FROM XE WHERE BienSoXe = ?`;

  db.query(sql, [bienSoXe], (err, result) => {
    if (err) {
      console.error('Lỗi khi xoá xe:', err);
      return res.status(500).json({ error: 'Không thể xoá xe' });
    }
    res.status(200).json({ message: 'Xoá xe thành công' });
  });
});

// Sửa chuyến xe
app.put('/chuyenxe/:maCX', (req, res) => {
  const maCX = req.params.maCX;
  const {
    BienSoXe,
    ThoiGianDi,
    ThoiGianVe,
    DiemDi,
    DiemDen,
    LoaiHinhChuyenDi,
    GiaVe,
    SoChoNgoi
  } = req.body;

  if (!BienSoXe || !ThoiGianDi || !ThoiGianVe || !DiemDi || !DiemDen || !LoaiHinhChuyenDi || GiaVe == null || SoChoNgoi == null) {
    return res.status(400).json({ error: 'Thiếu dữ liệu bắt buộc' });
  }

  const sql = `
    UPDATE CHUYENXE 
    SET 
      BienSoXe = ?, 
      ThoiGianDi = ?, 
      ThoiGianVe = ?, 
      DiemDi = ?, 
      DiemDen = ?, 
      LoaiHinhChuyenDi = ?, 
      GiaVe = ?, 
      SoChoNgoi = ?
    WHERE MaCX = ?
  `;

  db.query(sql, [
    BienSoXe,
    ThoiGianDi,
    ThoiGianVe,
    DiemDi,
    DiemDen,
    LoaiHinhChuyenDi,
    GiaVe,
    SoChoNgoi,
    maCX
  ], (err, result) => {
    if (err) {
      console.error('Lỗi cập nhật chuyến xe:', err);
      return res.status(500).json({ error: 'Lỗi máy chủ' });
    }
    res.json({ message: 'Cập nhật chuyến xe thành công' });
  });
});

// Xóa chuyến xe
app.delete('/chuyenxe/:maCX', (req, res) => {
  const maCX = req.params.maCX;

  const sql = `DELETE FROM CHUYENXE WHERE MaCX = ?`;

  db.query(sql, [maCX], (err, result) => {
    if (err) {
      console.error('Lỗi xóa chuyến xe:', err);
      return res.status(500).json({ error: 'Lỗi máy chủ' });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Không tìm thấy chuyến xe để xóa' });
    }

    res.json({ message: 'Xóa chuyến xe thành công' });
  });
});

// Get trung chuyển
app.get('/trungchuyen', (req, res) => {
  const sql = `SELECT * FROM TRUNGCHUYEN`;

  db.query(sql, (err, results) => {
    if (err) {
      console.error('Lỗi khi lấy danh sách TRUNGCHUYEM:', err);
      return res.status(500).json({ error: 'Lỗi server' });
    }
    res.json(results);
  });
});

// Thêm trung chuyển
app.post('/add-trungchuyen', (req, res) => {
  const { MaCX, ThuTu, DiemDung, ThoiGianDen, ThoiGianDi } = req.body;

  const sql = `
    INSERT INTO TRUNGCHUYEN (MaCX, ThuTu, DiemDung, ThoiGianDen, ThoiGianDi)
    VALUES (?, ?, ?, ?, ?)
  `;

  db.query(sql, [MaCX, ThuTu, DiemDung, ThoiGianDen, ThoiGianDi], (err, result) => {
    if (err) {
      console.error('Lỗi thêm trung chuyển:', err);
      return res.status(500).json({ error: 'Lỗi máy chủ' });
    }
    res.json({ message: 'Thêm trung chuyển thành công' });
  });
});

// Sửa trung chuyển
app.put('/trungchuyen/:maCX/:thuTu', (req, res) => {
  const { maCX, thuTu } = req.params;
  const { DiemDung, ThoiGianDen, ThoiGianDi } = req.body;

  if (!DiemDung || !ThoiGianDen || !ThoiGianDi) {
    return res.status(400).json({ error: 'Thiếu dữ liệu bắt buộc' });
  }

  const sql = `
    UPDATE TRUNGCHUYEN 
    SET DiemDung = ?, ThoiGianDen = ?, ThoiGianDi = ?
    WHERE MaCX = ? AND ThuTu = ?
  `;
  const values = [DiemDung, ThoiGianDen, ThoiGianDi, maCX, thuTu];

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error('Lỗi khi cập nhật trung chuyển:', err);
      return res.status(500).json({ error: 'Lỗi server' });
    }

    res.json({ message: 'Cập nhật trung chuyển thành công' });
  });
});

// Xóa trung chuyển
app.delete('/trungchuyen/:maCX/:thuTu', (req, res) => {
  const { maCX, thuTu } = req.params;

  const sql = `DELETE FROM TRUNGCHUYEN WHERE MaCX = ? AND ThuTu = ?`;
  db.query(sql, [maCX, thuTu], (err, result) => {
    if (err) {
      console.error('Lỗi khi xóa trung chuyển:', err);
      return res.status(500).json({ error: 'Lỗi server' });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Không tìm thấy điểm trung chuyển để xóa' });
    }

    res.json({ message: 'Xóa trung chuyển thành công' });
  });
});

// GET nhân viên
app.get('/nhanvien', (req, res) => {
  const sql = `SELECT * FROM NHANVIEN`;
  db.query(sql, (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn:', err);
      res.status(500).json({ error: 'Lỗi máy chủ' });
    } else {
      res.json(result);
    }
  });
});

// GET phân công
app.get('/phancong', (req, res) => {
  const sql = `SELECT * FROM PHANCONG`;
  db.query(sql, (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn:', err);
      res.status(500).json({ error: 'Lỗi máy chủ' });
    } else {
      res.json(result);
    }
  });
});

// Thêm phân công
app.post('/add-phancong', (req, res) => {
  const { MaCX, MaNV, ViTri, NgayPhanCong } = req.body;

  if (!MaCX || !MaNV || !ViTri || !NgayPhanCong) {
    return res.status(400).json({ error: 'Thiếu thông tin' });
  }

  const sql = `
    INSERT INTO PHANCONG (MaCX, MaNV, ViTri, NgayPhanCong)
    VALUES (?, ?, ?, ?)
  `;

  db.query(sql, [MaCX, MaNV, ViTri, NgayPhanCong], (err, result) => {
    if (err) {
      console.error('Lỗi thêm phân công:', err);
      return res.status(500).json({ error: 'Lỗi máy chủ' });
    }
    res.json({ message: 'Thêm thành công' });
  });
});

// Sửa phân công
app.put('/phancong/:maCX/:maNV', (req, res) => {
  const { maCX, maNV } = req.params;
  const { ViTri, NgayPhanCong } = req.body;

  if (!ViTri || !NgayPhanCong) {
    return res.status(400).json({ error: 'Thiếu dữ liệu bắt buộc' });
  }

  const sql = `
    UPDATE PHANCONG
    SET ViTri = ?, NgayPhanCong = ?
    WHERE MaCX = ? AND MaNV = ?
  `;

  db.query(sql, [ViTri, NgayPhanCong, maCX, maNV], (err, result) => {
    if (err) {
      console.error('Lỗi khi cập nhật phân công:', err);
      return res.status(500).json({ error: 'Lỗi máy chủ' });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Không tìm thấy phân công để cập nhật' });
    }

    res.json({ message: 'Cập nhật phân công thành công' });
  });
});
// XÓA phân công
app.delete('/phancong/:maCX/:maNV', (req, res) => {
  const { maCX, maNV } = req.params;

  const sql = 'DELETE FROM PHANCONG WHERE MaCX = ? AND MaNV = ?';
  db.query(sql, [maCX, maNV], (err, result) => {
    if (err) {
      console.error('Lỗi khi xóa phân công:', err);
      return res.status(500).json({ error: 'Lỗi máy chủ' });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Không tìm thấy phân công để xóa' });
    }

    res.json({ message: 'Xóa phân công thành công' });
  });
})

// Khởi động server
app.listen(port, '0.0.0.0', () => {
  console.log(`🚀 Server đang chạy tại http://0.0.0.0:${port}`);
});