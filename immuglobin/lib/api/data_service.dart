import 'dart:async';
import 'dart:convert';
import 'package:immuglobin/api/api_service.dart';
import 'package:immuglobin/model/referance_data.dart';
import 'package:immuglobin/model/report.dart';

class DataService {
  final ApiService api;

  DataService() : api = ApiService();

  Future<List<RefDataModel>> fetchAllReferences() async {
    final response = await api.get('/get_all_referances');
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = response.data;
      final List<RefDataModel> references = jsonData
          .map((json) => RefDataModel.fromJson(jsonEncode(json)))
          .toList();
      return references;
    }
    return List.empty();
  }

  FutureOr<String> addReference(RefDataModel reference) async {
    final response = await api.post('/submit_referance', reference.toMap());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data["inserted_id"];
    }
    throw Exception(response.data['error']);
  }

  Future<List<Report>> fetchAllReports() async {
    final response = await api.get('/get_all_reports');
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = response.data;
      final List<Report> references =
          jsonData.map((json) => Report.fromJson(jsonEncode(json))).toList();
      return references;
    }
    return List.empty();
  }

  FutureOr<String> submitReport(Report report) async {
    final response = await api.post('/submit_report', report.toMap());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response
          .data["inserted_id"]; //{"inserted_id": str(result.inserted_id)}
    }
    throw Exception(response.data['error']);
  }

  FutureOr<String> removeReport(String reportId) async {
    final response = await api.post('/remove_report', {'id': reportId});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data; //{"deleted_count": str(result.deleted_count)}
    }
    throw Exception(response.data['error']);
  }

  Future<List<Report>> fetchReportsByUserId(String userId) async {
    // final id = int.parse(userId);
    final response =
        await api.post('/get_reports_by_user_id', {'user_id': userId});
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = response.data;
      final List<Report> reports =
          jsonData.map((json) => Report.fromJson(jsonEncode(json))).toList();
      return reports;
    }
    return List.empty();
  }
}

Future<void> main() async {
  final dataService = DataService();
  // final List<RefDataModel> result = await dataService.fetchAllReferences();
  // final report = Report(
  //   userId: '11111111111',
  //   userName: "Kaya Siradaglar",
  //   doctorId: '0',
  //   immun: 'IgG1',
  //   result: 5.0,
  //   timestamp: DateTime.now().toString(),
  // );

  // print(report);
  // final String insertResult = await dataService.submitReport(report);
  // print(insertResult);

  dataService.fetchAllReferences().then((value) {
    print(value);
  });
}
