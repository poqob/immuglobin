// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:immuglobin/api/data_service.dart';
import 'package:immuglobin/core/constants/session.dart';
import 'package:immuglobin/features/report/widget/report_dialog.dart';
import 'package:immuglobin/model/report.dart';
import 'package:immuglobin/model/user.dart';
import 'package:intl/intl.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  _MyReportsScreenState createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  User user = Session.getUser() as User;
  final DataService _dataService = DataService();
  late Future<List<Report>> _reportsFuture;
  List<Report> _allReports = [];
  List<Report> _filteredReports = [];
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _reportsFuture = _dataService.fetchReportsByUserId(user.id.toString());
    _initializeReports();
  }

  void _initializeReports() async {
    final reports = await _reportsFuture;
    setState(() {
      _allReports = reports;
      _filteredReports = reports;
    });
  }

  void _filterReports(String query) {
    if (query.isEmpty && _selectedDate == null) {
      setState(() {
        _filteredReports = _allReports;
      });
    } else {
      setState(() {
        _filteredReports = _allReports.where((report) {
          final matchesQuery = query.isEmpty ||
              report.immun.keys.any(
                  (key) => key.toLowerCase().contains(query.toLowerCase()));
          final matchesDate = _selectedDate == null ||
              DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(report.timestamp)) ==
                  DateFormat('yyyy-MM-dd').format(_selectedDate!);
          return matchesQuery && matchesDate;
        }).toList();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _filterReports(_searchController.text);
    }
  }

  Widget _buildImmunComparison(Report currentReport, Report? previousReport) {
    if (previousReport == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: currentReport.immun.entries.map((entry) {
        final previousValue = previousReport.immun[entry.key];
        if (previousValue == null) {
          return Text("${entry.key}: ${entry.value}");
        }

        final currentValue = double.tryParse(entry.value);
        final prevValue = double.tryParse(previousValue);

        if (currentValue == null || prevValue == null) {
          return Text("${entry.key}: ${entry.value}");
        }

        final icon = currentValue > prevValue
            ? const Icon(Icons.arrow_upward, color: Colors.green)
            : currentValue < prevValue
                ? const Icon(Icons.arrow_downward, color: Colors.red)
                : const Icon(Icons.horizontal_rule, color: Colors.grey);

        return Row(
          children: [
            Text("${entry.key}: ${entry.value}"),
            const SizedBox(width: 4),
            icon,
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Raporlarım"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: "Search by Ig",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      _filterReports(value);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
          ),
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _selectedDate = null;
                      });
                      _filterReports(_searchController.text);
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: _filteredReports.isEmpty
                ? const Center(
                    child: Text("No reports found."),
                  )
                : ListView.builder(
                    itemCount: _filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = _filteredReports[index];
                      final previousReport =
                          index > 0 ? _filteredReports[index - 1] : null;
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: _buildImmunComparison(report, previousReport),
                          subtitle: Text("Date: ${report.timestamp}"),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            showReportDetails(report, context);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
