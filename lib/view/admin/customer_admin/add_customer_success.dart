import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/customer_admin/customer_list.dart';
import 'package:giao_dien_1/widget/success.dart'; 

class AddCustomerSuccess extends StatelessWidget {
  const AddCustomerSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return const SuccessScreen(
      message: 'Thêm khách hàng thành công',
      nextScreen: CustomerListScreen(),
      routeName: '/khách hàng',
    );
  }
}