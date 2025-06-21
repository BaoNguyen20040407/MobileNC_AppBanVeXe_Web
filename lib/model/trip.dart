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
    required this.image,
    required this.ngayDi,
    this.trungChuyen,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      loaiChuyen: json['loaiChuyen'],
      diemDi: json['diemDi'],
      diemDen: json['diemDen'],
      gioBatDau: json['gioBatDau'],
      gioKetThuc: json['gioKetThuc'],
      soChoConLai: json['soChoConLai'],
      giaVe: json['giaVe'],
      loaiGhe: json['loaiGhe'],
      image: json['image'],
      ngayDi: json['ngayDi'],
      trungChuyen: json['trungChuyen'] != null 
        ? TrungChuyen.fromJson(json['trungChuyen']) 
        : null
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