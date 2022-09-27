import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/staff.dart';



class Task {
  int id;
  String title;
  String description;
  DateTime begin;
  DateTime end;
  String? state;
  List<Staff>? staffs;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.begin,
    required this.end,
    this.state,
    required this.staffs,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? begin,
    DateTime? end,
    String? state,
    List<Staff>? staffs,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      state: state ?? this.state,
      staffs: staffs ?? this.staffs,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      begin: (json['begin'] as Timestamp).toDate(),
      end: (json['end'] as Timestamp).toDate(),
      state: json['state'],
      staffs: (json['staffs'] as List?)?.map((staff) => Staff.fromJson(staff)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'begin': Timestamp.fromDate(begin),
      'end': Timestamp.fromDate(end),
      'state': state,
      'staffs': staffs?.map((staff) => staff.toJson()).toList(),
    };
  }
}
