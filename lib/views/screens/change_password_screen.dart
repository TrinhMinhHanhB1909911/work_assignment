import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/cubits/home/home_cubit.dart';
import 'package:work_assignment/cubits/staff/staff_cubit.dart';
import 'package:work_assignment/models/staff.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen(this.staff, {super.key});
  final Staff staff;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String oldPassword = '';
  String newPassword = '';
  String confirmNewPassword = '';
  bool isError = false;
  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final staffCubit = context.read<StaffCubit>();
    final nav = Navigator.of(context);
    final focusScope = FocusScope.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
        elevation: 0.0,
      ),
      body: BlocBuilder<StaffCubit, StaffState>(
        builder: (context, state) {
          if (state is StaffsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                const SizedBox(height: 40.0),
                TextField(
                  obscureText: true,
                  onChanged: (value) => oldPassword = value,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Mật khẩu cũ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                TextField(
                  obscureText: true,
                  onChanged: (value) => newPassword = value,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Mật khẩu mới',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                TextField(
                  obscureText: true,
                  onChanged: (value) => confirmNewPassword = value,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'xác nhận mật khẩu mới',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Visibility(
                  visible: isError,
                  child: Text(
                    'Thông tin không chính xác',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      focusScope.unfocus();
                      bool isValid = checkPassword();
                      if (!isValid) {
                        setState(() {
                          isError = true;
                        });
                        return;
                      }
                      bool confirm = await confirmDialog(context);
                      if (!confirm) return;
                      await staffCubit.updatePassword(
                          widget.staff, newPassword);
                      const message = 'Đổi mật khẩu thành công!';
                      const content = Text(message);
                      const snackBar = SnackBar(content: content);
                      scaffoldMessenger
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                      newPassword =
                          md5.convert(utf8.encode(newPassword)).toString();
                      homeCubit.staff?.password = newPassword;
                      nav.pop();
                    },
                    child: const Text('Xác nhận'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<bool> confirmDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc muốn đổi mật khẩu'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  bool checkPassword() {
    oldPassword = md5.convert(utf8.encode(oldPassword)).toString();
    return oldPassword.isNotEmpty &&
        newPassword.isNotEmpty &&
        confirmNewPassword.isNotEmpty &&
        oldPassword == widget.staff.password &&
        newPassword == confirmNewPassword;
  }
}
