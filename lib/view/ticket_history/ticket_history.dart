import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketHistoryPage extends StatefulWidget {
  const TicketHistoryPage({super.key});

  @override
  State<TicketHistoryPage> createState() => _TicketHistoryPageState();
}

class _TicketHistoryPageState extends State<TicketHistoryPage> {
  bool showAll = false;

  @override
  void initState() {
    super.initState();
    _loadShowAll();
  }

  void _loadShowAll() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      showAll = prefs.getBool('showAll') ?? false;
    });
  }

  void _saveShowAll(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('showAll', value);
  }

  void navigateTo(String value) {
    // Implement your navigation logic here based on `value`
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Navigated to: $value')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/history_appbar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  centerTitle: true,
                  title: const Text(
                    'LỊCH SỬ ĐẶT VÉ',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color(0xFFFFF5E9),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _HistoryItem(
                          icon: Icons.calendar_today,
                          label: 'Hôm nay',
                          onTap: () => navigateTo('today'),
                        ),
                        _HistoryItem(
                          icon: Icons.calendar_view_week,
                          label: '7 ngày trước',
                          iconLabel: '7',
                          onTap: () => navigateTo('7_day_ago'),
                        ),
                        _HistoryItem(
                          icon: Icons.calendar_month,
                          label: '30 ngày trước',
                          iconLabel: '30',
                          onTap: () => navigateTo('30_day_ago'),
                        ),
                        _HistoryItem(
                          icon: Icons.fact_check,
                          label: 'Tất cả',
                          isChecked: showAll,
                          onCheckChanged: (val) {
                            setState(() => showAll = val ?? false);
                            _saveShowAll(val ?? false);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/image/bridge.png',
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? iconLabel;
  final bool isChecked;
  final ValueChanged<bool?>? onCheckChanged;
  final VoidCallback? onTap;

  const _HistoryItem({
    required this.icon,
    required this.label,
    this.iconLabel,
    this.isChecked = false,
    this.onCheckChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: iconLabel != null
            ? Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  iconLabel!,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            : Icon(icon),
        title: Text(label),
        trailing: onCheckChanged != null
            ? Checkbox(
                value: isChecked,
                onChanged: onCheckChanged,
              )
            : null,
      ),
    );
  }
}
