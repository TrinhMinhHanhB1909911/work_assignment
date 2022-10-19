import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './staff.dart';
import 'package:work_assignment/staff/staff_cubit.dart';

class AddStaffScreen extends StatefulWidget {
  const AddStaffScreen({Key? key}) : super(key: key);

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  late GlobalKey<FormState> _key;

  String name = '';
  String gmail = '';
  String address = '';
  String position = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    _key = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _key.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final staffCubit = BlocProvider.of<StaffCubit>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Thêm nhân viên'),
      ),
      body: Center(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(height: 32),
                  const Text(
                    'Thêm nhân viên',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    validator: validate,
                    onChanged: (value) => name = value,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      labelText: 'Tên',
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextFormField(
                    validator: validate,
                    onChanged: (value) => address = value,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                      labelText: 'Địa chỉ',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: validate,
                    onChanged: (value) => position = value,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_pin_sharp),
                      border: OutlineInputBorder(),
                      labelText: 'Vị trí',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Không bỏ trống';
                      }
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (!emailValid) {
                        return 'Gmail không hợp lệ';
                      }
                      return null;
                    },
                    onChanged: (value) => gmail = value,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail),
                      border: OutlineInputBorder(),
                      labelText: 'Gmail',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: validate,
                    onChanged: (value) => password = value,
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                      labelText: 'Mật khẩu',
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        bool isValid = _key.currentState?.validate() ?? false;
                        if (isValid) {
                          staffCubit.addStaff(
                            Staff(
                              name: name,
                              address: address,
                              gmail: gmail,
                              position: position,
                              password: password,
                            ),
                          );
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Trạng thái'),
                                content:
                                    const Text('Đã thêm một nhân viên mới'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      BlocProvider.of<StaffCubit>(context)
                                          .allStaffs();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: const Text(
                        'Thêm',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Không bỏ trống';
    }
    return null;
  }
}
