
import 'staff.dart';
import 'staff_repository.dart';



class StaffService {
  final staffRepo = StaffRepository();
  Future<List<Staff>> getAllStaffs() async {
    return await staffRepo.list();
  }

  Future<Staff> getOneStaff(String name) async {
    final staffs = await staffRepo.list();
    return staffs.firstWhere((staff) => staff.name == name);
  }

  Future<Staff> getOneStaffByEmail(String email) async {
    final staffs = await staffRepo.list();
    return staffs.firstWhere((staff) => staff.gmail == email);
  }

  Future<Staff> addStaff(Staff item) async {
    return await staffRepo.create(item);
  }

  Future<bool> removeStaff(Staff item) async {
    final queryDocSnap = await staffRepo.getQueryDocumentSnapshot(item);
    return await staffRepo.delete(queryDocSnap.id);
  }

  Future<bool> updateStaff(Staff item) async {
    final queryDocSnap = await staffRepo.getQueryDocumentSnapshot(item);
    return await staffRepo.update(queryDocSnap.id, item);
  }
}