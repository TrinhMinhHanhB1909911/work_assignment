import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/clients/home_cubit.dart';

import 'package:work_assignment/staff/staff.dart';

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
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Expanded(
                child: ContentRow(
                    'Tên:', widget.staff.name, editing, nameController)),
            Expanded(
                child: ContentRow(
                    'Gmail:', widget.staff.gmail, editing, gmailController)),
            Expanded(
                child: ContentRow('Địa chỉ:', widget.staff.address, editing,
                    addressController)),
            Expanded(
                child: ContentRow('Vị trí:', widget.staff.position, editing,
                    positionController)),
            Expanded(
                child: ContentRow(
                    'Năm sinh:',
                    widget.staff.birthYear.toString(),
                    editing,
                    yearController)),
            Expanded(
                child: ContentRow(
                    'Giới\ntính:',
                    widget.staff.gender ?? 'chưa rõ',
                    editing,
                    genderController)),
            const Expanded(flex: 2, child: SizedBox()),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (editing) {
                    bool result = await confirm();
                    if (result) {
                      await changeAccountInfo();
                    }
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
      );
    });
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

  Future<void> changeAccountInfo() async {
    widget.staff.name = nameController.text;
    widget.staff.gmail = gmailController.text;
    widget.staff.address = addressController.text;
    widget.staff.position = positionController.text;
    widget.staff.birthYear = int.tryParse(yearController.text);
    widget.staff.gender = genderController.text;
    context.read<HomeCubit>().changeAccountInfo(widget.staff);
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
          child: Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Expanded(
          flex: 4,
          child: editing
              ? TextFormField(
                  controller: controller,
                )
              : Text(
                  value,
                  style: const TextStyle(fontSize: 18),
                ),
        ),
      ],
    );
  }
}
