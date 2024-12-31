import 'package:flutter/material.dart';
import 'package:immuglobin/api/data_service.dart';
import 'package:immuglobin/model/referance_data.dart';
import 'package:immuglobin/model/referance_value.dart';
import 'package:intl/intl.dart';

class QueryReferanceScreen extends StatefulWidget {
  const QueryReferanceScreen({super.key});

  @override
  _QueryReferanceScreenState createState() => _QueryReferanceScreenState();
}

class _QueryReferanceScreenState extends State<QueryReferanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _igValueController = TextEditingController();
  String? _selectedIgOption;
  bool _isSearching = false;
  List<RefDataModel> _searchResults = [];
  final DataService _dataService = DataService();

  final List<String> _igOptions = [
    'IgG',
    'IgG1',
    'IgG2',
    'IgG3',
    'IgG4',
    'IgA',
    'IgM'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  int _calculateAgeInMonths(DateTime dob) {
    final DateTime now = DateTime.now();
    final int years = now.year - dob.year;
    final int months = now.month - dob.month;
    return years * 12 + months;
  }

  Future<void> _searchReferances() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSearching = true;
      });

      // Fetch references from the data service
      final references = await _dataService.fetchAllReferences();

      // Filter references based on the selected Ig option and Ig value
      final double igValue = double.parse(_igValueController.text);
      final DateTime dob = DateFormat('yyyy-MM-dd').parse(_dateController.text);
      final int ageInMonths = _calculateAgeInMonths(dob);

      _searchResults = references.where((reference) {
        if (reference.imm != _selectedIgOption) return false;
        for (var value in reference.values) {
          if ((value.minAge == null || ageInMonths >= value.minAge!) &&
              (value.maxAge == null || ageInMonths <= value.maxAge!)) {
            return igValue >= value.min && igValue <= value.max;
          }
        }
        return false;
      }).toList();

      setState(() {
        _isSearching = false;
      });
    }
  }

  Widget _buildSearchResult(RefDataModel result) {
    final double igValue = double.parse(_igValueController.text);
    final RefValue? matchingValue = result.values.firstWhere(
      (value) => igValue >= value.min && igValue <= value.max,
      orElse: () => RefValue(subj: 0, gms: 0, min: 0, max: 0),
    );

    IconData icon;
    Color iconColor;

    if (matchingValue == null) {
      icon = Icons.error;
      iconColor = Colors.red;
    } else if (igValue < matchingValue.min) {
      icon = Icons.arrow_downward;
      iconColor = Colors.red;
    } else if (igValue > matchingValue.max) {
      icon = Icons.arrow_upward;
      iconColor = Colors.green;
    } else {
      icon = Icons.check;
      iconColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(result.ref),
        subtitle:
            Text("Min: ${matchingValue?.min}, Max: ${matchingValue?.max}"),
        trailing: Icon(icon, color: iconColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Query Referance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: "Date of Birth",
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Date of Birth is required.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedIgOption,
                items: _igOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedIgOption = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Ig Option",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ig option is required.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _igValueController,
                decoration: const InputDecoration(
                  labelText: "Ig Value",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ig value is required.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _searchReferances,
                      child: const Text("Search Referances"),
                    ),
              const SizedBox(height: 24),
              if (_searchResults.isNotEmpty)
                ..._searchResults
                    .map((result) => _buildSearchResult(result))
                    .toList(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _igValueController.dispose();
    super.dispose();
  }
}
