import 'package:espoir_marketing/presentation/screens/Task_management/screens/view_completedtasks.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/widgets/image.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/widgets/completed.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/widgets/tasklocation.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/widgets/voiceuploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:espoir_marketing/presentation/widgets/view_screen_widget/info_container.dart';
import 'package:espoir_marketing/presentation/widgets/task_staus.dart';
import 'package:espoir_marketing/presentation/widgets/main_button.dart';
import 'package:espoir_marketing/presentation/widgets/snack_bar.dart';
import 'package:espoir_marketing/presentation/widgets/appbar.dart';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/data/api.dart';
import 'package:intl/intl.dart';

class ViewTask extends StatefulWidget {
  const ViewTask({Key? key, required this.customer}) : super(key: key);
  final Map<String, dynamic> customer;

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

int notcompleted = 0;
int completed = 0;

class _ViewTaskState extends State<ViewTask> {
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
    debugPrint("ViewTask initState: customer data: ${widget.customer}");
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

  void updateLocation(int index, String newLocation, String newLocationName) {
    setState(() {
      location[index] = newLocation;
      locationName[index] = newLocationName;
    });
    print('Updated Location for Task $index: $newLocationName, $newLocation');
  }

  Future<void> saveTaskDetails(int taskIndex) async {
    setState(() {
      isSavingDetails[taskIndex] = true;
    });

    DateTime currentdate = DateTime.now();

    try {
      bool isValidUrl(String? url) {
        final urlPattern = r'^(https?:\/\/[^\s]+)$';
        return url != null && RegExp(urlPattern).hasMatch(url);
      }

      // Get values
      String? status = newStatuses[taskIndex];
      String? voiceUrl = voiceUrls[taskIndex];
      String? imageUrl = imageUrls[taskIndex];
      String? locationname = locationName[taskIndex];
      // If status is Completed, ensure at least one valid image or voice URL
      if (status == 'Completed') {
        if ((imageUrl == null || !isValidUrl(imageUrl)) &&
            (voiceUrl == null || !isValidUrl(voiceUrl))) {
          mySnackBar(context,
              "Please provide a valid Image or Voice URL for Task ${taskIndex + 1}.");
          setState(() {
            isSavingDetails[taskIndex] = false;
          });
          return;
        }
        if (locationname == null) {
          mySnackBar(context, "location required for Task${taskIndex + 1}.");
          setState(() {
            isSavingDetails[taskIndex] = false;
          });
          return;
        }
      }

      // Prepare updated data
      Map<String, dynamic> updatedData = {
        'Status_Task${taskIndex + 1}': status,
        'Voice_Task${taskIndex + 1}': isValidUrl(voiceUrl) ? voiceUrl : '',
        'Image_Task${taskIndex + 1}': isValidUrl(imageUrl) ? imageUrl : '',
        'Latitude${taskIndex + 1}': location[taskIndex]?.split(', ')[0] ?? '',
        'Longitude${taskIndex + 1}': location[taskIndex]?.split(', ')[1] ?? '',
        'Location_Name${taskIndex + 1}':locationName[taskIndex],
        'GoogleMap_Link${taskIndex + 1}': location[taskIndex]?.split(', ')[0] ==
                null
            ? ''
            : 'https://www.google.com/maps?q=${location[taskIndex]?.split(', ')[0]},${location[taskIndex]?.split(', ')[1]}',
        'Status${taskIndex + 1}_UpdatedTime':
            DateFormat('yyyy-MM-dd hh:mm a').format(currentdate),
      };

      await UserSheetApi.updateDataById(
        id: widget.customer['Id'].toString(),
        updatedData: updatedData,
      );

      setState(() {
        selectedStatuses[taskIndex] = status;
      });
      if (status != "Completed") {
        Navigator.pop(context);
      }
      Navigator.pop(context);
      mySnackBar(context, "Task updated successfully!");
    } catch (e) {
      mySnackBar(
          context, 'Failed to update Task ${taskIndex + 1}: ${e.toString()}');
    } finally {
      setState(() {
        isSavingDetails[taskIndex] = false;
      });
    }
  }

  void updateVoiceUrl(String? updatedVoiceUrl, int index) {
    setState(() {
      voiceUrls[index] = updatedVoiceUrl;
    });
  }

  void updateImageUrl(String? updatedImageUrl, int index) {
    setState(() {
      imageUrls[index] = updatedImageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if there are any completed tasks
    bool hasCompletedTasks = selectedStatuses.contains('Completed');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppbar(),
      body: Container(
        height: double.infinity,
        decoration: imageDecoration,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 100),
                const SizedBox(height: 10),
                for (int i = 1; i <= 6; i++)
                  if (widget.customer['Task$i'] != null &&
                      widget.customer['Task$i'].isNotEmpty &&
                      selectedStatuses[i - 1] != 'Completed') ...[
                    InfoContainer(
                      title: i == 6 ? "Self Task" : "Task$i",
                      content: widget.customer['Task$i'],
                    ),
                    const SizedBox(height: 10),
                    TaskStatus(
                      selectedStatus: newStatuses[i - 1],
                      onStatusChanged: (String? newStatus) {
                        setState(() {
                          newStatuses[i - 1] = newStatus;
                        });
                      },
                    ),
                    if (newStatuses[i - 1] == 'Completed')
                      Tasklocation(
                        updateLocation: (newLocation, newLocationName) =>
                            updateLocation(i - 1, newLocation, newLocationName),
                      ),
                    if (newStatuses[i - 1] == 'Completed')
                      ImageUploader(
                        onImageUpdated: (updatedImageUrl) =>
                            updateImageUrl(updatedImageUrl, i - 1),
                        initialImage: imageUrls[i - 1],
                      ),
                    if (newStatuses[i - 1] == 'Completed')
                      VoiceUploader(
                        onVoiceUpdated: (updatedVoiceUrl) =>
                            updateVoiceUrl(updatedVoiceUrl, i - 1),
                        initialVoice: voiceUrls[i - 1],
                      ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    MyButton(
                      onpress: isSavingDetails[i - 1]
                          ? () {}
                          : () => saveTaskDetails(i - 1),
                      child: isSavingDetails[i - 1]
                          ? const SpinKitCircle(
                              color: Colors.white,
                              size: 20.0,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Update Task',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                  ],
                const SizedBox(height: 20),
                if (hasCompletedTasks)
                  Text(
                    "Completed Tasks",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 10),
                for (int i = 1; i <= 6; i++)
                  if (widget.customer['Task$i'] != null &&
                      widget.customer['Task$i'].isNotEmpty &&
                      selectedStatuses[i - 1] == 'Completed') ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ViewCompletedTasks(customer: widget.customer,index: i,)));
                      },
                      child: Completed(
                        title: i == 6 ? "Self Task" : "Task$i",
                        content: widget.customer['Task$i'],
                      ),
                    )
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
