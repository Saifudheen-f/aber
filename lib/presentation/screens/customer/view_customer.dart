import 'package:espoir_marketing/core/const.dart';
import 'package:espoir_marketing/core/dateconvert.dart';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/data/api.dart';
import 'package:espoir_marketing/data/map.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/widgets/taskcompled.dart';
import 'package:espoir_marketing/presentation/screens/customer/view_completed_tasks.dart';
import 'package:espoir_marketing/presentation/widgets/Add_customer_widgets/location.dart';
import 'package:espoir_marketing/presentation/widgets/appbar.dart';
import 'package:espoir_marketing/presentation/widgets/main_button.dart';
import 'package:espoir_marketing/presentation/widgets/map_button.dart';
import 'package:espoir_marketing/presentation/widgets/snack_bar.dart';
import 'package:espoir_marketing/presentation/widgets/view_screen_widget/carousel.dart';
import 'package:espoir_marketing/presentation/widgets/view_screen_widget/currentstage.dart';
import 'package:espoir_marketing/presentation/widgets/view_screen_widget/editable_con.dart';
import 'package:espoir_marketing/presentation/widgets/view_screen_widget/status.dart';
import 'package:espoir_marketing/presentation/widgets/view_screen_widget/view_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../widgets/view_screen_widget/info_container.dart';
import '../../widgets/view_screen_widget/infocontainer.dart';
import '../../widgets/view_screen_widget/view_requirement.dart';

class ViewCustomerDetails extends StatefulWidget {
  final Map<String, dynamic> customer;
  const ViewCustomerDetails({super.key, required this.customer});

  @override
  State<ViewCustomerDetails> createState() => _ViewCustomerDetailsState();
}

class _ViewCustomerDetailsState extends State<ViewCustomerDetails> {
  late TextEditingController remarksController;
  final FocusNode remarksFocusNode = FocusNode();
  bool showUpdateButton = false;
  bool isSavingDetails = false;
  DateTime? nextFollowDate;
  String? selectedStatus;
  String? currentStage;
  String location = "";
  String locationName = "";

  @override
  void initState() {
    super.initState();

    remarksController = TextEditingController(text: widget.customer['Remarks']);
    remarksFocusNode.addListener(_onFocusChange);
    selectedStatus = widget.customer['Status'];
    currentStage = widget.customer['Current_Stage']?.isNotEmpty == true
        ? widget.customer['Current_Stage']
        : null; // Default to null if empty or null
    nextFollowDate = widget.customer['Next_Follow_Update'] != null
        ? DateTime.tryParse(widget.customer['Next_Follow_Update'])
        : null;

    location = widget.customer['Latitude'] != null &&
            widget.customer['Longitude'] != null
        ? '${widget.customer['Latitude']}, ${widget.customer['Longitude']}'
        : '';

    locationName = widget.customer['Location_Name'] ?? '';
  }

  @override
  void dispose() {
    remarksFocusNode.removeListener(_onFocusChange);
    remarksFocusNode.dispose();
    remarksController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      showUpdateButton = remarksFocusNode.hasFocus;
    });
  }

  void updateLocation(String newLocation, String newLocationName) {
    setState(() {
      location = newLocation;
      locationName = newLocationName;
    });
    print('Updated Location: $locationName, $location');
  }

  Future<void> saveDetails() async {
    setState(() {
      isSavingDetails = true;
    });

    try {
      Map<String, dynamic> updatedData = {
        'Remarks': remarksController.text,
        'Status': selectedStatus,
        'Current_Stage': currentStage,
      };

      if (selectedStatus == "Follow Up" && nextFollowDate != null) {
        updatedData['Next_Follow_Update'] =
            DateFormat('yyyy-MM-dd').format(nextFollowDate!);
      } else if (selectedStatus != "Follow Up") {
        updatedData['Next_Follow_Update'] = "";
      }
      updatedData['Latitude'] = location.split(', ')[0];
      updatedData['Longitude'] = location.split(', ')[1];
      updatedData['Location_Name'] = locationName;
      updatedData['GoogleMap_Link'] = location.isNotEmpty
          ? 'https://www.google.com/maps?q=${location.split(', ')[0]},${location.split(', ')[1]}'
          : "";

      await UserSheetApi.updateDataById(
        id: widget.customer['Id'].toString(),
        updatedData: updatedData,
      );

      Navigator.pop(context);
      mySnackBar(context, "Details saved successfully!");
    } catch (e) {
      mySnackBar(context, 'Failed to save details: ${e.toString()}');
    } finally {
      setState(() {
        isSavingDetails = false;
      });
    }
  }

  Future<void> pickFollowUpDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        nextFollowDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppbar(actions: [
        Taskcompled(
          onpress: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => CompletedTasksInCustomerview(
                        customer: widget.customer)));
          },
        )
      ]),
      body: Container(
        height: double.infinity,
        decoration: imageDecoration,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                ),
                Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: icontheme,
                  ),
                ),
                const SizedBox(height: 8),
                NewInfoContainer(customer: widget.customer),
                RequirementContainer(
                    requirement: widget.customer['Requirement']),
                ViewCategory(requirement: widget.customer['Category']),
                if (widget.customer['Status'] == 'Follow Up')
                  InfoContainer(
                    title: 'Next Follow-Up Date',
                    content: excelToDate(
                      double.tryParse(
                              widget.customer['Next_Follow_Update'] ?? '0.0') ??
                          0.0,
                    ),
                  ),
                const SizedBox(height: 20),
                CurrentStage(
                  selectedValue: currentStage,
                  onChanged: (String? newValue) {
                    setState(() {
                      currentStage = newValue;
                    });
                  },
                ),
                widget.customer['Latitude'] != null &&
                        widget.customer['Latitude'].isNotEmpty &&
                        locationName != "" &&
                        locationName == widget.customer['Location_Name']
                    ? Mapbutton(
                        location: widget.customer['Location_Name'],
                        onpress: () {
                          try {
                            MapUtils.openLocationOnGoogleMaps(
                              latitude:
                                  double.parse(widget.customer['Latitude']),
                              longitude:
                                  double.parse(widget.customer['Longitude']),
                            );
                          } catch (e) {
                            mySnackBar(context, "Invalid coordinates.");
                          }
                        },
                        longpress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "Change Location",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                content: Text(
                                  "Do you want to change location?",
                                  style: TextStyle(fontSize: 14),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 10),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      "No",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // Add your code for No response here
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        location = "";
                                        locationName = "";
                                      });
                                      Navigator.of(context).pop();
                                      // Add your code to change location here
                                    },
                                  ),
                                ],
                                actionsPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              );
                            },
                          );
                        },
                        loading: false,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: LocationButton(updateLocation: updateLocation),
                      ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                MyCarouselSliderWidget(customer: widget.customer),
                const SizedBox(height: 20),
                StatusSection(
                  selectedStatus: selectedStatus,
                  onStatusChanged: (String? newStatus) {
                    setState(() {
                      selectedStatus = newStatus;
                    });
                  },
                  nextFollowDate: nextFollowDate,
                  pickFollowUpDate: pickFollowUpDate,
                ),
                EditableInfoContainer(
                  title: 'Remarks',
                  controller: remarksController,
                  focusNode: remarksFocusNode,
                ),
                const SizedBox(height: 20),
                if (showUpdateButton ||
                    selectedStatus != widget.customer['Status'] ||
                    nextFollowDate != null ||
                    currentStage != widget.customer['Current_Stage'] ||
                    widget.customer['Location_Name'] != locationName)
                  MyButton(
                    onpress: isSavingDetails ? () {} : saveDetails,
                    child: isSavingDetails
                        ? const SpinKitCircle(
                            color: Colors.white,
                            size: 20.0,
                          )
                        : const Text(
                            'Update Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
