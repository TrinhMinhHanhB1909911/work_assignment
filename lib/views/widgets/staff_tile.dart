import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/cubits/staff/staff_cubit.dart';

import '../../cubits/task/task_cubit.dart';
import '../../models/staff.dart';

class StaffTile extends StatelessWidget {
  const StaffTile(this.staff, {Key? key}) : super(key: key);
  final Staff staff;
  @override
  Widget build(BuildContext context) {
    final staffCubit = BlocProvider.of<StaffCubit>(context);
    final taskCubit = BlocProvider.of<TaskCubit>(context);
    return Dismissible(
      key: ValueKey(staff.name),
      confirmDismiss: (_) async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Xác nhận xóa'),
              content: const Text('Bạn có chắc muốn xóa?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        await staffCubit.remove(context, staff);
        taskCubit.refresh();
      },
      background: Container(
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Card(
        child: ListTile(
          onTap: () => staffCubit.staffDetail(staff),
          title: Text(staff.name),
          subtitle: Text(staff.gmail),
        ),
      ),
    );
  }
}
