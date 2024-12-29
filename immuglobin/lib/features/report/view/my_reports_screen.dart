// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:immuglobin/api/data_service.dart';
import 'package:immuglobin/core/constants/session.dart';
import 'package:immuglobin/features/report/widget/report_dialog.dart';
import 'package:immuglobin/model/report.dart';
import 'package:immuglobin/model/user.dart';

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
    if (query.isEmpty) {
      setState(() {
        _filteredReports = _allReports;
      });
    } else {
      setState(() {
        _filteredReports = _allReports
            .where((report) =>
                report.immun.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
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
          Expanded(
            child: _filteredReports.isEmpty
                ? const Center(
                    child: Text("No reports found."),
                  )
                : ListView.builder(
                    itemCount: _filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = _filteredReports[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text("Immun: ${report.immun}"),
                          subtitle: Text("Result: ${report.result}"),
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
