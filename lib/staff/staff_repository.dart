import 'package:cloud_firestore/cloud_firestore.dart';

import '../shared/repository_interface.dart';
import 'staff.dart';

class StaffRepository implements Repository<Staff> {
  final collection = FirebaseFirestore.instance.collection('staff');

  @override
  Future<Staff> create(Staff item) async {
    final snapshot = await collection.orderBy('id').limitToLast(1).get();
    item.id = (snapshot.docs.first.data()['id'] as int) + 1;
    await collection.add(item.toJson());
    return item;
  }

  @override
  Future<bool> delete(String id) async {
    await collection.doc(id).delete().catchError((_) => false);
    return true;
  }

  @override
  Future<Staff> getOne(String id) async {
    final data = await collection.doc(id).get();
    return Staff.fromJson(data.data()!);
  }

  @override
  Future<QueryDocumentSnapshot<Object?>> getQueryDocumentSnapshot(
      Staff item) async {
    final docSnapshot =
        await collection.where('id', isEqualTo: item.id).limit(1).get();
    return docSnapshot.docs.first;
  }

  @override
  Future<List<Staff>> list() async {
    final docs = await collection.get();
    return docs.docs.map((doc) => Staff.fromJson(doc.data())).toList();
  }

  @override
  Future<bool> update(String id, Staff item) async {
    await collection.doc(id).update(item.toJson()).catchError((_) => false);
    return true;
  }
}
