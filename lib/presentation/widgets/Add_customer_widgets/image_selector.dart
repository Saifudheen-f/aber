import 'dart:io';
import 'package:espoir_marketing/presentation/widgets/Add_customer_widgets/carousel_image.dart';
import 'package:espoir_marketing/presentation/widgets/imagepicker_icon.dart';
import 'package:espoir_marketing/presentation/widgets/snack_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class ImageSelector extends StatefulWidget {
  const ImageSelector({super.key, required this.updateImages});

  final Function(List<XFile>, List<String>) updateImages;

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  final ImagePicker picker = ImagePicker();
  double uploadProgress = 0;
  final List<XFile> imageFileList = [];
  List<String> imageUrls = [];

  void getImages() async {
    try {
      final List<XFile>? selectedImages = await picker.pickMultiImage();
      if (selectedImages != null) {
        setState(() {
          imageFileList.addAll(selectedImages);
        });
        await _uploadImages(selectedImages);
      }
    } catch (e) {
      debugPrint("Error selecting images: $e");
    }
  }

  void takePhoto() async {
    try {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          imageFileList.add(photo);
        });
        await _uploadImages([photo]);
      }
    } catch (e) {
      debugPrint("Error capturing photo: $e");
    }
  }

  Future<String> uploadFileWithRetry(File file, int retries) async {
    for (int i = 0; i < retries; i++) {
      try {
        String fileName = "file_${DateTime.now().millisecondsSinceEpoch}.jpg";

        Reference ref = FirebaseStorage.instance.ref(fileName);
        UploadTask task = ref.putFile(file);

        task.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            uploadProgress =
                (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        });

        TaskSnapshot snapshot = await task;
        return await snapshot.ref.getDownloadURL();
      } catch (e) {
        debugPrint("Upload failed (attempt ${i + 1}): $e");
        if (i == retries - 1) rethrow;
      }
    }
    throw Exception("Max retries exceeded for file upload.");
  }

  Future<void> _uploadImages(List<XFile> images) async {
    for (XFile image in images) {
      try {
        File file = File(image.path);
        String url = await uploadFileWithRetry(file, 3);
        imageUrls.add(url);
      } catch (e) {
        debugPrint("Failed to upload image: $e");
        mySnackBar(context, "Some images failed to upload. Please retry.");
      }
    }
    widget.updateImages(imageFileList, imageUrls);
  }

  void removeImage(int index) {
    setState(() {
      imageUrls.removeAt(index);
      imageFileList.removeAt(index);
    });
    widget.updateImages(imageFileList, imageUrls);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ImagePickerIcons(
                icon: Icons.camera_alt,
                txt: "Take Photos",
                onpress: takePhoto,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ImagePickerIcons(
                icon: Icons.photo_album_sharp,
                txt: "Select Photos",
                onpress: getImages,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ImageCarousel(
          imageFileList: imageFileList,
          imageUrls: imageUrls,
          removeImage: removeImage,
        ),
      ],
    );
  }
}
