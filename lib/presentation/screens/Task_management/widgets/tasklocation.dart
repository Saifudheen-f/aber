import 'dart:async';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/data/location.dart';
import 'package:espoir_marketing/presentation/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';

class Tasklocation extends StatefulWidget {
  const Tasklocation({super.key, required this.updateLocation});

  final Function(String, String) updateLocation;

  @override
  State<Tasklocation> createState() => _TasklocationState();
}

class _TasklocationState extends State<Tasklocation> {
  final LocationService _locationService = LocationService();
  String location = "";
  String locationName = "Get Current Location";
  bool isLoadingLocation = false;

  Future<void> fetchCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        mySnackBar(context,
            "Location services are OFF. Please turn them ON in settings.");
        setState(() {
          isLoadingLocation = false;
        });
        return;
      }

      // Get the current position
      Position position = await _locationService.getCurrentPosition();
      String placeName = await _locationService.getPlacemark(position);

      setState(() {
        locationName = placeName;
        location = "${position.latitude}, ${position.longitude}";
      });

      widget.updateLocation(location, locationName);
      mySnackBar(context, "Location fetched successfully!");
    } on PermissionDeniedException {
      mySnackBar(
          context, "Location permission denied. Please enable it in settings.");
    } on TimeoutException {
      mySnackBar(context, "Location request timed out. Try again.");
    } catch (e) {
      mySnackBar(
          context, "Failed to fetch location. Please check your settings.");
    } finally {
      setState(() {
        isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fetchCurrentLocation,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), gradient: gradient),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoadingLocation
                  ? const Padding(
                      padding: EdgeInsets.all(3),
                      child: SpinKitCircle(
                        color: Colors.white,
                        size: 20.0,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        Text(
                          location.isEmpty
                              ? "Get Current Location"
                              : locationName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
