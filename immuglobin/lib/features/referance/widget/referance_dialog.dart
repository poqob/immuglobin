import 'package:flutter/material.dart';
import 'package:immuglobin/model/referance_data.dart';

void showReferenceDetails(RefDataModel reference, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Reference Details"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Immun: ${reference.imm}"),
              Text("Reference: ${reference.ref}"),
              Text("Values:"),
              const SizedBox(height: 8.0),
              ...reference.values.map((value) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("  - Subject: ${value.subj}"),
                    Text("    GMS: ${value.gms}"),
                    Text("    Min: ${value.min}"),
                    Text("    Max: ${value.max}"),
                    if (value.minAge != null)
                      Text("    Min Age: ${value.minAge}"),
                    if (value.maxAge != null)
                      Text("    Max Age: ${value.maxAge}"),
                    const SizedBox(height: 8.0),
                  ],
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}
