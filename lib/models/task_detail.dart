// import 'package:cloud_firestore/cloud_firestore.dart';

// class TaskDetail {
//   int id;
//   DocumentReference task;
//   List<DocumentReference> staffs;
//   TaskDetail({
//     required this.id,
//     required this.task,
//     required this.staffs,
//   });

//   TaskDetail copyWith({
//     int? id,
//     DocumentReference? task,
//     List<DocumentReference>? staffs,
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
//       'task': task,
//       'staffs': staffs,
//     };
//   }

//   factory TaskDetail.fromJson(Map<String, dynamic> json) {
//     return TaskDetail(
//       id: json['id'],
//       task: json['task'] as DocumentReference,
//       staffs: (json['staffs'] as List<dynamic>).map((staff) => staff as DocumentReference).toList(),
//     );
//   }
// }
