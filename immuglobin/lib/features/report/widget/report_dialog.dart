// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:immuglobin/api/data_service.dart';
import 'package:immuglobin/core/constants/session.dart';
import 'package:immuglobin/model/report.dart';

FutureOr<void> showReportDetails(Report report, BuildContext context) async {
  final DataService dataService = DataService();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Report Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Report ID: ${report.id}"),
            Text("Report Owner ID: ${report.userId}"),
            Text("Doctor ID: ${report.doctorId}"),
            Text("Immun: ${report.immun}"),
            Text("Result: ${report.result}"),
            Text("Date: ${report.timestamp}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
          if (Session.getUser()?.role.role == 'doctor')
            TextButton(
              onPressed: () async {
                try {
                  await dataService.removeReport(report.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Report removed successfully."),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } catch (error) {
                  Navigator.of(context).pop();

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text("Error: $error"),
                  //     duration: const Duration(seconds: 3),
                  //   ),
                  // );
                }
              },
              child: const Text("Remove Report"),
            ),
        ],
      );
    },
  );
}
