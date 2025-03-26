import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MyCarouselSliderWidget extends StatelessWidget {
  const MyCarouselSliderWidget({super.key, required this.customer});
  final Map<String, dynamic> customer;

  @override
  Widget build(BuildContext context) {
    // Filter out null or empty image URLs
    List imageUrls = [
      customer['Image1'],
      customer['Image2'],
      customer['Image3'],
    ].where((url) => url != null && url.isNotEmpty).toList();

    // If no images are available, show a message
    if (imageUrls.isEmpty) {
      return Center(
        child: Text(
          "No images available for this customer.",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    // Build CarouselSlider
    return CarouselSlider(
      items: imageUrls.map((imageUrl) {
        return Container(
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
            child: Image.network(
              imageUrl,
              width: MediaQuery.of(context).size.width * 0.8,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text(
                    "Error loading image",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 300.0,
       // autoPlay: true,
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
