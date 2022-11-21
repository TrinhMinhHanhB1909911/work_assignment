import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/cubits/staff/staff_cubit.dart';

import '../../models/task.dart';
import '../../services/task_service.dart';

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
    task = handleTaskBeforeAdd(task);
    final newTask = await service.addTask(task);
    tasks ??= await service.getAllTasks();
    tasks!.add(newTask);
    emit(TaskLoaded(tasks!));
  }

  Task handleTaskBeforeAdd(Task task) {
    return task.copyWith(
      title: task.title[0].toUpperCase() + task.title.substring(1),
      description:
          task.description[0].toUpperCase() + task.description.substring(1),
      state: task.state[0].toUpperCase() + task.state.substring(1),
    );
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
