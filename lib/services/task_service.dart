
import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskService {
  final taskRepo = TaskRepository();
  Future<List<Task>> getAllTasks() async {
    return await taskRepo.list();
  }

  Future<Task> getOneTask(String title) async {
    final tasks = await taskRepo.list();
    return tasks.firstWhere((task) => task.title == title);
  }

  Future<Task> addTask(Task item) async {
    return await taskRepo.create(item);
  }

  Future<bool> removeTask(Task item) async {
    final queryDocSnap = await taskRepo.getQueryDocumentSnapshot(item);
    return await taskRepo.delete(queryDocSnap.id);
  }

  Future<bool> updateTask(Task item) async {
    final queryDocSnap = await taskRepo.getQueryDocumentSnapshot(item);
    return await taskRepo.update(queryDocSnap.id, item);
  }

  // List<Task> 
}
