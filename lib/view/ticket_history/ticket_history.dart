import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giao_dien_1/view/ticket_history/ticket_today.dart';
import 'package:giao_dien_1/view/ticket_history/ticket_last_7_days.dart';
import 'package:giao_dien_1/view/ticket_history/ticket_last_30_days.dart';
import 'package:giao_dien_1/view/ticket_history/ticket_all.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigated to: $value')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: AppBarProfile(title: 'LỊCH SỬ ĐẶT VÉ'),
      body: Column(
        children: [
          const SizedBox(height: 32), // Cách AppBar 32px
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _HistoryItem(
                        icon: Icons.calendar_today,
                        label: 'Hôm nay',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TicketTodayPage(),
                              settings: const RouteSettings(name: '/ticket_today'),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _HistoryItem(
                        icon: Icons.calendar_view_week,
                        label: '7 ngày trước',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TicketLast7DaysPage(),
                              settings: const RouteSettings(name: '/ticket_7_days_ago'),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _HistoryItem(
                        icon: Icons.calendar_month,
                        label: '30 ngày trước',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TicketLast30DaysPage(),
                              settings: const RouteSettings(name: '/ticket_30_days_ago'),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _HistoryItem(
                        icon: Icons.fact_check,
                        label: 'Tất cả',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TicketAllPage(),
                              settings: const RouteSettings(name: '/ticket_all'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Image.asset(
                    'assets/image/bridge.png',
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        leading: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: iconLabel != null
              ? Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    iconLabel!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                      fontFamily: 'Inter',
                    ),
                  ),
                )
              : Icon(icon, color: Colors.black, size: 20),
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        trailing: onCheckChanged != null
            ? Checkbox(
                value: isChecked,
                onChanged: onCheckChanged,
                activeColor: Colors.orange,
              )
            : null,
      ),
    );
  }
}
