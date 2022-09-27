import 'package:flutter/material.dart';

import '../../models/staff.dart';

class StaffDetailScreen extends StatelessWidget {
  const StaffDetailScreen(this.staff, {Key? key}) : super(key: key);
  final Staff staff;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(staff.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StaffField('Tên: ', staff.name),
            StaffField('Gmail: ', staff.gmail),
            StaffField('Vị trí: ', staff.position),
            StaffField('Địa chỉ: ', staff.address),
          ],
        ),
      ),
    );
  }
}

class StaffField extends StatelessWidget {
  const StaffField(this.label, this.value, {Key? key}) : super(key: key);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    var textStyle = const TextStyle(fontSize: 18);
    return Row(
      children: [
        Expanded(
          child: Text(label, style: textStyle),
        ),
        Expanded(
          flex: 2,
          child: Text(value, style: textStyle),
        ),
      ],
    );
  }
}
