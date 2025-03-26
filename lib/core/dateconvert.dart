
import 'package:intl/intl.dart';

String excelDateToDateTime(dynamic createat) {
  // Ensure createAt is a double
  double serialDate;
  if (createat is String) {
    serialDate = double.parse(createat);
  } else if (createat is double) {
    serialDate = createat;
  } else {
    throw Exception('Invalid type for createAt');
  }

  int days = serialDate.floor();
  double fractionalDay = serialDate - days;
  int millisecondsInADay = (fractionalDay * 86400).toInt() * 1000;
  DateTime baseDate = DateTime(1899, 12, 30);
  DateTime date =
      baseDate.add(Duration(days: days, milliseconds: millisecondsInADay));

  // Return the formatted date
  return DateFormat('d-M-yyyy').format(date);
}

String excelToDate(dynamic createat) {
  // Ensure createAt is a double
  double serialDate;
  if (createat is String) {
    serialDate = double.parse(createat);
  } else if (createat is double) {
    serialDate = createat;
  } else {
    throw Exception('Invalid type for createAt');
  }

  int days = serialDate.floor();
  double fractionalDay = serialDate - days;
  int millisecondsInADay = (fractionalDay * 86400).toInt() * 1000;
  DateTime baseDate = DateTime(1899, 12, 30);
  DateTime date =
      baseDate.add(Duration(days: days, milliseconds: millisecondsInADay));

  // Return the formatted date
  return DateFormat('dd-MM-yyyy').format(date);
}

String excelToDateTime(dynamic createat) {
  // Ensure createAt is a double
  double serialDate;
  if (createat is String) {
    serialDate = double.parse(createat);
  } else if (createat is double) {
    serialDate = createat;
  } else {
    throw Exception('Invalid type for createAt');
  }

  int days = serialDate.floor();
  double fractionalDay = serialDate - days;
  int millisecondsInADay = (fractionalDay * 86400).toInt() * 1000;
  DateTime baseDate = DateTime(1899, 12, 30);
  DateTime date =
      baseDate.add(Duration(days: days, milliseconds: millisecondsInADay));

  // Return the formatted date
  return DateFormat('dd-MM-yyyy , h:mm a').format(date);
}
String localformatDate(String dateTime) {
  try {
    final date = DateTime.parse(dateTime);
    return DateFormat('dd-MM-yyyy').format(date); // e.g., "12:00 AM 08-01-2025"
  } catch (e) {
    return dateTime;
  }
}



