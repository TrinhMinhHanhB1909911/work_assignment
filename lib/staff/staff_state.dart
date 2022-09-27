part of 'staff_cubit.dart';

@immutable
abstract class StaffState {}

class StaffInitial extends StaffState {}

class StaffsLoaded extends StaffState {
  final List<Staff> staffs;
  StaffsLoaded(this.staffs);
}

class StaffsLoading extends StaffState {}

class StaffDetail extends StaffState {
  final Staff staff;
  StaffDetail(this.staff);
}
