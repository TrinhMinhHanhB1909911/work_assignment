import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/views/screens/login_screen.dart';
import 'package:work_assignment/cubits/sign/sign_cubit.dart';
import 'package:work_assignment/cubits/sign/sign_state.dart';
import 'package:work_assignment/views/widgets/log_out_button.dart';
import 'package:work_assignment/views/screens/task/task_detail_screen.dart';

import '../../models/task.dart';
import '../widgets/account_container.dart';
import '../../cubits/home/home_cubit.dart';
import '../../cubits/home/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
        backgroundColor: Colors.blue.shade100,
        appBar: AppBar(
          title: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              int index = context.read<HomeCubit>().navIndex;
              if (index == 0) {
                return const Text('Lịch công tác');
              }
              if (index == 1) {
                return const Text('Tài khoản');
              }
              return const Text('Home');
            },
          ),
          elevation: 0,
          actions: const [LogOutButton()],
        ),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeTaskDetail) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      TaskDetailScreen(task: state.task, editable: false),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is HomeInitial) {
              context.read<HomeCubit>().getAllTasks();
            }
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HomeLoaded) {
              if (state.tasks.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => context.read<HomeCubit>().refresh(),
                  child: ListView(
                    children: [
                      const SizedBox(height: 300),
                      Icon(
                        Icons.not_interested_rounded,
                        color: Colors.red.shade300,
                      ),
                      Text(
                        'Bạn chưa có lịch công tác',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red.shade300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().refresh(),
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) {
                    Task task = state.tasks[index];
                    return Card(
                      child: ListTile(
                        onTap: () => context.read<HomeCubit>().taskDetail(task),
                        title: Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          task.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(task.state),
                      ),
                    );
                  },
                ),
              );
            }
            if (state is HomeAccount) {
              return AccountContainer(staff: state.staff);
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return BottomNavigationBar(
              onTap: (index) => context.read<HomeCubit>().changeIndex(index),
              currentIndex: context.read<HomeCubit>().navIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.task),
                  label: 'Lịch',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Tài khoản',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
