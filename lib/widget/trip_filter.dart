import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

class TripFilterWidget extends StatefulWidget {
  final void Function(Map<String, dynamic>) onFilterChanged;

  const TripFilterWidget({super.key, required this.onFilterChanged});

  @override
  State<TripFilterWidget> createState() => _TripFilterWidgetState();
}

class _TripFilterWidgetState extends State<TripFilterWidget> {
  bool isExpanded = true;

  Set<String> selectedTimeRanges = {};
  Set<String> selectedTypes = {};
  Set<String> selectedSeats = {};
  Set<String> selectedFloors = {};

  void _toggleSelection(Set<String> set, String value) {
    setState(() {
      set.contains(value) ? set.remove(value) : set.add(value);
    });

    widget.onFilterChanged({
      'timeRanges': selectedTimeRanges,
      'types': selectedTypes,
      'seats': selectedSeats,
      'floors': selectedFloors,
    });
  }

  Widget _buildTagButton(String text, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.mainOrange : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? AppColors.mainOrange : Colors.black,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _buildInlineSection(String label, List<String> options, Set<String> selectedSet) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: options.map((option) {
                return _buildTagButton(
                  option,
                  selectedSet.contains(option),
                  () => _toggleSelection(selectedSet, option),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAll() {
    setState(() {
      selectedTimeRanges.clear();
      selectedTypes.clear();
      selectedSeats.clear();
      selectedFloors.clear();
    });
    widget.onFilterChanged({});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: nhãn + icon bên phải
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 0),
                child: Text(
                  "BỘ LỌC TÌM KIẾM",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    fontSize: 17,
                  ),
                ),
              ),
              Row(
                children: [
                  if (isExpanded)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.mainOrange),
                      onPressed: _clearAll,
                    ),
                  IconButton(
                    icon: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.red,
                    ),
                    onPressed: () => setState(() => isExpanded = !isExpanded),
                  ),
                ],
              ),
            ],
          ),

          // Bộ lọc nếu đang mở
          if (isExpanded) ...[
            _buildInlineSection("Giờ đi", [
              "00:00 - 06:00",
              "06:00 - 12:00",
              "12:00 - 18:00",
              "18:00 - 24:00"
            ], selectedTimeRanges),
            _buildInlineSection("Loại xe", ["Ghế", "Giường", "Limousine"], selectedTypes),
            _buildInlineSection("Ghế", ["Hàng đầu", "Hàng giữa", "Hàng cuối"], selectedSeats),
            _buildInlineSection("Tầng", ["Tầng trên", "Tầng dưới"], selectedFloors),
          ],
        ],
      ),
    );
  }
}