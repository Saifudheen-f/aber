import 'package:espoir_marketing/domain/sheet_model.dart';

class MyUser {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final String category;
  final String locationName;
  final String googleMapLink;
  final String createdAt;
  final String addedBy;
  final String requirement;
  final String status;
  final String nextFollowUpdate;
  final String remarks;
  final String image1;
  final String image2;
  final String image3;
  final String latitude;
  final String longitude;

  MyUser({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.category,
    required this.remarks,
    required this.locationName,
    required this.googleMapLink,
    required this.createdAt,
    required this.addedBy,
    required this.requirement,
    required this.status,
    required this.nextFollowUpdate,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.latitude,
    required this.longitude,
  });

  // factory MyUser.fromJson(Map<String, dynamic> json) {
  //   return MyUser(
  //     id: json[UserFields.id] ?? '',
  //     name: json[UserFields.name] ?? '',
  //     address: json[UserFields.address] ?? '',
  //     phoneNumber: json[UserFields.phoneNumber] ?? '',
  //     email: json[UserFields.email] ?? '',
  //     requirement: json[UserFields.requirement] ?? '',
  //     addedBy: json[UserFields.addedBy] ?? '',
  //     createdAt: json[UserFields.createdAt] ?? '',
  //     locationName: json[UserFields.locationName] ?? '',
  //     remarks: json[UserFields.remarks] ?? '',
  //     image1: json[UserFields.image1] ?? '',
  //     image2: json[UserFields.image2] ?? '',
  //     image3: json[UserFields.image3] ?? '',
  //     nextFollowUpdate: json[UserFields.nextFollowUpdate] ?? '',
  //     status: json[UserFields.status] ?? '',
  //     googleMapLink: json[UserFields.googleMapLink] ?? '',
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      UserFields.id: id,
      UserFields.name: name,
      UserFields.address: address,
      UserFields.phoneNumber: phoneNumber,
      UserFields.category: category,
      UserFields.requirement: requirement,
      UserFields.addedBy: addedBy,
      UserFields.createdAt: createdAt,
      UserFields.remarks: remarks,
      UserFields.image1: image1,
      UserFields.image2: image2,
      UserFields.image3: image3,
      UserFields.locationName: locationName,
      UserFields.googleMapLink: googleMapLink,
      UserFields.latitude: latitude,
      UserFields.longitude: longitude,
      UserFields.nextFollowUpdate: nextFollowUpdate,
      UserFields.status: status,
    };
  }
}
