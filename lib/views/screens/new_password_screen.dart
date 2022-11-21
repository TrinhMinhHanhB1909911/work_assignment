import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/cubits/staff/staff_cubit.dart';

import '../../models/staff.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen(this.staff, {Key? key}) : super(key: key);
  final Staff staff;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final staffCubit = context.read<StaffCubit>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật mật khẩu'),
        elevation: 0,
      ),
      body: BlocBuilder<StaffCubit, StaffState>(
        builder: (context, state) {
          if (state is StaffsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 240.0),
                  Text(
                    'Nhập mật khẩu mới cho ${widget.staff.name}',
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Form(
                    key: formKey,
                    child: TextFormField(
                      obscureText: true,
                      controller: controller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu mới';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.password),
                        labelText: 'Nhập mật khẩu mới',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        bool isValid =
                            formKey.currentState?.validate() ?? false;
                        if (!isValid) {
                          return;
                        }
                        bool confirm = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Xác nhận'),
                              content: const Text(
                                  'Bạn có chắc muốn cấp mật khẩu mới?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('No'),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirm) {
                          if (await staffCubit.updatePassword(
                              widget.staff, controller.text)) {
                            scaffoldMessenger
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                    content: Text('Cập nhật thành công')),
                              );
                            controller.clear();
                          } else {
                            scaffoldMessenger
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                    content: Text('Cập nhật thất bại')),
                              );
                          }
                        }
                      },
                      child: const Text('Cập nhật'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
