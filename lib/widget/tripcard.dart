import 'package:flutter/material.dart';
import '../model/trip.dart';
import '../config/default.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onTap;

  const TripCard({Key? key, required this.trip, this.onTap}) : super(key: key);

  String formatCurrency(int amount) {
  String number = amount.toString();
  String result = '';
  int count = 0;

  for (int i = number.length - 1; i >= 0; i--) {
    result = number[i] + result;
    count++;
    if (count == 3 && i != 0) {
      result = '.' + result;
      count = 0;
    }
  }

  return result;
}

  @override
  Widget build(BuildContext context) {
    final isTrungChuyen = trip.loaiChuyen.toLowerCase() == 'trungchuyen';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              trip.image,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const SizedBox(height: 8),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///Nhãn
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Bắt đầu",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainOrange,
                              fontFamily: 'Inter',
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Kết thúc",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainOrange,
                              fontFamily: 'Inter',
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8,),

                    ///Giờ
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.gioBatDau,
                            style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            trip.gioKetThuc,
                            style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                          ),
                        ],
                      ),
                    ),

                    ///Địa điểm
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.diemDi,
                            style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            trip.diemDen,
                            style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                          ),
                        ],
                      ),
                    ),

                    ///Ghế & chỗ
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            trip.loaiGhe,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "${trip.soChoConLai} ",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    color: AppColors.black,
                                  ),
                                ),
                                const TextSpan(
                                  text: "chỗ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),

                if (isTrungChuyen) ...[
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Trung chuyển",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.greenDark,
                        fontFamily: 'Inter',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// Dòng trung chuyển chia thành 4 cột
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          "Địa điểm",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainOrange,
                            fontFamily: 'Inter',
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12,),

                      Expanded(
                        flex: 2,
                        child: Text(
                          trip.trungChuyen?.gioDung ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 3,
                        child: Text(
                          trip.trungChuyen?.diaDiem ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Text(
                          '${trip.trungChuyen?.thoiGianDung ?? ''}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 8),

                Container(
                  margin: const EdgeInsets.only(top: 16),
                  width: double.infinity,
                  height: 1,
                  color: AppColors.black,
                ),

                const SizedBox(height: 8),

                // Giá vé và nút chọn
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Giá vé: ${formatCurrency(trip.giaVe)} đ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainOrange,
                        fontSize: 15,
                        fontFamily: 'Inter',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onTap ?? () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainOrange,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Chọn chuyến',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Label - value layout đơn giản
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.mainOrange,
              fontFamily: 'Inter',
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}