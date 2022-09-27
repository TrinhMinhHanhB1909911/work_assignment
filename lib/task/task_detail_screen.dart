import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multiselect/multiselect.dart';

import '../../models/task.dart';
import '../models/staff.dart';
import '../staff/staff_service.dart';
import 'task_cubit.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);
  final Task task;

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
        actions: [
          TextButton(
            onPressed: () async {
              if (editing) {
                bool confirm = await showDialog(
                  context: context,
                  builder: (context) {
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
                  BlocProvider.of<TaskCubit>(context).updateTask(newTask);
                }
              }
              setState(() {
                editing = !editing;
              });
            },
            child: Text(
              editing ? 'Xong' : 'Sửa',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildContentRow('Tiêu đề:', titleController),
            buildContentRow(
              'Mô tả:',
              descriptionController,
            ),
            buildContentRow(
              'Trạng thái:',
              stateController,
            ),
            buildContentRow(
              'Bắt đầu:',
              beginController,
            ),
            buildContentRow(
              'Kết thúc:',
              endController,
            ),
            buildContentRow(
              'Nhân viên công tác:',
              staffController,
            ),
          ],
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
              label == 'bắt đầu:'
                  ? origin['begin']!
                  : origin['end']!,
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
                  // controller.clear();
                  // var selectedStaffs = options
                  //     .where((staff) => values.contains(staff.name))
                  //     .toList();
                  // for (int i = 0; i < selectedStaffs.length; i++) {
                  //   if (i == selectedStaffs.length - 1) {
                  //     controller.text += selectedStaffs[i].name;
                  //   } else {
                  //     controller.text += '${selectedStaffs[i].name}, ';
                  //   }
                  // }
                },
              ),
            )
          : Text(
              origin['staffsName']!,
              style: const TextStyle(fontSize: 18),
            );
    }
    return editing
        ? TextField(controller: controller)
        : Text(
            label == 'tiêu đề:' ? origin['title']! : origin['description']!,
            style: const TextStyle(fontSize: 18),
          );
  }
}
