import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/main/homepage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:giao_dien_1/model/ticket.dart';
import 'package:giao_dien_1/config/default.dart';
import 'package:giao_dien_1/widget/ticket_info.dart';
import 'package:giao_dien_1/widget/appbar_profile.dart';
import 'package:giao_dien_1/view/ticket_lookup/ticket_details.dart';

class TicketAllPage extends StatefulWidget {
  const TicketAllPage({super.key});

  @override
  State<TicketAllPage> createState() => _TicketAllPageState();
}

class _TicketAllPageState extends State<TicketAllPage> {
  List<Ticket> allTickets = [];

  @override
  void initState() {
    super.initState();
    _loadAllTickets();
  }

  void _loadAllTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> ticketJsonList = prefs.getStringList('tickets') ?? [];

    final loadedTickets = ticketJsonList
        .map((e) => Ticket.fromJson(json.decode(e)))
        .toList();

    setState(() {
      allTickets = loadedTickets.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softOrangeBackground,
      appBar: const AppBarProfile(title: 'TẤT CẢ VÉ'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: allTickets.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.airline_seat_recline_normal,
                      size: 60,
                      color: AppColors.mainOrange.withOpacity(0.8),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Không có vé nào cả.\nHãy đặt vé nhé!',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.black,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomePage(),
                            settings: const RouteSettings(name: '/home'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainOrange,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                      label: const Text(
                        'Đặt vé',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                itemCount: allTickets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 32),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.mainOrange, width: 5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TicketInfoWidget(ticket: allTickets[index]),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TicketDetails(), // nếu cần truyền ticket thì sửa lại
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainOrange,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Xem chi tiết vé',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}