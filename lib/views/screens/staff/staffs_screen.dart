import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_assignment/views/widgets/log_out_button.dart';

import '../../widgets/search_staff_screen.dart';
import 'staff_addition_screen.dart';
import '../../../cubits/staff/staff_cubit.dart';
import 'staff_detail_screen.dart';
import '../../widgets/staff_tile.dart';

class StaffsPage extends StatelessWidget {
  const StaffsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final staffCubit = context.read<StaffCubit>();
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Nhân viên'),
        actions: [
          IconButton(
            onPressed: () {
              final staffs = staffCubit.staffs ?? [];
              showSearch(
                context: context,
                delegate: SearchStaffScreen(staffs),
              );
            },
            icon: const Icon(Icons.search),
          ),
          const LogOutButton(),
        ],
      ),
      body: BlocConsumer<StaffCubit, StaffState>(
        listener: (context, state) {
          if (state is StaffDetail) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => StaffDetailScreen(state.staff)),
            );
            context.read<StaffCubit>().allStaffs();
          }
        },
        builder: (context, state) {
          if (state is StaffsLoaded) {
            if (state.staffs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.not_interested_rounded,
                      color: Colors.red.shade300,
                    ),
                    Text(
                      'Chưa có nhân viên',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.red.shade300,
                      ),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: context.read<StaffCubit>().refresh,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                itemCount: state.staffs.length,
                itemBuilder: (context, index) {
                  final staff = state.staffs[index];
                  return StaffTile(staff);
                },
              ),
            );
          }
          if (state is StaffInitial) {
            context.read<StaffCubit>().allStaffs();
          }
          if (state is StaffsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddStaffScreen()),
          );
          //context.read<StaffCubit>().allStaffs();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
