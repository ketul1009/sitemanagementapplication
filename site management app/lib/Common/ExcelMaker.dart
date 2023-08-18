import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart'; // Import the permission_handler package for managing permissions
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> exportExcel(BuildContext context, List<List<dynamic>> data) async {
    // Check and request permissions to access external storage (Android specific)
    var status = await Permission.storage.request();
    if (status.isGranted) {
        final Excel excel = Excel.createExcel();
        final Sheet sheetObject = excel['Sheet1'];

        // Insert the data into the Excel sheet
        for (var rowIdx = 0; rowIdx < data.length; rowIdx++) {
            final List<dynamic> row = data[rowIdx];
            for (var colIdx = 0; colIdx < row.length; colIdx++) {
                sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: colIdx, rowIndex: rowIdx)).value = row[colIdx];
            }
        }

        try {
            // Show the file picker to let the user choose the directory
            String? downloadsPath = await FilePicker.platform.getDirectoryPath();

            if (downloadsPath != null) {
                Directory selectedDir = Directory(downloadsPath); // Create a Directory instance for the selected directory
                String filePath = '${selectedDir.path}/document.xlsx';

                // Export the Excel file
                final File file = File(filePath);
                await file.writeAsBytes(excel.encode()!);

                // Provide the file path to the user or share it via other means (e.g., email)
                Fluttertoast.showToast(msg: "File saved successfully at: $filePath", toastLength: Toast.LENGTH_LONG);
                debugPrint('Excel file exported successfully. Path: $filePath');
            }
            else {
                Fluttertoast.showToast(msg: "No directory Selected", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red);
            }
        }
        catch (e) {
            Fluttertoast.showToast(msg: "Some Error occurred", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red);
        }
    }
    else if (status.isDenied) {
        // Permission is denied.
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Simple Dialog'),
                    content: const Text('status.isDenied'),
                    actions: [
                        TextButton(
                            onPressed: () {
                                Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                        ),
                    ],
                );
            },
        );
    }
    else if (status.isPermanentlyDenied) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Simple Dialog'),
                    content: const Text('status.isPermanentlyDenied'),
                    actions: [
                        TextButton(
                            onPressed: () {
                                Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                        ),
                    ],
                );
            },
        );
        openAppSettings();
    }
}

Future<void> exportGreenData(List<dynamic> data) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
        final Excel excel = Excel.createExcel();
        final Sheet sheetObject = excel['Sheet1'];

        // Insert the data into the Excel sheet
        for (var rowIdx = 0; rowIdx < data.length; rowIdx++) {
            final List<dynamic> row = data[rowIdx];
            for (var colIdx = 0; colIdx < row.length; colIdx++) {
                sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: colIdx, rowIndex: rowIdx)).value = row[colIdx];
            }
        }

        try {
            // Show the file picker to let the user choose the directory
            String? downloadsPath = await FilePicker.platform.getDirectoryPath();

            if (downloadsPath != null) {
                Directory selectedDir = Directory(downloadsPath); // Create a Directory instance for the selected directory
                String filePath = '${selectedDir.path}/example.xlsx';

                // Export the Excel file
                final File file = File(filePath);
                await file.writeAsBytes(excel.encode()!);

                // Provide the file path to the user or share it via other means (e.g., email)
                Fluttertoast.showToast(msg: "File saved successfully at: $filePath", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.green);
            }
            else {
                Fluttertoast.showToast(msg: "No directory Selected", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red);
            }
        }
        catch (e) {
            Fluttertoast.showToast(msg: "Some Error occurred", toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red);
        }
    }
}