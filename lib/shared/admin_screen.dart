import 'package:flutter/material.dart';

import '../staff/staffs_page.dart';
import '../task/task_service.dart';
import '../task/tasks_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TaskService service = TaskService();

  int taskCount = 5;
  int staffCount = 10;

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentIndex == 0 ? const ListTaskPage() : const StaffsPage(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task_rounded),
            label: 'Lịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Nhân viên',
          ),
        ],
      ),
    );
  }
}
