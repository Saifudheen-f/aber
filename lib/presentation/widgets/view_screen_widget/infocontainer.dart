import 'package:espoir_marketing/core/const.dart';
import 'package:espoir_marketing/core/dateconvert.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class NewInfoContainer extends StatelessWidget {
  final Map<String, dynamic> customer;

  const NewInfoContainer({required this.customer, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color.fromARGB(255, 81, 81, 82),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildInfoRows(context),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildInfoRows(BuildContext context) {
    final infoFields = [
      {'icon': Icons.person, 'value': customer['Name'] ?? 'No Name'},
      {'icon': Icons.location_on, 'value': customer['Address'] ?? 'No address'},
      {
        'icon': Icons.phone,
        'value': customer['Phone_Number'] ?? 'No phone',
        'isClickable': true, // Mark phone number as clickable
      },
      {
        'icon': Icons.calendar_today,
        'value': excelToDateTime(customer['Created_At']).toString()
      },
    ];

    return infoFields.map((field) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              field['icon']!,
              color: icontheme,
              size: 20.0,
              semanticLabel: '${field['value']}',
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 3,
              child: field['isClickable'] == true
                  ? GestureDetector(
                      onTap: () =>
                          _makePhoneCall(_formatPhoneNumber(field['value'])),
                      onLongPress: () {
                        Clipboard.setData(ClipboardData(
                            text: _formatPhoneNumber(field['value'])));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Phone number copied to clipboard!')),
                        );
                      },
                      child: Text(
                        _formatPhoneNumber(field['value']),
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 1, 45, 81),
                        ),
                      ),
                    )
                  : Text(
                      field['value']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

 String _formatPhoneNumber(String phoneNumber) {
  if (phoneNumber == 'No phone') return phoneNumber;

  String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

  if (cleanedNumber.startsWith('91')) {
    // Check if the cleaned number starts with '91' (already has country code)
    return '+$cleanedNumber';
  }

  if (cleanedNumber.length == 10) {
    return '+91$cleanedNumber';
  }

  return phoneNumber;
}

}
