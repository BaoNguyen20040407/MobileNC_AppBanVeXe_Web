const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();
const multer = require('multer');
const path = require('path');
const port = 3000;
app.use('/uploads', express.static('uploads'));

// Kích hoạt CORS để cho phép gọi từ Flutter web/mobile
app.use(cors({
  origin: '*', // hoặc bạn chỉ định cụ thể origin client
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// Set up storage
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => {
    const uniqueName = Date.now() + '-' + file.originalname;
    cb(null, uniqueName);
  },
});
const upload = multer({ storage: storage });

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



app.post('/insert-khachhang', upload.single('profileImage'), async (req, res) => {
  const input = req.body;

  console.log("Received POST:", input); // TenDangNhapKH should now show

  const imageUrl = req.file ? `/uploads/${req.file.filename}` : null;

  // Validation check
  if (
    !input.HoVaTen ||
    !input.NgaySinh ||
    !input.DiaChi ||
    !input.Email ||
    !input.SDT ||
    !input.Password ||
    !input.TenDangNhapKH
  ) {
    console.error("Missing fields:", input);
    return res.status(400).json({ success: false, error: 'Missing required fields' });
  }

  // Format date dd/mm/yyyy → yyyy-mm-dd
  const parts = input.NgaySinh.split('/');
  const formattedDate = `${parts[2]}-${parts[1]}-${parts[0]}`;

  // Get next MaKH
  db.query("SELECT MaKH FROM KHACHHANG WHERE MaKH LIKE 'KH%' ORDER BY MaKH DESC LIMIT 1", (err1, khRes) => {
    if (err1) {
      console.error("KHACHHANG select error:", err1);
      return res.json({ success: false, error: err1.message });
    }

    let newMaKH = 'KH001';
    if (khRes.length > 0) {
      const lastNumber = parseInt(khRes[0].MaKH.slice(2), 10);
      newMaKH = 'KH' + String(lastNumber + 1).padStart(3, '0');
    }
    console.log("Generated MaKH:", newMaKH);

    const khachHangSql = `INSERT INTO KHACHHANG (MaKH, HoVaTen, NgaySinh, DiaChi, Email, SDT, URLHinhAnh) VALUES (?, ?, ?, ?, ?, ?, ?)`;
    const khachHangValues = [newMaKH, input.HoVaTen, formattedDate, input.DiaChi, input.Email, input.SDT, imageUrl];

    db.query(khachHangSql, khachHangValues, (err2) => {
      if (err2) {
        console.error("KHACHHANG insert error:", err2);
        return res.json({ success: false, error: err2.message });
      }

      // Get next MaTK
      db.query("SELECT MaTK FROM TAIKHOANKH ORDER BY MaTK DESC LIMIT 1", (err3, tkRes) => {
        if (err3) {
          console.error("TAIKHOANKH select error:", err3);
          return res.json({ success: false, error: err3.message });
        }

        let newMaTK = 'TK001';
        if (tkRes.length > 0) {
          const lastTKNumber = parseInt(tkRes[0].MaTK.slice(2), 10);
          newMaTK = 'TK' + String(lastTKNumber + 1).padStart(3, '0');
        }
        console.log("Generated MaTK:", newMaTK);

        const insertAccountSql = `INSERT INTO TAIKHOANKH (MaTK, TenDangNhapKH, Password, MaKH) VALUES (?, ?, ?, ?)`;
        const accountValues = [newMaTK, input.TenDangNhapKH, input.Password, newMaKH];

        console.log("Preparing to insert TAIKHOANKH:");
        console.log("Query:", insertAccountSql);
        console.log("Values:", accountValues);
        console.log("input.TenDangNhapKH:", input.TenDangNhapKH);


        db.query(insertAccountSql, accountValues, (err4) => {
          if (err4) {
            console.error("TAIKHOANKH insert error:", err4);
            return res.json({ success: false, error: err4.message });
          }

          return res.json({ success: true, MaKH: newMaKH, MaTK: newMaTK, avatarUrl: imageUrl });
        });
      });
    });
  });
});



app.post('/login', (req, res) => {
  const username = req.body.username;
  const password = req.body.password;

  const sqlStaff = `
    SELECT MaTK, TenDangNhapNV
    FROM TAIKHOANNV
    WHERE TenDangNhapNV = ? AND Password = ?
  `;

  db.query(sqlStaff, [username, password], (err, staffResult) => {
    if (err) {
      console.error("Staff login query error:", err);
      return res.status(500).json({ success: false, error: err.message });
    }

    if (staffResult.length > 0) {
      const account = staffResult[0];
      return res.json({
        success: true,
        role: 'admin',
        data: {
          username: account.TenDangNhapNV,
          MaTK: account.MaTK
        }
      });
    }

    // If not found in TAIKHOANNV, check TAIKHOANKH
    const sqlCustomer = `
      SELECT MaTK, TenDangNhapKH
      FROM TAIKHOANKH
      WHERE TenDangNhapKH = ? AND Password = ?
    `;

    db.query(sqlCustomer, [username, password], (err, customerResult) => {
      if (err) {
        console.error("Customer login query error:", err);
        return res.status(500).json({ success: false, error: err.message });
      }

      if (customerResult.length === 0) {
        return res.status(401).json({ success: false, error: 'Tên đăng nhập hoặc mật khẩu không đúng' });
      }

      const account = customerResult[0];
      return res.json({
        success: true,
        role: 'customer',
        data: {
          username: account.TenDangNhapKH,
          MaTK: account.MaTK
        }
      });
    });
  });
});

// 👉 Thêm route mới tại đây
app.post('/insert-taikhoankh', (req, res) => {
  const { TenDangNhapKH, Password, MaKH } = req.body;

  // Kiểm tra dữ liệu
  if (!TenDangNhapKH || !Password || !MaKH) {
    return res.status(400).json({ success: false, message: 'Thiếu thông tin tài khoản' });
  }

  // TODO: Thêm vào database ở đây
  console.log('✅ Nhận thông tin tài khoản:', req.body);

  // Tạm trả về giả lập thành công
  res.json({
    success: true,
    message: 'Tạo tài khoản khách hàng thành công',
    data: {
      TenDangNhapKH,
      MaKH
    }
  });
});

//Lấy thông tin profile khách hàng
app.get('/user-info/:username', (req, res) => {
  const username = req.params.username;

  const query = `
    SELECT KH.HoVaTen, KH.SDT, KH.URLHinhAnh
    FROM TAIKHOANKH TK
    JOIN KHACHHANG KH ON TK.MaKH = KH.MaKH
    WHERE TK.TenDangNhapKH = ?
  `;

  db.query(query, [username], (err, results) => {
    if (err) {
      return res.status(500).json({ success: false, error: err.message });
    }

    if (results.length === 0) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy người dùng' });
    }

    return res.json({ success: true, data: results[0] });
  });
});

//Lấy thông tin khách hàng (full)
app.get('/api/full-user/:username', (req, res) => {
  const username = req.params.username;

  const sql = `
    SELECT KH.HoVaTen, TK.TenDangNhapKH AS username, KH.SDT, KH.NgaySinh, KH.DiaChi, KH.Email, KH.URLHinhAnh
    FROM TAIKHOANKH TK
    JOIN KHACHHANG KH ON TK.MaKH = KH.MaKH
    WHERE TK.TenDangNhapKH = ?
  `;

  db.query(sql, [username], (err, results) => {
    if (err) {
      console.error('❌ Lỗi khi truy vấn DB:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server', error: err.message });
    }

    if (results.length === 0) {
      return res.status(404).json({ success: false, message: 'Người dùng không tồn tại' });
    }

    return res.json({
      success: true,
      message: 'Lấy thông tin người dùng thành công',
      data: results[0],
    });
  });
});


//Cập nhật thông tin khách hàng
app.put('/update-user/:username', upload.single('avatar'), (req, res) => {
  const username = req.params.username;
  const { HoVaTen, NgaySinh, DiaChi, Email } = req.body;
  const imageUrl = req.file ? '/uploads/' + req.file.filename : null;

  const sql = `
  UPDATE KHACHHANG KH
  JOIN TAIKHOANKH TK ON KH.MaKH = TK.MaKH
  SET KH.HoVaTen = ?, KH.NgaySinh = ?, KH.DiaChi = ?, KH.Email = ? ${imageUrl ? ', KH.URLHinhAnh = ?' : ''}
  WHERE TK.TenDangNhapKH = ?
`;

  const params = imageUrl
    ? [HoVaTen, NgaySinh, DiaChi, Email, imageUrl, username]
    : [HoVaTen, NgaySinh, DiaChi, Email, username];

  db.query(sql, params, (err, result) => {
    if (err) {
      console.error('Lỗi update user:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server' });
    }
    res.json({ success: true, message: 'Cập nhật thành công' });
  });
});


// Khởi động server
app.listen(port, '0.0.0.0', () => {
  console.log(`🚀 Server đang chạy tại http://0.0.0.0:${port}`);
});