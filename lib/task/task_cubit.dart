import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/staff/staff_cubit.dart';

import 'task.dart';
import 'task_service.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit(this.service, this.staffCubit) : super(TaskInitial());
  StaffCubit staffCubit;
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

  void taskDetail(Task task) {
    final taskDetail = tasks?.firstWhere((taskTile) => taskTile == task);
    emit(TaskDetail(taskDetail!));
  }

  void taskAddition() {
    emit(TaskAddition());
    emit(TaskLoaded(tasks!));
  }

  void addTask(Task task) async {
    await service.addTask(task);
    tasks?.add(task);
    emit(TaskLoaded(tasks!));
  }

  Future<void> updateTask(Task task) async {
    await service.updateTask(task);
    tasks?.removeWhere((element) => element.id == task.id);
    tasks?.add(task);
    emit(TaskLoaded(tasks!));
  }

  Future<void> refresh() async {
    dispose();
    await allTask();
  }

  void removeTask(Task task) async {
    await service.removeTask(task);
    tasks?.remove(task);
    emit(TaskLoaded(tasks!));
  }

  void dispose() {
    tasks = null;
    emit(TaskInitial());
  }
}
