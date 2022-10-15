import 'package:flutter/material.dart';

import 'package:work_assignment/staff/staff.dart';

class AccountContainer extends StatelessWidget {
  const AccountContainer({Key? key, required this.staff}) : super(key: key);

  final Staff staff;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Expanded(child: ContentRow('Tên:', staff.name)),
          Expanded(child: ContentRow('Gmail:', staff.gmail)),
          Expanded(child: ContentRow('Địa chỉ:', staff.address)),
          Expanded(child: ContentRow('Vị trí:', staff.position)),
          Expanded(child: ContentRow('Năm sinh:', staff.birthYear.toString())),
          Expanded(child: ContentRow('Giới tính:', staff.gender ?? 'chưa rõ')),
          const Expanded(flex: 2, child: SizedBox()),
        ],
      ),
    );
  }
}

class ContentRow extends StatelessWidget {
  const ContentRow(this.label, this.value, {Key? key}) : super(key: key);
  final String label;
  final String value;
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
          child: Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
