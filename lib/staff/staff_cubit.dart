import 'package:flutter/material.dart';
import 'package:work_assignment/task/task_service.dart';
import './staff.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'staff_service.dart';
part 'staff_state.dart';

class StaffCubit extends Cubit<StaffState> {
  StaffCubit(this.staffService, this.taskService) : super(StaffInitial());
  final StaffService staffService;
  final TaskService taskService;
  List<Staff>? staffs;

  void allStaffs() async {
    if (staffs != null) {
      emit(StaffsLoaded(staffs!));
    } else {
      emit(StaffsLoading());
      staffs = await staffService.getAllStaffs();
      emit(StaffsLoaded(staffs!));
    }
  }

  void staffDetail(Staff staff) {
    emit(StaffDetail(staff));
  }

  Future<void> refresh() async {
    staffs = null;
    allStaffs();
  }

  Future<void> remove(BuildContext context, Staff staff) async {
    await staffService.removeStaff(staff);
    staffs?.removeWhere((e) => e.id == staff.id);
    final tasks = await taskService.getAllTasks();
    final tasksNeedUpdate = tasks.where((task) {
      for (var element in task.staffs) {
        if (element.id == staff.id) {
          return true;
        }
      }
      return false;
    }).toList();
    for (var task in tasksNeedUpdate) {
      task.staffs.removeWhere((element) => element.id == staff.id);
      await taskService.updateTask(task);
    }
    // emit(StaffsLoaded(staffs!));
  }

  Future<void> addStaff(Staff staff) async {
    staff = handleStaffBeforeAdd(staff);
    await staffService.addStaff(staff);
    staffs?.add(staff);
    emit(StaffsLoaded(staffs!));
  }

  Staff handleStaffBeforeAdd(Staff staff) {
    return staff.copyWith(
      name: handleString(staff.name),
      address: handleString(staff.address),
      position: staff.position[0].toUpperCase() + staff.position.substring(1),
    );
  }

  String handleString(String value) {
    StringBuffer result = StringBuffer();
    for (int i = 0; i < value.length; i++) {
      if (i == 0) {
        result.write(value[0].toUpperCase());
        continue;
      }
      if (value[i - 1] == ' ') {
        result.write(value[i].toUpperCase());
        continue;
      }
      result.write(value[i]);
    }
    return result.toString();
  }

  void dispose() {
    staffs = null;
    emit(StaffInitial());
  }
}
