import 'package:flutter/material.dart';

class FeedbackAndSupportList extends StatelessWidget {
  final String title;
  final String emptyMessage;
  final List<Map<String, dynamic>> items;
  final IconData icon;
  final void Function(Map<String, dynamic>) onItemTap;

  const FeedbackAndSupportList({
    super.key,
    required this.title,
    required this.emptyMessage,
    required this.items,
    required this.icon,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontFamily: 'Inter',
              ),
            ),
          ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(emptyMessage, style: const TextStyle(fontFamily: 'Inter')),
            ),
          ...items.map((item) {
            return Column(
              children: [
                InkWell(
                  onTap: () => onItemTap(item),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Icon(icon, color: Colors.black),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item['TieuDe'] ?? '',
                            style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1, thickness: 0.5, color: Colors.black12),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
