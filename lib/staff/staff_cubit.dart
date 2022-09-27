import 'package:flutter/material.dart';
import 'package:work_assignment/models/staff.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'staff_service.dart';
part 'staff_state.dart';

class StaffCubit extends Cubit<StaffState> {
  StaffCubit(this.service) : super(StaffInitial());
  final StaffService service;
  List<Staff>? staffs;

  void allStaffs() async {
    if (staffs != null) {
      emit(StaffsLoaded(staffs!));
    } else {
      emit(StaffsLoading());
      staffs = await service.getAllStaffs();
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
}
