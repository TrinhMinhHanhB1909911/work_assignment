import 'package:cloud_firestore/cloud_firestore.dart';

import 'repository_interface.dart';
import '../models/task.dart';

class TaskRepository implements Repository<Task> {
  final collection = FirebaseFirestore.instance.collection('tasks');

  @override
  Future<Task> create(Task item) async {
    final json = item.toJson();
    json['staffs'].forEach((map) {
      map.remove('password');
    });
    await collection.add(json);
    return item;
  }

  @override
  Future<bool> delete(String id) async {
    await collection.doc(id).delete().catchError((_) => false);
    return true;
  }

  @override
  Future<QueryDocumentSnapshot> getQueryDocumentSnapshot(Task item) async {
    final docSnapshot =
        await collection.where('id', isEqualTo: item.id).limit(1).get();
    return docSnapshot.docs.first;
  }

  @override
  Future<Task> getOne(String id) async {
    final data = await collection.doc(id).get();
    return Task.fromJson(data.data()!);
  }

  @override
  Future<List<Task>> list() async {
    final docs = await collection.orderBy('state').get();
    return docs.docs.map((doc) => Task.fromJson(doc.data())).toList();
  }

  @override
  Future<bool> update(String id, Task item) async {
    final json = item.toJson();
    json['staffs'].forEach((map) {
      map.remove('password');
    });
    await collection.doc(id).update(json).catchError((_) => false);
    return true;
  }
}
