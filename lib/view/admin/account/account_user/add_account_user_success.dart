import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/account/account_user/account_user_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class AddAccountUserSuccess extends StatelessWidget {
  const AddAccountUserSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return const SuccessScreen(
      message: 'Thêm tài khoản khách hàng thành công',
      nextScreen: AccountUserList(),
      routeName: '/tài khoản khách hàng',
    );
  }
}