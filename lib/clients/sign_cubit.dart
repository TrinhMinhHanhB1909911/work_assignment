import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_assignment/clients/home_cubit.dart';
import 'package:work_assignment/clients/home_state.dart';
import 'package:work_assignment/staff/staff_cubit.dart';
import 'package:work_assignment/staff/staff_service.dart';
import 'package:work_assignment/task/task_cubit.dart';
import '../staff/staff.dart';
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

  void signIn(String email, String password) async {
    final spref = await SharedPreferences.getInstance();
    if (email == 'admin@gmail.com' && password == 'admin') {
      await spref.setString('gmail', email);
      emit(AdminSignIned());
      return;
    }
    Staff staff = await service.getOneStaffByEmail(email);
    if (staff.gmail == email && staff.password == password) {
      await spref.setString('gmail', staff.gmail);
      emit(SignIned());
      homeCubit.emit(HomeInitial());
    }
  }

  Future<void> logOut() async {
    taskCubit.dispose();
    staffCubit.dispose();
    homeCubit.dispose();
    final spref = await SharedPreferences.getInstance();
    await spref.remove('gmail');
    emit(LogOut());
  }
}
