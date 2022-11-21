import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multiselect/multiselect.dart';
import 'package:work_assignment/cubits/task/task_cubit.dart';

import '../../../models/staff.dart';
import '../../../services/staff_service.dart';
import '../../../models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);
  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late GlobalKey<FormState> _key;
  late TextEditingController beginController;
  late TextEditingController endController;
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  late DateTime? begin;
  late DateTime? end;

  List<Staff> options = [];
  List<Staff> selected = [];

  @override
  void initState() {
    super.initState();
    _key = GlobalKey<FormState>();
    beginController = TextEditingController();
    endController = TextEditingController();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _key.currentState?.dispose();
    beginController.dispose();
    endController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> fetchOptions() async {
    options = await StaffService().getAllStaffs();
  }

  @override
  Widget build(BuildContext context) {
    final focusScope = FocusScope.of(context);
    TaskCubit taskCubit = BlocProvider.of(context);
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Thêm lịch công tác'),
      ),
      body: Center(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Thêm lịch',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    validator: validate,
                    controller: titleController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelText: 'Tiêu đề',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: validate,
                    keyboardType: TextInputType.text,
                    minLines: 3,
                    maxLines: 3,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelText: 'Mô tả',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: validate,
                    readOnly: true,
                    controller: beginController,
                    decoration: InputDecoration(
                      labelText: 'Ngày bắt đầu: ',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: InkWell(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050),
                          );
                          TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          final finalDate = DateTime(date!.year, date.month,
                              date.day, time!.hour, time.minute);

                          beginController.text = DateFormat('dd-MM-yyyy  -- ')
                              .add_jms()
                              .format(finalDate);
                          begin = finalDate;
                        },
                        child: const Icon(Icons.date_range_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    validator: validate,
                    readOnly: true,
                    controller: endController,
                    decoration: InputDecoration(
                      labelText: 'Ngày kết thúc: ',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: InkWell(
                        onTap: () async {
                          focusScope.unfocus();
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050),
                          );
                          focusScope.unfocus();
                          TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          focusScope.unfocus();
                          final finalDate = DateTime(date!.year, date.month,
                              date.day, time!.hour, time.minute);

                          endController.text = DateFormat('dd-MM-yyyy  -- ')
                              .add_jms()
                              .format(finalDate);
                          end = finalDate;
                        },
                        child: const Icon(Icons.date_range_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder(
                    future: fetchOptions(),
                    builder: (context, snapshot) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: DropDownMultiSelect(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Nhân viên công tác',
                          // filled: true,
                          // fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        options: options.map((staff) => staff.name).toList(),
                        selectedValues: [
                          ...selected.map((staff) => staff.name).toList()
                        ],
                        onChanged: (values) {
                          setState(() {
                            selected.clear();
                            selected = options
                                .where((staff) => values.contains(staff.name))
                                .toList();
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        focusScope.unfocus();
                        bool isValid = _key.currentState?.validate() ?? false;
                        if (!isValid) {
                          return;
                        }
                        bool checkDate = end!.isAfter(begin!);
                        isValid = isValid && checkDate;
                        if (!isValid) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'Ngày kết thúc phải sau ngày bắt đầu'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Ok'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }
                        final last = await FirebaseFirestore.instance
                            .collection('tasks')
                            .orderBy('id')
                            .limitToLast(1)
                            .get()
                            .catchError((_) {});
                        final task = Task(
                          id: (last.docs.isNotEmpty
                                  ? last.docs.last['id']
                                  : 0) +
                              1,
                          title: titleController.text,
                          description: descriptionController.text,
                          state: 'Chưa bắt đầu',
                          begin: begin!,
                          end: end!,
                          staffs: selected,
                        );
                        taskCubit.addTask(task);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Trạng thái'),
                              content: const Text('Thêm thành công!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    BlocProvider.of<TaskCubit>(context)
                                        .tasks
                                        ?.add(task);
                                    BlocProvider.of<TaskCubit>(context)
                                        .allTask();
                                  },
                                  child: const Text('ok'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Không được bỏ trống';
    }
    return null;
  }
}
