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
    SELECT MaTK, TenDangNhapNV, MaNV
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
          MaTK: account.MaTK,
          Ma: account.MaNV
        }
      });
    }

    // If not found in TAIKHOANNV, check TAIKHOANKH
    const sqlCustomer = `
      SELECT MaTK, TenDangNhapKH, MaKH
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
          MaTK: account.MaTK,
          Ma: account.MaKH
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
    SELECT KH.MaKH, KH.HoVaTen, TK.TenDangNhapKH AS username, KH.SDT, KH.NgaySinh, KH.DiaChi, KH.Email, KH.URLHinhAnh
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

//Lấy thông tin Profile Nhân viên
app.get('/api/admin-info/:username', (req, res) => {
  const username = req.params.username;

  const sql = `
    SELECT 
      TK.TenDangNhapNV AS username,
      NV.SDT,
      NV.URLHinhAnh
    FROM TAIKHOANNV TK
    JOIN NHANVIEN NV ON TK.MaNV = NV.MaNV
    WHERE TK.TenDangNhapNV = ?
  `;

  db.query(sql, [username], (err, results) => {
    if (err) {
      console.error('❌ Lỗi truy vấn admin:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server' });
    }

    if (results.length === 0) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy nhân viên' });
    }

    const admin = results[0];
    res.json({
      success: true,
      data: {
        username: admin.username,
        SDT: admin.SDT,
        URLHinhAnh: admin.URLHinhAnh,
      },
    });
  });
});

//Xem thông tin tài khoản Admin (Full)
app.get('/api/full-admin/:username', async (req, res) => {
  const username = req.params.username;
  const query = `
  SELECT nv.*, tk.TenDangNhapNV AS username
  FROM TAIKHOANNV tk
  JOIN NHANVIEN nv ON tk.MaNV = nv.MaNV
  WHERE tk.TenDangNhapNV = ?
`;

  db.query(query, [username], (err, results) => {
    if (err) return res.status(500).json({ success: false, error: err });
    if (results.length === 0) return res.json({ success: false, message: 'Không tìm thấy' });
    res.json({ success: true, data: results[0] });
  });
});

// ✅ API upload avatar cho admin
app.post('/api/upload-avatar-admin/:username', upload.single('avatar'), (req, res) => {
  const username = req.params.username;
  const file = req.file;

  if (!file) {
    return res.status(400).json({ success: false, message: 'Không có file tải lên' });
  }

  const imageUrl = `/uploads/${file.filename}`;

  const sql = `
    UPDATE NHANVIEN NV
    JOIN TAIKHOANNV TK ON NV.MaNV = TK.MaNV
    SET NV.URLHinhAnh = ?
    WHERE TK.TenDangNhapNV = ?
  `;

  db.query(sql, [imageUrl, username], (err, result) => {
    if (err) {
      console.error('❌ Lỗi cập nhật ảnh admin:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server' });
    }

    return res.json({ success: true, imageUrl });
  });
});

//API tạo góp ý
app.post('/gopy', (req, res) => {
  const { TieuDe, NoiDungGopY, MaKH } = req.body;

  if (!TieuDe || !NoiDungGopY || !MaKH) {
    return res.status(400).json({ success: false, message: 'Thiếu dữ liệu' });
  }

  // Sinh mã góp ý tự tăng từ số 1
  db.query("SELECT MaGY FROM GOPY ORDER BY MaGY DESC LIMIT 1", (err, result) => {
    if (err) return res.status(500).json({ success: false, message: 'Lỗi server' });

    let newMaGY = "GY001";
    if (result.length > 0) {
      const lastNumber = parseInt(result[0].MaGY.slice(2), 10);
      newMaGY = 'GY' + String(lastNumber + 1).padStart(3, '0');
    }

    const sql = "INSERT INTO GOPY (MaGY, TieuDe, NoiDungGopY, MaKH) VALUES (?, ?, ?, ?)";
    db.query(sql, [newMaGY, TieuDe, NoiDungGopY, MaKH], (err2) => {
      if (err2) return res.status(500).json({ success: false, message: 'Lỗi khi thêm góp ý' });
      return res.json({ success: true, message: 'Gửi góp ý thành công', MaGY: newMaGY });
    });
  });
});

//API phản hồi góp ý
app.put('/gopy/:maGY/phanhoi', (req, res) => {
  const maGY = req.params.maGY;
  const { PhanHoi, MaNV } = req.body;

  if (!PhanHoi || !MaNV) {
    return res.status(400).json({ success: false, message: 'Thiếu dữ liệu phản hồi' });
  }

  const sql = "UPDATE GOPY SET PhanHoi = ?, MaNV = ? WHERE MaGY = ?";
  db.query(sql, [PhanHoi, MaNV, maGY], (err, result) => {
    if (err) return res.status(500).json({ success: false, message: 'Lỗi server' });
    if (result.affectedRows === 0) return res.status(404).json({ success: false, message: 'Không tìm thấy góp ý' });
    return res.json({ success: true, message: 'Phản hồi góp ý thành công' });
  });
});

//API lấy danh sách góp ý
app.get('/gopy', (req, res) => {
  const sql = `
    SELECT G.MaGY, G.TieuDe, G.NoiDungGopY, G.PhanHoi, G.MaKH, KH.HoVaTen, G.MaNV, NV.HoVaTen AS TenNV
    FROM GOPY G
    LEFT JOIN KHACHHANG KH ON G.MaKH = KH.MaKH
    LEFT JOIN NHANVIEN NV ON G.MaNV = NV.MaNV
    ORDER BY G.MaGY DESC
  `;
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ success: false, message: 'Lỗi server' });
    res.json({ success: true, data: results });
  });
});

// GET: Danh sách mã nhân viên
app.get('/nhanvien', (req, res) => {
  const sql = `SELECT MaNV FROM NHANVIEN`;
  db.query(sql, (err, result) => {
    if (err) {
      console.error('❌ Lỗi truy vấn:', err);
      res.status(500).json({ success: false, message: 'Lỗi máy chủ' });
    } else {
      res.json({ success: true, data: result });
    }
  });
});

// API: Lấy góp ý theo MaKH
app.get('/gopy/khachhang/:maKH', (req, res) => {
  const maKH = req.params.maKH;

  const sql = `
    SELECT G.MaGY, G.TieuDe, G.NoiDungGopY, G.PhanHoi, G.MaNV, NV.HoVaTen AS TenNV
    FROM GOPY G
    LEFT JOIN NHANVIEN NV ON G.MaNV = NV.MaNV
    WHERE G.MaKH = ?
    ORDER BY G.MaGY DESC
  `;

  db.query(sql, [maKH], (err, results) => {
    if (err) {
      console.error('❌ Lỗi khi truy vấn góp ý khách hàng:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server' });
    }

    res.json({ success: true, data: results });
  });
});

// API: Lấy phản hồi chi tiết theo MaGY
app.get('/gopy/detail/:maGY', (req, res) => {
  const maGY = req.params.maGY;

  const sql = `
    SELECT G.MaGY, G.TieuDe, G.NoiDungGopY, G.PhanHoi, G.MaNV, NV.HoVaTen AS TenNV
    FROM GOPY G
    LEFT JOIN NHANVIEN NV ON G.MaNV = NV.MaNV
    WHERE G.MaGY = ?
  `;

  db.query(sql, [maGY], (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn góp ý:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server' });
    }

    if (result.length === 0) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy góp ý' });
    }

    res.json({ success: true, data: result[0] });
  });
});

// API tạo hỗ trợ
app.post('/hotro', (req, res) => {
  const { TieuDe, CauHoi, MaKH } = req.body;

  // Kiểm tra dữ liệu bắt buộc
  if (!TieuDe || !CauHoi || !MaKH) {
    return res.status(400).json({ success: false, message: 'Thiếu dữ liệu' });
  }

  // Tạo mã hỗ trợ mới tự động
  db.query("SELECT MaHT FROM HOTRO ORDER BY MaHT DESC LIMIT 1", (err, result) => {
    if (err) return res.status(500).json({ success: false, message: 'Lỗi server khi lấy mã hỗ trợ cuối cùng' });

    let newMaHT = "HT001";
    if (result.length > 0) {
      const lastNumber = parseInt(result[0].MaHT.slice(2), 10);
      newMaHT = 'HT' + String(lastNumber + 1).padStart(3, '0');
    }

    // Câu trả lời và mã nhân viên ban đầu là NULL (chưa được phản hồi)
    const sql = "INSERT INTO HOTRO (MaHT, TieuDe, CauHoi, CauTraLoi, MaKH, MaNV) VALUES (?, ?, ?, NULL, ?, NULL)";
    db.query(sql, [newMaHT, TieuDe, CauHoi, MaKH], (err2) => {
      if (err2) return res.status(500).json({ success: false, message: 'Lỗi khi thêm hỗ trợ' });
      return res.json({ success: true, message: 'Gửi hỗ trợ thành công', MaHT: newMaHT });
    });
  });
});

// API: Lấy danh sách hỗ trợ
app.get('/hotro', (req, res) => {
  const sql = `
    SELECT 
      H.MaHT, H.TieuDe, H.CauHoi, H.CauTraLoi,
      H.MaKH, KH.HoVaTen AS TenKH,
      H.MaNV, NV.HoVaTen AS TenNV
    FROM HOTRO H
    LEFT JOIN KHACHHANG KH ON H.MaKH = KH.MaKH
    LEFT JOIN NHANVIEN NV ON H.MaNV = NV.MaNV
    ORDER BY H.MaHT DESC
  `;
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ success: false, message: 'Lỗi server' });
    res.json({ success: true, data: results });
  });
});

// API: Lấy danh sách hỗ trợ theo khách hàng
app.get('/hotro/khachhang/:maKH', (req, res) => {
  const maKH = req.params.maKH;
  const sql = `
    SELECT 
      H.MaHT, H.TieuDe, H.CauHoi, H.CauTraLoi,
      H.MaKH, KH.HoVaTen AS TenKH,
      H.MaNV, NV.HoVaTen AS TenNV
    FROM HOTRO H
    LEFT JOIN KHACHHANG KH ON H.MaKH = KH.MaKH
    LEFT JOIN NHANVIEN NV ON H.MaNV = NV.MaNV
    WHERE H.MaKH = ?
    ORDER BY H.MaHT DESC
  `;
  db.query(sql, [maKH], (err, results) => {
    if (err) return res.status(500).json({ success: false, message: 'Lỗi server' });
    res.json({ success: true, data: results });
  });
});

// API: Lấy chi tiết hỗ trợ theo MaHT
app.get('/hotro/detail/:maHT', (req, res) => {
  const maHT = req.params.maHT;

  const sql = `
    SELECT H.MaHT, H.TieuDe, H.CauHoi, H.CauTraLoi, H.MaKH, KH.HoVaTen AS TenKH, H.MaNV, NV.HoVaTen AS TenNV
    FROM HOTRO H
    LEFT JOIN KHACHHANG KH ON H.MaKH = KH.MaKH
    LEFT JOIN NHANVIEN NV ON H.MaNV = NV.MaNV
    WHERE H.MaHT = ?
  `;

  db.query(sql, [maHT], (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn hỗ trợ:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server' });
    }

    if (result.length === 0) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy hỗ trợ' });
    }

    res.json({ success: true, data: result[0] });
  });
});


//API trả lời hỗ trợ
app.put('/hotro/:maHT/phanhoi', (req, res) => {
  const maHT = req.params.maHT;
  const { CauTraLoi, MaNV } = req.body;

  // Kiểm tra dữ liệu đầu vào
  if (!CauTraLoi || !MaNV) {
    return res.status(400).json({
      success: false,
      message: 'Thiếu dữ liệu phản hồi (CauTraLoi hoặc MaNV)',
    });
  }

  const sql = 'UPDATE HOTRO SET CauTraLoi = ?, MaNV = ? WHERE MaHT = ?';
  db.query(sql, [CauTraLoi, MaNV, maHT], (err, result) => {
    if (err) {
      console.error('Lỗi phản hồi hỗ trợ:', err);
      return res.status(500).json({
        success: false,
        message: 'Lỗi server khi phản hồi hỗ trợ',
      });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy yêu cầu hỗ trợ để phản hồi',
      });
    }

    return res.json({
      success: true,
      message: 'Phản hồi hỗ trợ thành công',
    });
  });
});

//API lọc hỗ trợ
app.post('/hotro/loc', (req, res) => {
  const { MaHT, TieuDe, CauHoi, CauTraLoi, MaKH, MaNV } = req.body;

  let sql = `
    SELECT
      H.MaHT, H.TieuDe, H.CauHoi, H.CauTraLoi,
      H.MaKH, KH.HoVaTen AS TenKH,
      H.MaNV, NV.HoVaTen AS TenNV
    FROM HOTRO H
    LEFT JOIN KHACHHANG KH ON H.MaKH = KH.MaKH
    LEFT JOIN NHANVIEN NV ON H.MaNV = NV.MaNV
    WHERE 1=1
  `;

  const params = [];

  // ✅ Mã cần đúng tuyệt đối
  if (MaHT && MaHT.trim() !== '') {
    sql += ' AND H.MaHT = ?';
    params.push(MaHT.trim());
  }

  if (MaKH && MaKH.trim() !== '') {
    sql += ' AND H.MaKH = ?';
    params.push(MaKH.trim());
  }

  if (MaNV && MaNV.trim() !== '') {
    sql += ' AND H.MaNV = ?';
    params.push(MaNV.trim());
  }

  // ✅ Văn bản có thể gần đúng
  if (TieuDe && TieuDe.trim() !== '') {
    sql += ' AND H.TieuDe LIKE ?';
    params.push(`%${TieuDe.trim()}%`);
  }

  if (CauHoi && CauHoi.trim() !== '') {
    sql += ' AND H.CauHoi LIKE ?';
    params.push(`%${CauHoi.trim()}%`);
  }

  if (CauTraLoi && CauTraLoi.trim() !== '') {
    sql += ' AND H.CauTraLoi LIKE ?';
    params.push(`%${CauTraLoi.trim()}%`);
  }

  sql += ' ORDER BY H.MaHT DESC';

  db.query(sql, params, (err, results) => {
    if (err) {
      console.error('❌ Lỗi truy vấn lọc hỗ trợ:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server' });
    }

    res.json({ success: true, data: results });
  });
});

//API lọc góp ý
app.post('/gopy/loc', (req, res) => {
  const { MaGY, TieuDe, NoiDungGopY, PhanHoi, MaKH, MaNV } = req.body;

  let sql = `
    SELECT
      G.MaGY, G.TieuDe, G.NoiDungGopY, G.PhanHoi,
      G.MaKH, KH.HoVaTen AS TenKH,
      G.MaNV, NV.HoVaTen AS TenNV
    FROM GOPY G
    LEFT JOIN KHACHHANG KH ON G.MaKH = KH.MaKH
    LEFT JOIN NHANVIEN NV ON G.MaNV = NV.MaNV
    WHERE 1=1
  `;

  const params = [];

  // ✅ Mã cần đúng tuyệt đối
  if (MaGY && MaGY.trim() !== '') {
    sql += ' AND G.MaGY = ?';
    params.push(MaGY.trim());
  }

  if (MaKH && MaKH.trim() !== '') {
    sql += ' AND G.MaKH = ?';
    params.push(MaKH.trim());
  }

  if (MaNV && MaNV.trim() !== '') {
    sql += ' AND G.MaNV = ?';
    params.push(MaNV.trim());
  }

  // ✅ Văn bản có thể gần đúng
  if (NoiDungGopY && NoiDungGopY.trim() !== '') {
    sql += ' AND G.NoiDungGopY LIKE ?';
    params.push(`%${NoiDungGopY.trim()}%`);
  }

  if (PhanHoi && PhanHoi.trim() !== '') {
    sql += ' AND G.PhanHoi LIKE ?';
    params.push(`%${PhanHoi.trim()}%`);
  }

  if (TieuDe && TieuDe.trim() !== '') {
    sql += ' AND G.TieuDe LIKE ?';
    params.push(`%${TieuDe.trim()}%`);
  }

  sql += ' ORDER BY G.MaGY DESC';

  db.query(sql, params, (err, results) => {
    if (err) {
      console.error('❌ Lỗi truy vấn lọc hỗ trợ:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server' });
    }

    res.json({ success: true, data: results });
  });
});

// API lọc bến xe theo điều kiện
app.post('/benxe/loc', (req, res) => {
  const { MaBX, TenBX, DiaChi, TinhThanh } = req.body;

  let sql = `SELECT * FROM BENXE WHERE 1=1`;
  const params = [];

  // ✅ Lọc đúng tuyệt đối theo mã BX
  if (MaBX && MaBX.trim() !== '') {
    sql += ` AND MaBX = ?`;
    params.push(MaBX.trim());
  }

  // ✅ Các trường còn lại lọc gần đúng (LIKE)
  if (TenBX && TenBX.trim() !== '') {
    sql += ` AND TenBX LIKE ?`;
    params.push(`%${TenBX.trim()}%`);
  }

  if (DiaChi && DiaChi.trim() !== '') {
    sql += ` AND DiaChi LIKE ?`;
    params.push(`%${DiaChi.trim()}%`);
  }

  if (TinhThanh && TinhThanh.trim() !== '') {
    sql += ` AND TinhThanh LIKE ?`;
    params.push(`%${TinhThanh.trim()}%`);
  }

  sql += ` ORDER BY MaBX ASC`;

  db.query(sql, params, (err, results) => {
    if (err) {
      console.error('Lỗi truy vấn lọc bến xe:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server khi lọc' });
    }

    res.json({ success: true, data: results });
  });
});

//API lọc xe theo điều kiện
app.post('/xe/loc', (req, res) => {
  const { BienSoXe, LoaiXe, HangSanXuat, NamSanXuat, MaBX, SoChoNgoi } = req.body;

  // Liệt kê cột rõ ràng, tránh dùng *
  let sql = `SELECT BienSoXe, LoaiXe, SoChoNgoi, HangSanXuat, NamSanXuat, MaBX FROM XE WHERE 1=1`;
  const params = [];

  if (BienSoXe && BienSoXe.trim() !== '') {
    sql += ` AND BienSoXe = ?`;
    params.push(BienSoXe.trim());
  }

  if (LoaiXe && LoaiXe.trim() !== '') {
    sql += ` AND LoaiXe LIKE ?`;
    params.push(`%${LoaiXe.trim()}%`);
  }

  if (HangSanXuat && HangSanXuat.trim() !== '') {
    sql += ` AND HangSanXuat LIKE ?`;
    params.push(`%${HangSanXuat.trim()}%`);
  }

  if (SoChoNgoi && SoChoNgoi.toString().trim() !== '') {
    sql += ` AND SoChoNgoi = ?`;
    params.push(Number(SoChoNgoi));
  }

  if (NamSanXuat && NamSanXuat.toString().trim() !== '') {
    sql += ` AND NamSanXuat = ?`;
    params.push(Number(NamSanXuat));
  }

  if (MaBX && MaBX.trim() !== '') {
    sql += ` AND MaBX = ?`;
    params.push(MaBX.trim());
  }

  sql += ` ORDER BY BienSoXe ASC`;

  db.query(sql, params, (err, results) => {
    if (err) {
      console.error('Lỗi truy vấn lọc xe:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server khi lọc xe' });
    }

    res.json({ success: true, data: results });
  });
});

//API lọc chuyến xe có điều kiện
app.post('/chuyenxe/loc', (req, res) => {
  const {
    MaCX,
    BienSoXe,
    DiemDi,
    DiemDen,
    LoaiHinhChuyenDi,
    ThoiGianDi,
    ThoiGianVe,
    GiaVe,
    SoChoNgoi
  } = req.body;

  let sql = `
    SELECT MaCX, BienSoXe, ThoiGianDi, ThoiGianVe,
           DiemDi, DiemDen, LoaiHinhChuyenDi, GiaVe, SoChoNgoi
    FROM CHUYENXE
    WHERE 1 = 1
  `;
  const params = [];

  if (MaCX && MaCX.trim() !== '') {
    sql += ` AND MaCX = ?`;
    params.push(MaCX.trim());
  }

  if (BienSoXe && BienSoXe.trim() !== '') {
    sql += ` AND BienSoXe = ?`;
    params.push(BienSoXe.trim());
  }

  if (DiemDi && DiemDi.trim() !== '') {
    sql += ` AND DiemDi LIKE ?`;
    params.push(`%${DiemDi.trim()}%`);
  }

  if (DiemDen && DiemDen.trim() !== '') {
    sql += ` AND DiemDen LIKE ?`;
    params.push(`%${DiemDen.trim()}%`);
  }

  if (LoaiHinhChuyenDi && LoaiHinhChuyenDi.trim() !== '') {
    sql += ` AND LoaiHinhChuyenDi LIKE ?`;
    params.push(`%${LoaiHinhChuyenDi.trim()}%`);
  }

  if (ThoiGianDi && ThoiGianDi.trim() !== '') {
    sql += ` AND DATE(ThoiGianDi) = DATE(?)`;
    params.push(ThoiGianDi.trim());
  }

  if (ThoiGianVe && ThoiGianVe.trim() !== '') {
    sql += ` AND DATE(ThoiGianVe) = DATE(?)`;
    params.push(ThoiGianVe.trim());
  }

  if (GiaVe && !isNaN(GiaVe)) {
    sql += ` AND GiaVe = ?`;
    params.push(Number(GiaVe));
  }

  if (SoChoNgoi && !isNaN(SoChoNgoi)) {
    sql += ` AND SoChoNgoi = ?`;
    params.push(Number(SoChoNgoi));
  }

  sql += ` ORDER BY ThoiGianDi ASC`;

  db.query(sql, params, (err, results) => {
    if (err) {
      console.error('Lỗi truy vấn lọc chuyến xe:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server khi lọc chuyến xe' });
    }

    res.json({ success: true, data: results });
  });
});

//API lọc trung chuyển có điều kiện
app.post('/trungchuyen/loc', (req, res) => {
  const { MaCX, ThuTu, DiemDung, ThoiGianDen, ThoiGianDi } = req.body;

  let sql = `
    SELECT MaCX, ThuTu, DiemDung, ThoiGianDen, ThoiGianDi
    FROM TRUNGCHUYEN
    WHERE 1 = 1
  `;
  const params = [];

  if (MaCX && MaCX.trim() !== '') {
    sql += ` AND MaCX = ?`;
    params.push(MaCX.trim());
  }

  if (!isNaN(ThuTu)) {
    sql += ` AND ThuTu = ?`;
    params.push(Number(ThuTu));
  }

  if (DiemDung && DiemDung.trim() !== '') {
    sql += ` AND DiemDung = ?`;
    params.push(DiemDung.trim());
  }

  // Các trường còn lại chỉ lọc nếu có giá trị nhập
  if (ThoiGianDen && ThoiGianDen.trim() !== '') {
    sql += ` AND ThoiGianDen LIKE ?`;
    params.push(`%${ThoiGianDen.trim()}%`);
  }

  if (ThoiGianDi && ThoiGianDi.trim() !== '') {
    sql += ` AND ThoiGianDi LIKE ?`;
    params.push(`%${ThoiGianDi.trim()}%`);
  }

  sql += ` ORDER BY ThuTu ASC`;

  db.query(sql, params, (err, results) => {
    if (err) {
      console.error('Lỗi truy vấn trung chuyển:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server khi lọc trung chuyển' });
    }

    res.json({ success: true, data: results });
  });
});

//API lọc phân công có điều kiện
app.post('/phancong/loc', (req, res) => {
  const { MaCX, MaNV, ViTri, NgayPhanCong } = req.body;

  let sql = `
    SELECT pc.MaCX, pc.MaNV, pc.ViTri, pc.NgayPhanCong
    FROM PHANCONG pc
    JOIN NHANVIEN nv ON pc.MaNV = nv.MaNV
    WHERE 1 = 1
  `;
  const params = [];

  if (MaCX && MaCX.trim() !== '') {
    sql += ` AND pc.MaCX = ?`;
    params.push(MaCX.trim());
  }

  if (MaNV && MaNV.trim() !== '') {
    sql += ` AND pc.MaNV = ?`;
    params.push(MaNV.trim());
  }

  if (ViTri && ViTri.trim() !== '') {
    sql += ` AND pc.ViTri LIKE ?`;
    params.push(`%${ViTri.trim()}%`);
  }

  if (NgayPhanCong && NgayPhanCong.trim() !== '') {
    sql += ` AND pc.NgayPhanCong = ?`;
    params.push(NgayPhanCong.trim());
  }

  sql += ` ORDER BY pc.MaCX, pc.MaNV`;

  db.query(sql, params, (err, results) => {
    if (err) {
      console.error('Lỗi truy vấn phân công:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server khi lọc phân công' });
    }

    res.json({ success: true, data: results });
  });
});

//API lọc vé có điều kiện
app.post('/ve/loc', (req, res) => {
  const {
    MaVe,
    GiaVe,
    MaCX,
    MaKH,
    ViTriGheNgoi,
    LoaiVe,
    TrangThai,
    HinhThucThanhToan
  } = req.body;

  let sql = `
    SELECT v.MaVe, v.LoaiVe, v.ViTriGheNgoi, v.GiaVe, v.TrangThai, v.HinhThucThanhToan, v.MaCX, v.MaKH
    FROM VE v
    JOIN KHACHHANG kh ON v.MaKH = kh.MaKH
    JOIN CHUYENXE cx ON v.MaCX = cx.MaCX
    WHERE 1 = 1
  `;
  const params = [];

  // Các điều kiện lọc chính xác
  if (MaVe && MaVe.trim() !== '') {
    sql += ' AND MaVe = ?';
    params.push(MaVe.trim());
  }

  if (GiaVe && !isNaN(GiaVe)) {
    sql += ' AND GiaVe = ?';
    params.push(GiaVe);
  }

  if (MaCX && MaCX.trim() !== '') {
    sql += ' AND MaCX = ?';
    params.push(MaCX.trim());
  }

  if (MaKH && MaKH.trim() !== '') {
    sql += ' AND MaKH = ?';
    params.push(MaKH.trim());
  }

  if (ViTriGheNgoi && ViTriGheNgoi.trim() !== '') {
    sql += ' AND ViTriGheNgoi = ?';
    params.push(ViTriGheNgoi.trim());
  }

  // Các điều kiện lọc chứa ký tự
  if (LoaiVe && LoaiVe.trim() !== '') {
    sql += ' AND LoaiVe LIKE ?';
    params.push(`%${LoaiVe.trim()}%`);
  }

  if (TrangThai && TrangThai.trim() !== '') {
    sql += ' AND TrangThai LIKE ?';
    params.push(`%${TrangThai.trim()}%`);
  }

  if (HinhThucThanhToan && HinhThucThanhToan.trim() !== '') {
    sql += ' AND HinhThucThanhToan LIKE ?';
    params.push(`%${HinhThucThanhToan.trim()}%`);
  }

  sql += ' ORDER BY MaVe DESC';

  db.query(sql, params, (err, results) => {
    if (err) {
      console.error('❌ Lỗi truy vấn VE:', err);
      return res.status(500).json({ success: false, message: 'Lỗi truy vấn dữ liệu vé' });
    }

    res.json({ success: true, data: results });
  });
});

//Quên mật khẩu
//API check tồn tại email
app.post('/api/check-email', (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ success: false, message: 'Vui lòng cung cấp email.' });
  }

  const sql = `SELECT MaKH FROM KHACHHANG WHERE Email = ?`;
  db.query(sql, [email], (err, result) => {
    if (err) {
      console.error('Lỗi truy vấn email:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server.' });
    }

    if (result.length === 0) {
      return res.status(404).json({ success: false, message: 'Email không tồn tại.' });
    }

    // Trả lại MaKH để lưu vào SharedPreferences nếu cần
    const maKH = result[0].MaKH;
    return res.status(200).json({ success: true, maKH, message: 'Email hợp lệ.' });
  });
});

//API Update mật khẩu
app.put('/api/reset-password', (req, res) => {
  const { email, newPassword } = req.body;

  if (!email || !newPassword) {
    return res.status(400).json({ success: false, message: 'Thiếu email hoặc mật khẩu.' });
  }

  // Không mã hóa, dùng mật khẩu như chuỗi thuần
  const getKHSql = `SELECT MaKH FROM KHACHHANG WHERE Email = ?`;
  db.query(getKHSql, [email], (err, khResult) => {
    if (err) {
      console.error('Lỗi truy vấn KH:', err);
      return res.status(500).json({ success: false, message: 'Lỗi server khi truy vấn KH.' });
    }

    if (khResult.length === 0) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy khách hàng với email này.' });
    }

    const maKH = khResult[0].MaKH;

    const updatePasswordSql = `UPDATE TAIKHOANKH SET Password = ? WHERE MaKH = ?`;
    db.query(updatePasswordSql, [newPassword, maKH], (err, result) => {
      if (err) {
        console.error('Lỗi cập nhật mật khẩu:', err);
        return res.status(500).json({ success: false, message: 'Lỗi server khi cập nhật mật khẩu.' });
      }

      res.status(200).json({ success: true, message: 'Đổi mật khẩu thành công.' });
    });
  });
});

// ✅ API xem vé theo username của khách hàng
app.get('/api/ve', (req, res) => {
  const filter = req.query.filter || 'all';
  const username = req.query.username;

  if (!username) {
    return res.status(400).json({ error: 'Thiếu tên đăng nhập' });
  }

  // 🔍 Lấy MaKH từ username
  const getMaKHQuery = 'SELECT MaKH FROM TAIKHOANKH WHERE TenDangNhapKH = ?';

  db.query(getMaKHQuery, [username], (err, tkRows) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Lỗi máy chủ khi truy vấn tài khoản' });
    }

    if (tkRows.length === 0) {
      return res.status(404).json({ error: 'Không tìm thấy tài khoản' });
    }

    const maKH = tkRows[0].MaKH;

    // 📋 Truy vấn danh sách vé theo MaKH
    let query = `
      SELECT VE.MaVe, VE.GiaVe, VE.ViTriGheNgoi, VE.TrangThai,
             CHUYENXE.DiemDi, CHUYENXE.DiemDen, CHUYENXE.ThoiGianDi
      FROM VE
      JOIN CHUYENXE ON VE.MaCX = CHUYENXE.MaCX
      WHERE VE.MaKH = ?
    `;

    const params = [maKH];

    if (filter === 'today') {
      query += ' AND DATE(CHUYENXE.ThoiGianDi) = CURDATE()';
    } else if (filter === '7days') {
      query += ' AND CHUYENXE.ThoiGianDi BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)';
    } else if (filter === '30days') {
      query += ' AND CHUYENXE.ThoiGianDi BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)';
    }

    db.query(query, params, (err, veRows) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Lỗi máy chủ khi truy vấn vé' });
      }

      res.json(veRows);
    });
  });
});

//API tra cứu vé
app.get('/api/tim-ve', (req, res) => {
  const phone = req.query.phone;
  const code = req.query.code;

  if (!phone || !code) {
    return res.status(400).json({ error: 'Thiếu số điện thoại hoặc mã vé' });
  }

  // 🔍 Tìm MaKH từ KHACHHANG
  const khQuery = 'SELECT MaKH FROM KHACHHANG WHERE SDT = ?';

  db.query(khQuery, [phone], (err, khRows) => {
    if (err) {
      console.error('❌ Lỗi KHACHHANG:', err);
      return res.status(500).json({ error: 'Lỗi máy chủ khi tìm khách hàng' });
    }

    if (khRows.length === 0) {
      return res.status(404).json({ error: 'Không tìm thấy khách hàng với số điện thoại này' });
    }

    const maKH = khRows[0].MaKH;

    // 🔎 Tìm vé của khách hàng theo mã vé
    const veQuery = `
      SELECT VE.MaVe, VE.GiaVe, VE.ViTriGheNgoi, VE.TrangThai,
             CHUYENXE.DiemDi, CHUYENXE.DiemDen, CHUYENXE.ThoiGianDi
      FROM VE
      JOIN CHUYENXE ON VE.MaCX = CHUYENXE.MaCX
      WHERE VE.MaKH = ? AND VE.MaVe = ?
    `;

    db.query(veQuery, [maKH, code], (err, veRows) => {
      if (err) {
        console.error('❌ Lỗi VE:', err);
        return res.status(500).json({ error: 'Lỗi máy chủ khi truy vấn vé' });
      }

      if (veRows.length === 0) {
        return res.status(404).json({ error: 'Không tìm thấy vé phù hợp' });
      }

      return res.json(veRows); // chỉ trả về thông tin vé
    });
  });
});

//API xem chi tiết vé
app.get('/api/ve/:maVe', (req, res) => {
  const { maVe } = req.params;

  const sql = `
    SELECT 
      v.MaVe,
      v.LoaiVe,
      v.ViTriGheNgoi,
      v.GiaVe,
      v.TrangThai,
      v.HinhThucThanhToan,

      kh.HoVaTen AS HoTen,
      kh.SDT AS DienThoai,
      kh.Email,

      cx.DiemDi,
      cx.DiemDen,
      DATE_FORMAT(cx.ThoiGianDi, '%Y-%m-%d') AS NgayDi,
      TIME_FORMAT(cx.ThoiGianDi, '%H:%i') AS GioDi

    FROM VE v
    JOIN KHACHHANG kh ON v.MaKH = kh.MaKH
    JOIN CHUYENXE cx ON v.MaCX = cx.MaCX
    WHERE v.MaVe = ?
  `;

  db.query(sql, [maVe], (err, results) => {
    if (err) {
      console.error('Lỗi truy vấn:', err);
      return res.status(500).json({ message: 'Lỗi máy chủ' });
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'Không tìm thấy vé' });
    }

    return res.json(results[0]);
  });
});

//API tìm chuyến xe theo lịch trình
app.get('/api/lichtrinh', (req, res) => {
  const { diemDi = '', diemDen = '' } = req.query;

  const sql = `
    SELECT 
      cx.MaCX,
      cx.DiemDi,
      cx.DiemDen,
      TIME_FORMAT(cx.ThoiGianDi, '%H:%i') AS gioDi,
      TIME_FORMAT(cx.ThoiGianVe, '%H:%i') AS gioVe,
      cx.LoaiHinhChuyenDi,
      cx.GiaVe
    FROM CHUYENXE cx
    WHERE LOWER(cx.DiemDi) LIKE CONCAT('%', LOWER(?), '%')
       OR LOWER(cx.DiemDen) LIKE CONCAT('%', LOWER(?), '%')
  `;

  db.query(sql, [diemDi, diemDen], (err, results) => {
    if (err) {
      console.error('Lỗi truy vấn:', err);
      return res.status(500).json({ message: 'Lỗi máy chủ' });
    }

    res.json(results);
  });
});

// API tuyến phổ biến (tuyến ngẫu nhiên giới hạn số lượng)
app.get('/api/tuyenphobien', (req, res) => {
  const sql = `
    SELECT 
      MaCX,
      DiemDi,
      DiemDen,
      TIME_FORMAT(ThoiGianDi, '%H:%i') AS GioDi,
      TIME_FORMAT(ThoiGianVe, '%H:%i') AS GioVe,
      TIMESTAMPDIFF(MINUTE, ThoiGianDi, ThoiGianVe) AS DurationMinute,
      GiaVe
    FROM CHUYENXE
    ORDER BY RAND()
    LIMIT 6;
  `;

  db.query(sql, (err, results) => {
    if (err) {
      console.error('❌ Lỗi truy vấn tuyến phổ biến:', err);
      return res.status(500).json({ message: 'Lỗi máy chủ' });
    }

    const formatted = results.map(route => {
      const durationMin = route.DurationMinute;
      const durationFormatted = `${Math.floor(durationMin / 60)}h${(durationMin % 60).toString().padStart(2, '0')}ph`;

      return {
        from: route.DiemDi,
        to: route.DiemDen,
        departureTime: route.GioDi,
        duration: durationFormatted,
        price: `${Number(route.GiaVe).toLocaleString()} VNĐ`
      };
    });

    res.json(formatted);
  });
});

// Thêm vé
app.post('/ve', (req, res) => {
  const { LoaiVe, ViTriGheNgoi, GiaVe, TrangThai, HinhThucThanhToan, MaCX, MaKH } = req.body;

  if (!LoaiVe || !ViTriGheNgoi || !GiaVe || !TrangThai || !HinhThucThanhToan || !MaCX || !MaKH) {
    return res.status(400).json({ error: 'Thiếu thông tin bắt buộc' });
  }

  // Lấy số lượng vé hiện tại để tạo mã mới
  const countSql = `SELECT COUNT(*) AS count FROM VE`;
  db.query(countSql, (err, result) => {
    if (err) {
      console.error('Lỗi khi đếm vé:', err);
      return res.status(500).json({ error: 'Lỗi server khi đếm vé' });
    }

    const nextNumber = result[0].count + 1;
    const maVe = 'VE' + nextNumber.toString().padStart(3, '0'); 

    const insertSql = `
      INSERT INTO VE (MaVe, LoaiVe, ViTriGheNgoi, GiaVe, TrangThai, HinhThucThanhToan, MaCX, MaKH)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `;

    db.query(
      insertSql,
      [maVe, LoaiVe, ViTriGheNgoi, GiaVe, TrangThai, HinhThucThanhToan, MaCX, MaKH],
      (err, result) => {
        if (err) {
          console.error('Lỗi khi thêm vé:', err);
          return res.status(500).json({ error: 'Lỗi khi thêm vé' });
        }

        res.json({ message: 'Đặt vé thành công', maVe });
      }
    );
  });
});

// Khởi động server
app.listen(port, '0.0.0.0', () => {
  console.log(`🚀 Server đang chạy tại http://0.0.0.0:${port}`);
});