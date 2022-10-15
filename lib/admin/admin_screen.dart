import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/clients/login_screen.dart';
import 'package:work_assignment/clients/sign_cubit.dart';
import 'package:work_assignment/clients/sign_state.dart';

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

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignCubit, SignState>(
      listener: (context, state) {
        if (state is LogOut) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const SignInScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}
