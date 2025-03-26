import 'dart:io';
import 'package:espoir_marketing/core/decoration.dart';
import 'package:espoir_marketing/presentation/screens/Task_management/widgets/small_loading.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ImageUploader extends StatefulWidget {
  final Function(String?) onImageUpdated;
  final String? initialImage;

  const ImageUploader({
    Key? key,
    required this.onImageUpdated,
    this.initialImage,
  }) : super(key: key);

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  String? imagePath;
  final ImagePicker picker = ImagePicker();
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    imagePath = widget.initialImage;
  }

  Future<void> _pickImage(bool fromCamera) async {
    final pickedFile = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    setState(() {
      isUploading = true;
    });

    String fileName = basename(imagePath!);
    Reference storageRef =
        FirebaseStorage.instance.ref().child('images/$fileName');

    UploadTask uploadTask = storageRef.putFile(File(imagePath!));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    widget.onImageUpdated(downloadURL);

    setState(() {
      isUploading = false;
    });
  }

  void _removeImage() {
    setState(() {
      imagePath = null;
    });
    widget.onImageUpdated(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imagePath != null)
          Row(
            children: [
              Expanded(
                child: isUploading
                    ? SmallLoading()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Image",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: imagePath!.startsWith('http')
                                        ? Image.network(imagePath!)
                                        : Image.file(File(imagePath!)),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close,
                                      color: const Color.fromARGB(
                                          255, 4, 20, 113)),
                                  onPressed: _removeImage,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        SizedBox(height: 10),
        if (imagePath == null && !isUploading) _buildImagePickerOptions(),
      ],
    );
  }

  Widget _buildImagePickerOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ImagePickerIcons(
            icon: Icons.camera_alt,
            txt: " take photo",
            onpress: () => _pickImage(true),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: ImagePickerIcons(
            icon: Icons.photo_album_outlined,
            txt: " select photo",
            onpress: () => _pickImage(false),
          ),
        ),
      ],
    );
  }
}


class ImagePickerIcons extends StatelessWidget {
  const ImagePickerIcons({
    Key? key,
    required this.icon,
    required this.txt,
    required this.onpress,
  }) : super(key: key);

  final IconData icon;
  final String txt;
  final VoidCallback onpress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    txt,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
