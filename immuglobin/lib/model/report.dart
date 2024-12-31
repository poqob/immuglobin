import 'dart:convert';
import 'package:crypto/crypto.dart';

class Report {
  final String userId;
  final String userName;
  final String doctorId;
  final Map<String, String> immun;
  final String timestamp;
  late final String id;

  Report({
    required this.userId,
    required this.userName,
    required this.doctorId,
    required this.immun,
    required this.timestamp,
  }) {
    id = _generateUniqueId();
  }

  String _generateUniqueId() {
    final uniqueString = '$timestamp$userName$userId$doctorId';
    return md5.convert(utf8.encode(uniqueString)).toString();
  }

  @override
  String toString() {
    return 'Report: $userId $userName $doctorId $immun $timestamp';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'doctor_id': doctorId,
      'immun': immun,
      'timestamp': timestamp,
    };
  }

  factory Report.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Report(
      userId: json['user_id'],
      userName: json['user_name'],
      doctorId: json['doctor_id'],
      immun: Map<String, String>.from(json['immun']),
      timestamp: json['timestamp'],
    );
  }
}
