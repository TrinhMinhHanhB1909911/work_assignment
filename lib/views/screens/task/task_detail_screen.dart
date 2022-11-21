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
                          title: const Text('Lỗi'),
                          content: const Text(
                              'Ngày kết thúc phải sau ngày bắt đầu!'),
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
                        title: const Text('Xác nhận'),
                        content: const Text('Bạn có chắc muốn lưu thay đổi'),
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
                    taskCubit.updateTask(newTask);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 40.0),
              buildContentRow('Tiêu đề:', titleController),
              const SizedBox(height: 60.0),
              buildContentRow(
                'Mô tả:',
                descriptionController,
              ),
              const SizedBox(height: 60.0),
              buildContentRow(
                'Trạng thái:',
                stateController,
              ),
              const SizedBox(height: 60.0),
              buildContentRow(
                'Bắt đầu:',
                beginController,
              ),
              const SizedBox(height: 60.0),
              buildContentRow(
                'Kết thúc:',
                endController,
              ),
              const SizedBox(height: 60.0),
              buildContentRow(
                'Nhân viên công tác:',
                staffController,
              ),
            ],
          ),
        ),
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
    final list = <String>['Chưa bắt đầu', 'Đang thực hiện', 'Đã kết thúc'];
    if (label == 'trạng thái:') {
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
    if (label == 'bắt đầu:' || label == 'kết thúc:') {
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
                      if (label == 'bắt đầu:') {
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
              label == 'bắt đầu:' ? origin['begin']! : origin['end']!,
              style: const TextStyle(fontSize: 18),
            );
    }
    if (label == 'nhân viên công tác:') {
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
                  // labelText: 'Nhân viên công tác',
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
            label == 'tiêu đề:' ? origin['title']! : origin['description']!,
            style: const TextStyle(fontSize: 18),
          );
  }
}
