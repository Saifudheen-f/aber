import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({
    super.key,
    required this.imageFileList,
    required this.imageUrls,
    required this.removeImage,
  });

  final List<XFile> imageFileList;
  final List<String> imageUrls;
  final Function(int) removeImage;

  @override
  Widget build(BuildContext context) {
    if (imageFileList.isEmpty) {
      return Center(
        child: Text(
          "No images selected.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return CarouselSlider(
      items: imageFileList.asMap().entries.map((entry) {
        final int index = entry.key;
        final XFile image = entry.value;

        return FutureBuilder<File>(
          future: Future.value(File(image.path)), // Simulating image loading
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error loading image.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red[600],
                  ),
                ),
              );
            } else {
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(2, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        snapshot.data!,
                        width: MediaQuery.of(context).size.width * 0.8,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 14,
                    child: GestureDetector(
                      onTap: () => removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 119, 119, 119),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: 300.0,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
    );
  }
}
