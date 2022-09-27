import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/staff/staff_cubit.dart';
import 'package:work_assignment/staff/staff_service.dart';
import 'package:work_assignment/task/task_cubit.dart';
import 'package:work_assignment/task/task_service.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'shared/admin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const WorkAsignmentApp());
}

class WorkAsignmentApp extends StatefulWidget {
  const WorkAsignmentApp({Key? key}) : super(key: key);

  @override
  State<WorkAsignmentApp> createState() => _WorkAsignmentAppState();
}

class _WorkAsignmentAppState extends State<WorkAsignmentApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskCubit(TaskService()),
        ),
        BlocProvider(
          create: (context) => StaffCubit(StaffService()),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AdminPage(title: 'Quản lý lịch công tác'),
      ),
    );
  }
}
