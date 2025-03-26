
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/data/map.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/widgets/lisenvoice.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/widgets/small_loading.dart';
import 'package:espoir_marketing/presentation/widgets/appbar.dart';
import 'package:espoir_marketing/presentation/widgets/map_button.dart';
import 'package:espoir_marketing/presentation/widgets/view_screen_widget/info_container.dart';
import 'package:flutter/material.dart';

import '../../../widgets/snack_bar.dart';

class ViewCompletedTasks extends StatelessWidget {
  const ViewCompletedTasks(
      {super.key, required this.customer, required this.index});
  final Map<String, dynamic> customer;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: myAppbar(),
      body: Container(
        decoration: imageDecoration,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              InfoContainer(
                  title:index == 6 ? "Self Task" : "Task $index", content: customer['Task$index']),
              SizedBox(
                height: 20,
              ),
              if (customer['Image_Task$index'] != null &&
                  customer['Image_Task$index'] != "")
                SizedBox(
                  height: 250,
                  child: Center(
                    child: Image.network(
                      customer['Image_Task$index'], // Replace with your image URL
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child; // Image loaded successfully
                        } else {
                          return SmallLoading();
                        }
                      },
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return Icon(Icons.error,
                            size: 50); // Error icon when image fails to load
                      },
                    ),
                  ),
                ),
              if (customer['Voice_Task$index'] != null &&
                  customer['Voice_Task$index'] != "")
                AudioPlayerAndUploder(
                    showRemoveButton: false,
                    initialVoice: customer['Voice_Task$index'],
                    onVoiceUpdated: (String? te) {}),
              SizedBox(
                height: 20,
              ),
              Mapbutton(
                location: customer['Location_Name$index'],
                onpress: () {
                  try {
                    MapUtils.openLocationOnGoogleMaps(
                      latitude: double.parse(customer['Latitude$index']),
                      longitude: double.parse(customer['Longitude$index']),
                    );
                  } catch (e) {
                    mySnackBar(context, "Invalid coordinates.");
                  }
                },
                longpress: () {},
                loading: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
