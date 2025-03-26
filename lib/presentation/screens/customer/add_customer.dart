import 'dart:async';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/core/validation.dart';
import 'package:espoir_marketing/data/api.dart';
import 'package:espoir_marketing/domain/model.dart';
import 'package:espoir_marketing/presentation/widgets/Add_customer_widgets/image_selector.dart';
import 'package:espoir_marketing/presentation/widgets/Add_customer_widgets/location.dart';
import 'package:espoir_marketing/presentation/widgets/appbar.dart';
import 'package:espoir_marketing/presentation/widgets/category.dart';
import 'package:espoir_marketing/presentation/widgets/main_button.dart';
import 'package:espoir_marketing/presentation/widgets/requirement.dart';
import 'package:espoir_marketing/presentation/widgets/selectnumber.dart';
import 'package:espoir_marketing/presentation/widgets/snack_bar.dart';
import 'package:espoir_marketing/presentation/widgets/textfield.dart';
import 'package:espoir_marketing/presentation/widgets/view_screen_widget/status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController remarks = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  List<XFile> imageFileList = [];
  String location = "";
  String locationName = "";
  bool isSavingDetails = false;
  double uploadProgress = 0;
  String? selectedStatus;
  String? requirement;
  String? category;
  DateTime? nextFollowDate;
  List<String> imageUrls = [];
  void updateLocation(String newLocation, String newLocationName) {
    setState(() {
      location = newLocation;
      locationName = newLocationName;
    });
    print('Updated Location: $locationName, $location');
  }

  void updateImages(List<XFile> newImageFileList, List<String> newImageUrls) {
    setState(() {
      imageFileList = newImageFileList;
      imageUrls = newImageUrls;
    });
    print('Updated Images: ${imageFileList.length} images, URLs: $imageUrls');
  }

  void updatePhoneNumber(String number) {
    setState(() {
      phoneNumber.text = number; // Update the number in parent
    });
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

  void saveCustomer() async {
    print(phoneNumber.text);
    if (isSavingDetails) return;

    if (_formKey.currentState?.validate() ?? false) {
      if (locationName == "Get Current Location") {
        mySnackBar(context, 'Please fetch location.');
      } else if (selectedStatus == null) {
        mySnackBar(context, 'Please select a status.');
      } else if (selectedStatus == 'Follow Up' && nextFollowDate == null) {
        mySnackBar(context, 'Please select the next follow-up date.');
      } else if (imageUrls.length != imageFileList.length) {
        mySnackBar(context, "Please wait for all images to finish uploading.");
      } else {
        setState(() {
          isSavingDetails = true;
        });

        try {
          String currentDateTime =
              DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.now());
          String image1Url = imageUrls.isNotEmpty ? imageUrls[0] : '';
          String image2Url = imageUrls.length > 1 ? imageUrls[1] : '';
          String image3Url = imageUrls.length > 2 ? imageUrls[2] : ''; 
          List<Map<String, String>>? users =
              await UserSheetApi.retrieveAllData();
          var nextId = (users?.length ?? 0) + 1;
          MyUser user = MyUser(
            id: nextId.toString(),
            name: name.text,
            address: address.text,
            phoneNumber: phoneNumber.text,
            category: category ?? "",
            remarks: remarks.text,
            locationName: locationName,
            createdAt: currentDateTime,
            addedBy: auth.currentUser?.email ?? "No email",
            status: selectedStatus ?? "",
            nextFollowUpdate: nextFollowDate != null
                ? DateFormat('yyyy-MM-dd').format(nextFollowDate!)
                : "",
            requirement: requirement ?? "",
            googleMapLink:
                'https://www.google.com/maps?q=${location.split(', ')[0]},${location.split(', ')[1]}',
            image1: image1Url,
            image2: image2Url,
            image3: image3Url,
            latitude: location.split(', ')[0],
            longitude: location.split(', ')[1],
          );

          await UserSheetApi.insertData(rowData: [user.toJson()]);

          name.clear();
          address.clear();
          remarks.clear();
          setState(() {
            location = "Get Current Location";
            locationName = "Get Current Location";
            selectedStatus = null;
            nextFollowDate = null;
            imageFileList.clear();
            imageUrls.clear();
          });

          Navigator.pop(context);
          mySnackBar(context, "Customer saved successfully!");
        } catch (error) {
          mySnackBar(context, "Error saving customer: ${error.toString()}");
        } finally {
          setState(() {
            isSavingDetails = false;
          });
        }
      }
    } else {
      mySnackBar(context, "Please fix the errors in the form.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppbar(),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: imageDecoration,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 100),
                      buildTextField(name, 'Name', false,
                          maxlength: 20,
                          validator: (value) => validateNotNull(value, 'Name')),
                      buildTextField(address, 'Address', false,
                          maxlength: 100,
                          maxLines: 5,
                          minLines: 3,
                          validator: (value) =>
                              validateNotNull(value, 'Address')),
                      PhoneNumber(
                        controller: phoneNumber,
                        validator: validatePhoneNumber,
                      ),
                      CategoryWidget(
                          selectedValue: category,
                          onChanged: (String? newValue) {
                            setState(() {
                              category = newValue;
                            });
                          }),
                      const SizedBox(height: 10),
                      LocationButton(updateLocation: updateLocation),
                      const SizedBox(height: 20),
                      CustomDropdownButton(
                          selectedValue: requirement,
                          onChanged: (String? newValue) {
                            setState(() {
                              requirement = newValue;
                            });
                          }),
                      const SizedBox(height: 20),
                      ImageSelector(
                        updateImages: updateImages,
                      ),
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
                      buildTextField(
                        remarks,
                        'Remarks',
                        false,
                        maxlength: 300,
                        maxLines: 5,
                        minLines: 3,
                      ),
                      const SizedBox(height: 20),
                      MyButton(
                        onpress: isSavingDetails ? () {} : saveCustomer,
                        child: isSavingDetails
                            ? const SpinKitCircle(
                                color: Colors.white,
                                size: 20.0,
                              )
                            : const Text(
                                'Save Details',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
