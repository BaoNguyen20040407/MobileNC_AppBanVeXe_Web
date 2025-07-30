class Trip {
  final int id;
  final String loaiChuyen; 
  final String diemDi;
  final String diemDen;
  final String gioBatDau;
  final String gioKetThuc;
  final int soChoConLai;
  final int giaVe;
  final String loaiGhe;
  final String image;
  final TrungChuyen? trungChuyen;
  final String ngayDi;

  Trip({
    required this.id,
    required this.loaiChuyen,
    required this.diemDi,
    required this.diemDen,
    required this.gioBatDau,
    required this.gioKetThuc,
    required this.soChoConLai,
    required this.giaVe,
    required this.loaiGhe,
    this.image = 'assets/image/bus1.jpg',
    required this.ngayDi,
    this.trungChuyen,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: 0, // Không có trong JSON nên gán mặc định
      loaiChuyen: json['LoaiHinhChuyenDi'] ?? '',
      diemDi: json['DiemDi'] ?? '',
      diemDen: json['DiemDen'] ?? '',
      gioBatDau: json['gioDi'] ?? '',
      gioKetThuc: json['gioVe'] ?? '',
      soChoConLai: 0, // Không có trong JSON
      giaVe: json['GiaVe'] != null ? int.tryParse(json['GiaVe'].toString()) ?? 0 : 0,
      loaiGhe: json['LoaiHinhChuyenDi'] ?? '',
      ngayDi: '', // Không có trong JSON
      image: 'assets/image/bus1.jpg',
      trungChuyen: null, // Không có trong JSON
    );
  }
}

class TrungChuyen {
  final String diaDiem;
  final String thoiGianDung;
  final String? gioDung; 

  TrungChuyen({
    required this.diaDiem, 
    required this.thoiGianDung,
    required this.gioDung}
  );

  factory TrungChuyen.fromJson(Map<String, dynamic> json) {
    return TrungChuyen(
      diaDiem: json['diaDiem'] ?? '',
      thoiGianDung: json['thoiGianDung'] ?? '',
      gioDung: json['gioDung'] ?? '');
  }
}