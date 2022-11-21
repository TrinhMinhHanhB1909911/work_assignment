import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/cubits/home/home_cubit.dart';
import 'package:work_assignment/cubits/home/home_state.dart';

import 'package:work_assignment/models/staff.dart';

import '../screens/change_password_screen.dart';

class AccountContainer extends StatefulWidget {
  const AccountContainer({Key? key, required this.staff}) : super(key: key);

  final Staff staff;

  @override
  State<AccountContainer> createState() => _AccountContainerState();
}

class _AccountContainerState extends State<AccountContainer> {
  bool editing = false;

  late TextEditingController nameController;
  late TextEditingController gmailController;
  late TextEditingController addressController;
  late TextEditingController positionController;
  late TextEditingController yearController;
  late TextEditingController genderController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.staff.name);
    gmailController = TextEditingController(text: widget.staff.gmail);
    addressController = TextEditingController(text: widget.staff.address);
    positionController = TextEditingController(text: widget.staff.position);
    yearController = TextEditingController(
      text: widget.staff.birthYear.toString(),
    );
    genderController = TextEditingController(text: widget.staff.gender);
  }

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: RefreshIndicator(
            onRefresh: homeCubit.reFreshInfo,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ContentRow(
                      'Tên:', widget.staff.name, editing, nameController),
                  const SizedBox(height: 40),
                  ContentRow(
                      'Gmail:', widget.staff.gmail, editing, gmailController),
                  const SizedBox(height: 40),
                  ContentRow('Địa chỉ:', widget.staff.address, editing,
                      addressController),
                  const SizedBox(height: 40),
                  ContentRow('Vị trí:', widget.staff.position, editing,
                      positionController),
                  const SizedBox(height: 40),
                  ContentRow('Năm sinh:', widget.staff.birthYear.toString(),
                      editing, yearController),
                  const SizedBox(height: 40),
                  ContentRow('Giới tính:', widget.staff.gender ?? 'chưa rõ',
                      editing, genderController),
                  const SizedBox(height: 20.0),
                  Visibility(
                    visible: !editing,
                    child: ListTile(
                      tileColor: Colors.white,
                      onTap: () {
                        builder(context) => ChangePasswordScreen(widget.staff);
                        final route = MaterialPageRoute(builder: builder);
                        Navigator.of(context).push(route);
                      },
                      title: const Text('Đổi mật khẩu'),
                      trailing: const Icon(CupertinoIcons.forward),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (editing) {
                          bool result = await confirm();
                          if (result) {
                            await changeAccountInfo(scaffoldMessenger);
                          } else {
                            resetController();
                            setState(() {
                              editing = !editing;
                            });
                          }
                          return;
                        }
                        setState(() {
                          editing = !editing;
                        });
                      },
                      child: Text(editing ? 'Xong' : 'Sửa'),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> confirm() async {
    return await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc muốn sửa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  Future<void> changeAccountInfo(
      ScaffoldMessengerState scaffoldMessenger) async {
    widget.staff.name = nameController.text;
    widget.staff.gmail = gmailController.text;
    widget.staff.address = addressController.text;
    widget.staff.position = positionController.text;
    widget.staff.birthYear = int.tryParse(yearController.text);
    widget.staff.gender = genderController.text;
    await context.read<HomeCubit>().changeAccountInfo(widget.staff);
    const message = 'Cập nhật thành công';
    const content = Text(message);
    const snackBar = SnackBar(content: content);
    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void resetController() {
    nameController.text = widget.staff.name;
    gmailController.text = widget.staff.gmail;
    addressController.text = widget.staff.address;
    positionController.text = widget.staff.position;
    yearController.text = widget.staff.birthYear.toString();
    genderController.text = widget.staff.gender ?? 'chưa rõ';
  }
}

class ContentRow extends StatelessWidget {
  const ContentRow(this.label, this.value, this.editing, this.controller,
      {Key? key})
      : super(key: key);
  final String label;
  final String value;
  final bool editing;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Expanded(
          flex: 6,
          child: TextFormField(
            controller: controller,
            readOnly: !editing,
            decoration: InputDecoration(
                filled: true,
                fillColor: editing ? Colors.white : Colors.indigo.shade100,
                border: InputBorder.none),
          ),
        ),
      ],
    );
  }
}
