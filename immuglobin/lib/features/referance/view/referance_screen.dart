// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:immuglobin/api/data_service.dart';
import 'package:immuglobin/features/referance/widget/referance_dialog.dart';
import 'package:immuglobin/model/referance_data.dart';

class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({super.key});

  @override
  _ReferenceScreenState createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> {
  final DataService _dataService = DataService();
  late Future<List<RefDataModel>> _referencesFuture;
  List<RefDataModel> _allReferences = [];
  List<RefDataModel> _filteredReferences = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _referencesFuture = _fetchReferences();
    _searchController.addListener(_filterReferences);
  }

  Future<List<RefDataModel>> _fetchReferences() async {
    final references = await _dataService.fetchAllReferences();
    setState(() {
      _allReferences = references;
      _filteredReferences = references;
    });
    return references;
  }

  void _filterReferences() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredReferences = _allReferences.where((reference) {
        return reference.imm.toLowerCase().contains(query) ||
            reference.ref.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("References"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Search",
                hintText: "Enter reference or immun",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<RefDataModel>>(
              future: _referencesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No references found."),
                  );
                }

                if (_filteredReferences.isEmpty) {
                  return const Center(
                    child: Text("No matching references found."),
                  );
                }

                return ListView.builder(
                  itemCount: _filteredReferences.length,
                  itemBuilder: (context, index) {
                    final reference = _filteredReferences[index];
                    return ListTile(
                      title: Text("Immun: ${reference.imm}"),
                      subtitle: Text("Reference: ${reference.ref}"),
                      onTap: () {
                        showReferenceDetails(reference, context);
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
