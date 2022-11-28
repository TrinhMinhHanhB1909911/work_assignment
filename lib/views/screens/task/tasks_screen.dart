import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/views/widgets/log_out_button.dart';
import 'package:work_assignment/views/screens/task/task_detail_screen.dart';
import 'package:work_assignment/views/widgets/searching.dart';

import 'task_addition_screen.dart';
import '../../../cubits/task/task_cubit.dart';
import '../../widgets/task_tile.dart';

class ListTaskPage extends StatelessWidget {
  const ListTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<TaskCubit>();
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Lịch công tác'),
        actions: [
          IconButton(
            onPressed: () async {
              final tasks = homeCubit.tasks ?? [];
              showSearch(
                context: context,
                delegate:
                    SearchScreen(tasks),
              );
            },
            icon: const Icon(Icons.search),
          ),
          const LogOutButton(),
        ],
      ),
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TaskInitial) {
            context.read<TaskCubit>().allTask();
          }
          if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.not_interested_rounded,
                      color: Colors.red.shade300,
                    ),
                    Text(
                      'Chưa có lịch công tác',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.red.shade300,
                      ),
                    ),
                  ],
                ),
              );
            }
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
                builder: (_) => TaskDetailScreen(
                  task: state.task,
                  editable: true,
                ),
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
            // context.read<TaskCubit>().allTask();
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
