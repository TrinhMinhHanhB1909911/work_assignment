import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multiselect/multiselect.dart';

import '../../../models/staff.dart';
import '../../../services/staff_service.dart';
import '../../../models/task.dart';
import '../../../cubits/task/task_cubit.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({
    Key? key,
    required this.task,
    required this.editable,
  }) : super(key: key);
  final Task task;
  final bool editable;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Map<String, String> origin;
  bool editing = false;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController stateController;
  late TextEditingController beginController;
  late TextEditingController endController;
  late TextEditingController staffController;
  String staffsName = '';

  DateTime? begin, end;

  var options = <Staff>[];
  late List<Staff> selected;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(
      text: widget.task.description,
    );
    stateController = TextEditingController(text: widget.task.state);
    beginController = TextEditingController(
      text: DateFormat('dd-MM-yyyy -- hh:mm').format(widget.task.begin),
    );
    endController = TextEditingController(
      text: DateFormat('dd-MM-yyyy -- hh:mm').format(widget.task.begin),
    );
    staffController = TextEditingController();
    for (int i = 0; i < widget.task.staffs.length; i++) {
      if (i == widget.task.staffs.length - 1) {
        staffController.text += widget.task.staffs[i].name;
        staffsName += widget.task.staffs[i].name;
      } else {
        staffController.text += '${widget.task.staffs[i].name}, ';
        staffsName += '${widget.task.staffs[i].name}, ';
      }
    }
    selected = widget.task.staffs;
    origin = {
      'title': widget.task.title,
      'description': widget.task.description,
      'state': widget.task.state,
      'begin': DateFormat('dd-MM-yyyy -- hh:mm').format(widget.task.begin),
      'end': DateFormat('dd-MM-yyyy -- hh:mm').format(widget.task.end),
      'staffsName': staffsName,
    };
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    stateController.dispose();
    beginController.dispose();
    endController.dispose();
    staffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskCubit = BlocProvider.of<TaskCubit>(context);
    final focusScope = FocusScope.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.task.title),
        actions: [
          Visibility(
            visible: widget.editable,
            child: IconButton(
              onPressed: () async {
                focusScope.unfocus();
                if (editing) {
                  bool confirm = await showDialog(
                    context: context,
                    builder: (context) {
                      if ((begin ?? widget.task.begin)
                          .isAfter((end ?? widget.task.end))) {
                        return AlertDialog(
                          title: const Text('L???i'),
                          content: const Text(
                              'Ng??y k???t th??c ph???i sau ng??y b???t ?????u!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                                editing = !editing;
                                return;
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        );
                      }
                      return AlertDialog(
                        title: const Text('X??c nh???n'),
                        content: const Text('B???n c?? ch???c mu???n l??u thay ?????i'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('No'),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirm) {
                    Task newTask = widget.task.copyWith(
                      title: titleController.text,
                      description: descriptionController.text,
                      state: stateController.text,
                      begin: begin,
                      end: end,
                      staffs: selected,
                    );
                    origin['title'] = titleController.text;
                    origin['description'] = descriptionController.text;
                    origin['state'] = stateController.text;
                    origin['begin'] = beginController.text;
                    origin['end'] = endController.text;
                    origin['staffsName'] = staffController.text;
                    await taskCubit.updateTask(newTask);
                    const snackBar = SnackBar(content: Text('L???ch c??ng t??c ???? ???????c c???p nh???t!'));
                    scaffoldMessenger..hideCurrentSnackBar()..showSnackBar(snackBar);
                  } else {
                    titleController.text = origin['title'] as String;
                    descriptionController.text =
                        origin['description'] as String;
                    stateController.text = origin['state'] as String;
                    beginController.text = origin['begin'] as String;
                    endController.text = origin['end'] as String;
                    staffController.text = origin['staffsName'] as String;
                    selected = options
                        .where((staff) => (origin['staffsName'] as String)
                            .contains(staff.name))
                        .toList();
                  }
                }
                setState(() {
                  editing = !editing;
                });
              },
              icon: Icon(
                editing ? Icons.done : Icons.edit,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 40.0),
                  buildContentRow('Ti??u ?????:', titleController),
                  const SizedBox(height: 60.0),
                  buildContentRow(
                    'M?? t???:',
                    descriptionController,
                  ),
                  const SizedBox(height: 60.0),
                  buildContentRow(
                    'Tr???ng th??i:',
                    stateController,
                  ),
                  const SizedBox(height: 60.0),
                  buildContentRow(
                    'B???t ?????u:',
                    beginController,
                  ),
                  const SizedBox(height: 60.0),
                  buildContentRow(
                    'K???t th??c:',
                    endController,
                  ),
                  const SizedBox(height: 60.0),
                  buildContentRow(
                    'Nh??n vi??n c??ng t??c:',
                    staffController,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildContentRow(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
        Expanded(
          flex: 2,
          child: buildEditing(label, controller),
        ),
      ],
    );
  }

  Widget buildEditing(String label, TextEditingController controller) {
    label = label.toLowerCase();
    final list = <String>['Ch??a b???t ?????u', '??ang th???c hi???n', '???? k???t th??c'];
    if (label == 'tr???ng th??i:') {
      return editing
          ? SizedBox(
              height: 50,
              child: DropdownButton<String>(
                underline: const SizedBox(),
                alignment: Alignment.center,
                value: controller.text,
                items: list
                    .map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    controller.text = value ?? controller.text;
                  });
                },
              ),
            )
          : Text(
              origin['state']!,
              style: const TextStyle(fontSize: 18),
            );
    }
    if (label == 'b???t ?????u:' || label == 'k???t th??c:') {
      return editing
          ? SizedBox(
              height: 50,
              child: TextField(
                readOnly: true,
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
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
                      if (label == 'b???t ?????u:') {
                        begin = finalDate;
                      } else {
                        end = finalDate;
                      }
                      controller.text = DateFormat('dd-MM-yyyy  -- ')
                          .add_jms()
                          .format(finalDate);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Icon(Icons.date_range_rounded),
                    ),
                  ),
                ),
              ),
            )
          : Text(
              label == 'b???t ?????u:' ? origin['begin']! : origin['end']!,
              style: const TextStyle(fontSize: 18),
            );
    }
    if (label == 'nh??n vi??n c??ng t??c:') {
      Future<void> fetchOptions() async {
        if (options.isEmpty) {
          options = (await StaffService().getAllStaffs()).cast<Staff>();
        }
      }

      return editing
          ? FutureBuilder(
              future: fetchOptions(),
              builder: (context, snapshot) => DropDownMultiSelect(
                readOnly: true,
                decoration: const InputDecoration(
                  // labelText: 'Nh??n vi??n c??ng t??c',
                  border: InputBorder.none,
                ),
                options: options.map((staff) => staff.name).toList(),
                selectedValues: selected.map((staff) => staff.name).toList(),
                onChanged: (values) {
                  selected = options
                      .where((staff) => values.contains(staff.name))
                      .toList();
                  staffController.text = '';
                  for (int i = 0; i < selected.length; i++) {
                    if (i == selected.length - 1) {
                      controller.text += selected[i].name;
                    } else {
                      controller.text += '${selected[i].name}, ';
                    }
                  }
                },
              ),
            )
          : Text(
              origin['staffsName']!,
              style: const TextStyle(fontSize: 18),
            );
    }
    return editing
        ? TextField(
            controller: controller,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
            ),
          )
        : Text(
            label == 'ti??u ?????:' ? origin['title']! : origin['description']!,
            style: const TextStyle(fontSize: 18),
          );
  }
}
