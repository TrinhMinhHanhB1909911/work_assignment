import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Repository<T> {
  Future<QueryDocumentSnapshot> getQueryDocumentSnapshot(T item);
  Future<T> create(T item);
  Future<List<T>> list();
  Future<T> getOne(String id);
  Future<bool> update(String id, T item);
  Future<bool> delete(String id);
}
