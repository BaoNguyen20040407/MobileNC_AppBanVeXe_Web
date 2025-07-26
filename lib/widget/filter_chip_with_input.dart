import 'package:flutter/material.dart';

class FilterChipWithInputInline extends StatefulWidget {
  final List<Map<String, String>> filters; // [{label: 'Tiêu đề', value: 'TieuDe'}, ...]
  final Map<String, String> filterValues;
  final ValueChanged<Map<String, String>> onFilterChanged;

  const FilterChipWithInputInline({
    super.key,
    required this.filters,
    required this.filterValues,
    required this.onFilterChanged,
  });

  @override
  State<FilterChipWithInputInline> createState() => _FilterChipWithInputInlineState();
}

class _FilterChipWithInputInlineState extends State<FilterChipWithInputInline> {
  String? activeField;
  final Map<String, TextEditingController> controllers = {};

  final Color mainOrange = const Color(0xFFFF5722);

  @override
  void initState() {
    super.initState();
    for (var filter in widget.filters) {
      final value = widget.filterValues[filter['value']] ?? '';
      controllers[filter['value']!] = TextEditingController(text: value);
    }
  }

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: widget.filters.map((filter) {
      final field = filter['value']!;
      final isActive = activeField == field;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12), // khoảng cách giữa các field
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: mainOrange, width: 1.5),
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: isActive
                      ? TextField(
                          controller: controllers[field],
                          autofocus: true,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                            hintText: 'Nhập từ khóa',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            final updated = Map<String, String>.from(widget.filterValues);
                            updated[field] = value;
                            widget.onFilterChanged(updated);
                          },
                          onSubmitted: (_) => setState(() => activeField = null),
                        )
                      : GestureDetector(
                          onTap: () => setState(() => activeField = field),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.filterValues[field]?.isNotEmpty == true
                                  ? widget.filterValues[field]!
                                  : filter['label']!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                ),
              ),
              if (widget.filterValues[field]?.isNotEmpty == true)
                IconButton(
                  onPressed: () {
                    controllers[field]?.clear();
                    final updated = Map<String, String>.from(widget.filterValues);
                    updated[field] = '';
                    widget.onFilterChanged(updated);
                    setState(() {
                      if (activeField == field) activeField = null;
                    });
                  },
                  icon: const Icon(Icons.clear, size: 18),
                  color: mainOrange,
                  padding: const EdgeInsets.only(left: 4),
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}
}