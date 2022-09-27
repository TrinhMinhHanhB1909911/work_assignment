import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/task/task_detail_screen.dart';

import 'add_task_screen.dart';
import 'task_cubit.dart';
import 'task_tile.dart';

class ListTaskPage extends StatelessWidget {
  const ListTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Lịch công tác'),
      ),
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TaskInitial) {
            context.read<TaskCubit>().allTask();
          }
          if (state is TaskLoaded) {
            return RefreshIndicator(
              onRefresh: context.read<TaskCubit>().refresh,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return TaskTile(task: task);
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: BlocListener<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskDetail) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TaskDetailScreen(task: state.task),
              ),
            );
            context.read<TaskCubit>().allTask();
          }
          if (state is TaskAddition) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AddTaskPage(),
              ),
            );
            context.read<TaskCubit>().allTask();
          }
        },
        child: FloatingActionButton(
          onPressed: () {
            context.read<TaskCubit>().taskAddition();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
