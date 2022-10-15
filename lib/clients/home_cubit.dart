import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_assignment/clients/home_state.dart';
import 'package:work_assignment/staff/staff.dart';
import 'package:work_assignment/staff/staff_service.dart';
import 'package:work_assignment/task/task_service.dart';

import '../task/task.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.taskService, this.staffService) : super(HomeInitial());
  final TaskService taskService;
  final StaffService staffService;
  int navIndex = 0;
  List<Task>? tasks;
  Staff? staff;

  void changeIndex(int index) {
    navIndex = index;
    if (navIndex == 0) {
      getAllTasks();
      return;
    }
    if (navIndex == 1) {
      accountTab();
    }
  }

  Future<void> getAllTasks() async {
    if (tasks != null) {
      emit(HomeLoaded(tasks!));
      return;
    }
    emit(HomeLoading());
    final spref = await SharedPreferences.getInstance();
    final gmail = spref.getString('gmail');
    final tasksData = await taskService.getAllTasks();
    tasks = <Task>[];
    for (var task in tasksData) {
      for (var staff in task.staffs) {
        if (staff.gmail == gmail) {
          tasks!.add(task);
        }
      }
    }
    emit(HomeLoaded(tasks!));
  }

  void taskDetail(Task task) {
    emit(HomeTaskDetail(task));
    emit(HomeLoaded(tasks!));
  }

  Future<void> refresh() async {
    tasks = null;
    await getAllTasks();
  }

  void accountTab() async {
    if (staff != null) {
      emit(HomeAccount(staff!));
      return;
    }
    emit(HomeLoading());
    final spref = await SharedPreferences.getInstance();
    final gmail = spref.getString('gmail');
    staff = await staffService.getOneStaffByEmail(gmail!);
    emit(HomeAccount(staff!));
  }

  void dispose() {
    tasks = null;
    staff = null;
    emit(HomeInitial());
  }
}
