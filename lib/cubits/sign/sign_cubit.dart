import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_assignment/cubits/home/home_cubit.dart';
import 'package:work_assignment/cubits/home/home_state.dart';
import 'package:work_assignment/cubits/staff/staff_cubit.dart';
import 'package:work_assignment/services/staff_service.dart';
import 'package:work_assignment/cubits/task/task_cubit.dart';
import '../../models/staff.dart';
import 'sign_state.dart';

class SignCubit extends Cubit<SignState> {
  SignCubit({
    required this.service,
    required this.homeCubit,
    required this.staffCubit,
    required this.taskCubit,
  }) : super(SignInitial());
  final StaffService service;
  final TaskCubit taskCubit;
  final StaffCubit staffCubit;
  final HomeCubit homeCubit;

  Future<bool> signIn(String email, String password) async {
    final spref = await SharedPreferences.getInstance();
    if (email == 'admin@gmail.com' && password == 'admin') {
      await spref.setString('gmail', email);
      emit(AdminSignIned());
      return true;
    }
    Staff? staff;
    try {
      staff = await service.getOneStaffByEmail(email);
    } catch (error) {
      return false;
    }
    password = md5.convert(utf8.encode(password)).toString();
    if (staff.gmail == email && staff.password == password) {
      await spref.setString('gmail', staff.gmail);
      emit(SignIned());
      homeCubit.emit(HomeInitial());
      return true;
    }
    return false;
  }

  Future<void> logOut() async {
    taskCubit.dispose();
    staffCubit.dispose();
    homeCubit.dispose();
    final spref = await SharedPreferences.getInstance();
    await spref.remove('gmail');
    emit(LogOut());
    emit(SignInitial());
  }
}
