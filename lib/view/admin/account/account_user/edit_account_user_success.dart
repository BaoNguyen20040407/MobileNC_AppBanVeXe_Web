import 'package:flutter/material.dart';
import 'package:giao_dien_1/view/admin/account/account_user/account_user_list.dart';
import 'package:giao_dien_1/widget/success.dart';

class EditAccountUserSuccess extends StatelessWidget {
  const EditAccountUserSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      message: 'Sửa thông tin tài khoản khách hàng\nthành công',
      nextScreen: const AccountUserList(),
      routeName: '/account_user_list',
    );
  }
}