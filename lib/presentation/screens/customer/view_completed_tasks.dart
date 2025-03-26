import 'package:espoir_marketing/presentation/screens/Task_management/screens/view_completedtasks.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/widgets/completed.dart';
import 'package:flutter/material.dart';
import 'package:espoir_marketing/presentation/widgets/appbar.dart';
import 'package:espoir_marketing/core/decoration.dart';

class CompletedTasksInCustomerview extends StatefulWidget {
  const CompletedTasksInCustomerview({Key? key, required this.customer}) : super(key: key);
  final Map<String, dynamic> customer;

  @override
  State<CompletedTasksInCustomerview> createState() => _CompletedTasksInCustomerviewState();
}

int notcompleted = 0;
int completed = 0;

class _CompletedTasksInCustomerviewState extends State<CompletedTasksInCustomerview> {
  List<String?> selectedStatuses = List.generate(6, (_) => null);
  List<String?> newStatuses = List.generate(6, (_) => null);
  List<String?> voiceUrls = List.generate(6, (_) => null);
  List<String?> imageUrls = List.generate(6, (_) => null);
  List<bool> isSavingDetails = List.generate(6, (_) => false);
  List<String?> location = List.generate(6, (_) => null);
  List<String?> locationName = List.generate(6, (_) => null);

  @override
  void initState() {
    super.initState();
    debugPrint("CompletedTasksInCustomerview initState: customer data: ${widget.customer}");
    for (int i = 1; i <= 6; i++) {
      if (widget.customer['Status_Task$i'] != null &&
          widget.customer['Status_Task$i'].isNotEmpty) {
        selectedStatuses[i - 1] = widget.customer['Status_Task$i'];
        newStatuses[i - 1] = widget.customer['Status_Task$i'];
      }
      if (widget.customer['Voice_Task$i'] != null &&
          widget.customer['Voice_Task$i'].isNotEmpty) {
        voiceUrls[i - 1] = widget.customer['Voice_Task$i'];
      }
      if (widget.customer['Image_Task$i'] != null &&
          widget.customer['Image_Task$i'].isNotEmpty) {
        imageUrls[i - 1] = widget.customer['Image_Task$i'];
      }
    }
    debugPrint("Initialized selectedStatuses: $selectedStatuses");
  }

  @override
  Widget build(BuildContext context) {
    // Check if there are any completed tasks
    bool hasCompletedTasks = false;
    for (int i = 1; i <= 6; i++) {
      if (widget.customer['Task$i'] != null &&
          widget.customer['Task$i'].isNotEmpty &&
          selectedStatuses[i - 1] == 'Completed') {
        hasCompletedTasks = true;
        break;
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppbar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: imageDecoration,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:!hasCompletedTasks?
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "No completed tasks.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ): SingleChildScrollView(
            child:
             
            
            
             Column(
              children: [
                SizedBox(height: 100),
                Text(
                  "Completed Tasks",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
               
                for (int i = 1; i <= 6; i++)
                  if (widget.customer['Task$i'] != null &&
                      widget.customer['Task$i'].isNotEmpty &&
                      selectedStatuses[i - 1] == 'Completed') ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ViewCompletedTasks(
                                      customer: widget.customer,
                                      index: i,
                                    )));
                      },
                      child: Completed(
                        title: i == 6 ? "Self Task" : "Task$i",
                        content: widget.customer['Task$i'],
                      ),
                    ),
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
