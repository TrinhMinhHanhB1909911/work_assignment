// import 'staff.dart';
// import 'task.dart';

// class TaskDetail {
//   int id;
//   Task task;
//   List<Staff> staffs;
//   TaskDetail({
//     required this.id,
//     required this.task,
//     required this.staffs,
//   });

//   TaskDetail copyWith({
//     int? id,
//     Task? task,
//     List<Staff>? staffs,
//   }) {
//     return TaskDetail(
//       id: id ?? this.id,
//       task: task ?? this.task,
//       staffs: staffs ?? this.staffs,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'task': task.toJson(),
//       'staffs': staffs.map((staff) => staff.toJson()).toList(),
//     };
//   }

//   factory TaskDetail.fromJson(Map<String, dynamic> json) {
//     return TaskDetail(
//       id: json['id']?.toInt(),
//       task: Task.fromJson(json['task']),
//       staffs: List<Staff>.from(
//           json['staffs']?.map((staff) => Staff.fromJson(staff))),
//     );
//   }

//   String staffsToString() {
//     String names = '';
//     for (var staff in staffs) {
//       names += staff.name;
//     }
//     return names;
//   }
// }
