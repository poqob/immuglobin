// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:immuglobin/api/data_service.dart';
import 'package:immuglobin/features/report/widget/report_dialog.dart';
import 'package:immuglobin/model/report.dart';

class AllReportScreen extends StatefulWidget {
  const AllReportScreen({super.key});

  @override
  _AllReportScreenState createState() => _AllReportScreenState();
}

class _AllReportScreenState extends State<AllReportScreen> {
  final DataService _dataService = DataService();
  late Future<List<Report>> _reportsFuture;
  List<Report> _allReports = [];
  List<Report> _filteredReports = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _reportsFuture = _fetchReports();
    _searchController.addListener(_filterReports);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Report>> _fetchReports() async {
    final reports =
        await _dataService.fetchAllReports(); // Veri tabanından raporları çek
    _allReports = reports;
    _filteredReports = reports;
    return reports;
  }

  void _filterReports() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredReports = _allReports.where((report) {
        return report.userId.toLowerCase().contains(query) ||
            report.doctorId.toLowerCase().contains(query) ||
            report.immun.toLowerCase().contains(query) ||
            report.timestamp.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Search Reports",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Report>>(
              future: _reportsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("No any reports found."),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No reports found."),
                  );
                }

                return ListView.builder(
                  itemCount: _filteredReports.length,
                  itemBuilder: (context, index) {
                    final report = _filteredReports[index];
                    return ListTile(
                      title: Text("Owner ID: ${report.userId}"),
                      subtitle: Text(
                          "Immun: ${report.immun}, Result: ${report.result}"),
                      onTap: () {
                        showReportDetails(report, context);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
