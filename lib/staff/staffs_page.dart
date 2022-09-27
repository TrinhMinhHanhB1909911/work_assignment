import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_staff_screen.dart';
import 'staff_cubit.dart';
import 'staff_detail_screen.dart';

class StaffsPage extends StatelessWidget {
  const StaffsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Nhân viên'),
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
            return RefreshIndicator(
              onRefresh: context.read<StaffCubit>().refresh,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                itemCount: state.staffs.length,
                itemBuilder: (context, index) {
                  final staff = state.staffs[index];
                  return Card(
                    child: ListTile(
                      onTap: () =>
                          context.read<StaffCubit>().staffDetail(staff),
                      title: Text(staff.name),
                      subtitle: Text(staff.gmail),
                    ),
                  );
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
          context.read<StaffCubit>().allStaffs();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
