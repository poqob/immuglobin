import 'dart:convert';
import 'package:immuglobin/api/api_service.dart';
import 'package:immuglobin/model/referance_data.dart';

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
}

// void main() async {
//   final dataService = DataService();
//   final result = await dataService.fetchAllReferences();
//   print(result.length);
// }
