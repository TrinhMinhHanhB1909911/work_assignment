part of 'task_cubit.dart';

@immutable
abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  TaskLoaded(this.tasks);
}

class TaskAddition extends TaskState {}

class TaskDetail extends TaskState {
  final Task task;
  TaskDetail(this.task);
}

class TaskLoading extends TaskState {}
