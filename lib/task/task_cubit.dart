import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/models/task_detail_full.dart';

import '../models/task.dart';
import 'task_service.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit(this.service) : super(TaskInitial());
  TaskService service;
  List<Task>? tasks;

  Future<void> allTask() async {
    if (tasks != null) {
      emit(TaskLoaded(tasks!));
      return;
    }
    emit(TaskLoading());
    tasks = await service.getAllTasks();
    emit(TaskLoaded(tasks!));
  }

  // Future<void> allTaskDetails() async {
  //   if (taskDetails != null) {
  //     emit(TaskDetailsLoaded(taskDetails!));
  //     return;
  //   }
  //   emit(TaskLoading());
  //   taskDetails = await taskDetailService.getAllTaskDetails();
  //   print(taskDetails?.first.task.toJson());
  //   emit(TaskDetailsLoaded(taskDetails!));
  // }

  void taskDetail(Task task) {
    final taskDetail = tasks?.firstWhere((taskTile) => taskTile == task);
    emit(TaskDetail(taskDetail!));
  }

  void taskAddition() {
    emit(TaskAddition());
  }

  void addTask(Task task) async {
    await service.addTask(task);
  }

  void updateTask(Task task) async {
    await service.updateTask(task);
  }

  Future<void> refresh() async {
    tasks = null;
    await allTask();
  }

  void removeTask(Task task) async {
    await service.removeTask(task);
    tasks?.remove(task);
  }
}
