import 'package:work_assignment/models/staff.dart';

import '../../models/task.dart';

abstract class HomeState {
  int navIndex;
  HomeState({this.navIndex = 0});
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Task> tasks;
  HomeLoaded(this.tasks);
}

class HomeTaskDetail extends HomeState {
  final Task task;
  HomeTaskDetail(this.task);
}

class HomeAccount extends HomeState {
  final Staff staff;
  HomeAccount(this.staff);
}


