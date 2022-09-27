import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

import '../staff/staff.dart';
import '../staff/staff_service.dart';

class StaffsSelect extends StatefulWidget {
  const StaffsSelect({Key? key}) : super(key: key);

  @override
  State<StaffsSelect> createState() => _StaffsSelectState();
}

class _StaffsSelectState extends State<StaffsSelect> {
  List<Staff> options = [];
  List<Staff> selected = [];

  Future<void> fetchOptions() async {
    options = (await StaffService().getAllStaffs()).cast<Staff>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchOptions(),
      builder: (context, snapshot) => DropDownMultiSelect(
        decoration: const InputDecoration(
          labelText: 'Nhân viên công tác',
          border: OutlineInputBorder(),
        ),
        options: options.map((staff) => staff.name).toList(),
        selectedValues: selected.map((staff) => staff.name).toList(),
        onChanged: (values) {
          setState(() {
            selected.clear();
            selected =
                options.where((staff) => values.contains(staff.name)).toList();
          });
        },
      ),
    );
  }
}
