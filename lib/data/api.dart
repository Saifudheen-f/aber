import 'dart:developer';
import 'package:espoir_marketing/core/private.dart';
import 'package:espoir_marketing/domain/sheet_model.dart';
import 'package:gsheets/gsheets.dart';

class UserSheetApi {
  static late GSheets _gsheets;
  static const _spreadSheetId = spreadSheetId;
  static const _credentials = credentials;
  static const _sheetName = 'Customers';
  static late Worksheet _worksheet;

  /// Initialize the GSheets API with credentials and get/create the single worksheet
  static Future<void> init() async {
    try {
      _gsheets = GSheets(_credentials);
      final spreadsheet = await _gsheets.spreadsheet(_spreadSheetId);
      _worksheet = spreadsheet.worksheetByTitle(_sheetName) ??
          await spreadsheet.addWorksheet(_sheetName);

      // Initialize the headers if the sheet is empty
      if ((await _worksheet.values.allRows()).isEmpty) {
        final firstRow = UserFields.getFields();
        await _worksheet.values.insertRow(1, firstRow);
      }
    } catch (e) {
      log("Error initializing GSheets: $e");
      rethrow;
    }
  }

  /// Insert data into the single sheet
  static Future<void> insertData({
    required List<Map<String, dynamic>> rowData,
  }) async {
    try {
      List<List<dynamic>> rows = rowData.map((data) {
        return data.entries.map((entry) {
          if (entry.key == "imageUrls" && entry.value is List<String>) {
            return (entry.value as List<String>).join("; ");
          }
          return entry.value;
        }).toList();
      }).toList();

      await _worksheet.values.appendRows(rows);
      log("Data inserted successfully");
    } catch (e) {
      log("Error inserting data: $e");
      throw Exception("Data insertion failed");
    }
  }

  /// Retrieve all data
  static Future<List<Map<String, String>>?> retrieveAllData() async {
    try {
      final rows = await _worksheet.values.map.allRows();
      return rows ?? [];
    } catch (e) {
      log("Error retrieving data. Error: $e");
      return [];
    }
  }

  /// Update data by ID
  static Future<void> updateDataById({
    required String id,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      final rows = await _worksheet.values.map.allRows();
      if (rows == null || rows.isEmpty) {
        log("No data found in worksheet");
        return;
      }

      final rowIndex = rows.indexWhere((row) => row['Id'] == id);
      if (rowIndex == -1) {
        log("No matching ID found in worksheet");
        return;
      }

      final columnMapping = {
        for (var i = 0; i < rows[0].keys.length; i++)
          rows[0].keys.elementAt(i): i + 1
      };

      await Future.wait(updatedData.entries.map((entry) async {
        final columnIndex = columnMapping[entry.key];
        if (columnIndex != null) {
          await _worksheet.values
              .insertValue(entry.value, row: rowIndex + 2, column: columnIndex);
        }
      }));

      log("Data updated successfully in worksheet");
    } catch (e) {
      log("Error updating data. Error: $e");
    }
  }

  /// Delete data by ID
  static Future<void> deleteDataById({required String id}) async {
    try {
      final rows = await _worksheet.values.map.allRows();
      if (rows == null || rows.isEmpty) {
        log("No data found in worksheet");
        return;
      }

      final rowIndex = rows.indexWhere((row) => row['Id'] == id);
      if (rowIndex == -1) {
        log("No matching ID found in worksheet");
        return;
      }

      await _worksheet.deleteRow(rowIndex + 2);
      log("Row with ID $id deleted successfully");
    } catch (e) {
      log("Error deleting data. Error: $e");
    }
  }
}
