import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/customer_admin/customer_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class EditCustomerSuccess extends StatelessWidget {
  const EditCustomerSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      message: 'Sửa thông tin khách hàng thành công',
      nextScreen: const CustomerListScreen(),
      routeName: '/customer_list',
    );
  }
}