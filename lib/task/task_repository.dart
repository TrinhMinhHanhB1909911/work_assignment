import 'package:cloud_firestore/cloud_firestore.dart';


import '../shared/repository_interface.dart';
import 'task.dart';

class TaskRepository implements Repository<Task> {
  final collection = FirebaseFirestore.instance.collection('tasks');

  @override
  Future<Task> create(Task item) async {
    await collection.add(item.toJson());
    return item;
  }

  @override
  Future<bool> delete(String id) async {
    await collection.doc(id).delete().catchError((_) => false);
    return true;
  }

  @override
  Future<QueryDocumentSnapshot> getQueryDocumentSnapshot(Task item) async {
    final docSnapshot = await collection.where('id', isEqualTo: item.id).limit(1).get();
    return docSnapshot.docs.first;
  }

  @override
  Future<Task> getOne(String id) async {
    final data = await collection.doc(id).get();
    return Task.fromJson(data.data()!);
  }

  @override
  Future<List<Task>> list() async {
    final docs = await collection.orderBy('id').get();
    return docs.docs.map((doc) => Task.fromJson(doc.data())).toList();
  }

  @override
  Future<bool> update(String id, Task item) async {
    await collection.doc(id).update(item.toJson()).catchError((_) => false);
    return true;
  }
}
