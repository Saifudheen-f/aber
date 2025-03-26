import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/data/api.dart';
import 'package:espoir_marketing/presentation/widgets/appbar.dart';
import 'package:espoir_marketing/presentation/widgets/main_button.dart';
import 'package:espoir_marketing/presentation/widgets/snack_bar.dart';
import 'package:espoir_marketing/presentation/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, required this.customer});
  final Map<String, dynamic> customer;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController task;
  bool isSavingDetails = false;

  @override
  void initState() {
    super.initState();
    task = TextEditingController();
  }

  @override
  void dispose() {
    task.dispose();
    super.dispose();
  }

  Future<void> addTask() async {
    if (task.text.trim().isEmpty) {
      mySnackBar(context, "Task cannot be empty!");
      return;
    }

    setState(() {
      isSavingDetails = true;
    });

    try {
      Map<String, dynamic> updatedData = {
        'Task6': task.text,
        'Status_Task6': '',
        'Voice_Task6': '',
        'Image_Task6': '',
        'Status6_UpdatedTime': ''
      };

      await UserSheetApi.updateDataById(
        id: widget.customer['Id'].toString(),
        updatedData: updatedData,
      );

      Navigator.pop(context);
      mySnackBar(context, "Task added successfully!");
    } catch (e) {
      mySnackBar(context, 'Failed to add Task: ${e.toString()}');
      debugPrint("Error while adding task: $e"); // Error logging for debugging
    } finally {
      setState(() {
        isSavingDetails = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppbar(),
      body: Container(
        decoration: imageDecoration,
        child: Column(
          children: [
            const SizedBox(height: 120),
            MyTextFied(
              controller: task,
              hintText: "Enter task",
              obscureText: false,
              maxLine: 4,
            ),
            MyButton(
              onpress: isSavingDetails ? () {} : addTask,
              child: isSavingDetails
                  ? const SpinKitCircle(
                      color: Colors.white,
                      size: 20.0,
                    )
                  : const Text(
                      'Save Details',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
