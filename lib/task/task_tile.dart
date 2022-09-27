import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/task.dart';
import 'task_cubit.dart';
import 'task_detail_screen.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({Key? key, required this.task}) : super(key: key);
  final Task task;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(8)),
        // color: Colors.red,
        child: const Icon(Icons.delete),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        BlocProvider.of<TaskCubit>(context).removeTask(task);
      },
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('Xác nhận xóa'),
              content: const Text('Bạn chắc chắn muốn xóa?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
      },
      key: ValueKey(task.id),
      child: Card(
        elevation: 2,
        child: ListTile(
          onTap: () => context.read<TaskCubit>().taskDetail(task),
          title: Text(task.title),
          subtitle: Text(
            task.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(task.state),
        ),
      ),
    );
  }
}
