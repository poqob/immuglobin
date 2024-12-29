// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:immuglobin/api/data_service.dart';
import 'package:immuglobin/core/constants/session.dart';
import 'package:immuglobin/model/report.dart';

class WriteReportScreen extends StatefulWidget {
  const WriteReportScreen({super.key});

  @override
  _WriteReportScreenState createState() => _WriteReportScreenState();
}

class _WriteReportScreenState extends State<WriteReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final DataService _dataService = DataService();

  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _immunController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();

  bool _isSubmitting = false;

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final report = Report(
        userId: _userIdController.text,
        doctorId: Session.getUser()!.id.toString(),
        immun: _immunController.text,
        result: double.parse(_resultController.text),
        timestamp: DateTime.now().toIso8601String(),
      );

      try {
        await _dataService.submitReport(report);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Report saved successfully!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save report: $e")),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Write Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(
                  labelText: "User ID",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "User ID is required.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _immunController,
                decoration: const InputDecoration(
                  labelText: "Immun",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Immun is required.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _resultController,
                decoration: const InputDecoration(
                  labelText: "Result",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Result is required.";
                  }
                  if (double.tryParse(value) == null) {
                    return "Result must be a valid number.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitReport,
                      child: const Text("Submit Report"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
