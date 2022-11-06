import 'package:flutter/material.dart';
import 'package:work_assignment/admin/new_password_page.dart';

import 'staff.dart';

class StaffDetailScreen extends StatelessWidget {
  const StaffDetailScreen(this.staff, {Key? key}) : super(key: key);
  final Staff staff;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(staff.name),
        elevation: 0,
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
            const Expanded(
              flex: 3,
              child: SizedBox(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewPasswordScreen(staff),
                    ),
                  );
                },
                child: const Text('Cấp mật khẩu mới'),
              ),
            ),
            const SizedBox(height: 16.0),
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
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: textStyle),
          ),
          Expanded(
            flex: 2,
            child: Text(value, style: textStyle),
          ),
        ],
      ),
    );
  }
}
