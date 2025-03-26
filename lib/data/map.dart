import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
class MapUtils {
  static Future<void> openLocationOnGoogleMaps({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final Uri uri;

    if (Platform.isAndroid) {
      uri = Uri.parse(
        'geo:$latitude,$longitude?q=$latitude,$longitude${label != null ? '($label)' : ''}',
      );
    } else if (Platform.isIOS) {
      uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude${label != null ? '&query_place_name=$label' : ''}',
      );
    } else {
      throw UnsupportedError('Platform not supported');
    }

    try {
      if (!await canLaunchUrl(uri)) {
        throw 'Maps app not available';
      }
      await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
    } catch (e) {
      throw 'Could not launch maps: $e';
    }
  }
}