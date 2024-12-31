// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:immuglobin/api/data_service.dart';
import 'package:immuglobin/api/user_service.dart';
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
  final UserService _userService = UserService();

  final TextEditingController _userIdController = TextEditingController();

  final List<MapEntry<TextEditingController, TextEditingController>>
      _immunFields = [];

  bool _isSubmitting = false;

  void _addImmunField() {
    setState(() {
      _immunFields.add(MapEntry(
        TextEditingController(),
        TextEditingController(),
      ));
    });
  }

  void _removeImmunField(int index) {
    setState(() {
      _immunFields.removeAt(index);
    });
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final Map<String, String> immunMap = {
        for (var entry in _immunFields) entry.key.text: entry.value.text,
      };

      final Map<String, dynamic> reportData = {
        'user_id': _userIdController.text,
        'user_name':
            (await _userService.getUserById(_userIdController.text))['name'],
        'doctor_id': Session.getUser()!.id.toString(),
        'timestamp': DateTime.now().toIso8601String(),
        'immun': immunMap
      };

      // Submit logic
      try {
        await _dataService
            .submitReport(Report.fromJson(jsonEncode(reportData)));
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
              const Text(
                "Immun Fields",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ..._immunFields.asMap().entries.map((entry) {
                final index = entry.key;
                final field = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: field.key.text.isEmpty ? null : field.key.text,
                        items: [
                          'IgG',
                          'IgG1',
                          'IgG2',
                          'IgG3',
                          'IgG4',
                          'IgA',
                          'IgM'
                        ]
                            .map((label) => DropdownMenuItem(
                                  child: Text(label),
                                  value: label,
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            field.key.text = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Key",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Key is required.";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: field.value,
                        decoration: const InputDecoration(
                          labelText: "Value",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Value is required.";
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeImmunField(index),
                    ),
                  ],
                );
              }),
              ElevatedButton.icon(
                onPressed: _addImmunField,
                icon: const Icon(Icons.add),
                label: const Text("Add Immun Field"),
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
