// RefDataModel sınıfı
import 'dart:convert';

import 'package:immuglobin/model/referance_value.dart';

class RefDataModel {
  final String imm;
  final String ref;
  final List<RefValue> values;

  RefDataModel({
    required this.imm,
    required this.ref,
    required this.values,
  });

  // JSON'dan RefDataModel nesnesi oluşturma
  factory RefDataModel.fromJson(String jsonStr) {
    final data = json.decode(jsonStr);
    List<RefValue> values = List<RefValue>.from(
        data['values'].map((value) => RefValue.fromJson(value)));
    return RefDataModel(
      imm: data['imm'],
      ref: data['ref'],
      values: values,
    );
  }

  @override
  String toString() {
    return 'RefDataModel(imm: $imm, ref: $ref, values: $values)';
  }
}

void main() {
  const jsonString = '''
  {
    "imm": "IgG1",
    "ref": "Turkjmed",
    "values": [
        {
            "subj": 30,
            "gms": 5.1074,
            "min": 3.09,
            "max": 14.50,
            "min_age": 25,
            "max_age": 36
        },
        {
            "subj": 30,
            "gms": 5.0673,
            "min": 2.73,
            "max": 6.79,
            "min_age": 36,
            "max_age": 60
        },
        {
            "subj": 30,
            "gms": 5.6794,
            "min": 2.92,
            "max": 7.81,
            "min_age": 72,
            "max_age": 96
        }
    ]
  }
  ''';

  // JSON'dan Dart nesnesine dönüştürme
  final RefDataModel refDataModel = RefDataModel.fromJson(jsonString);

  for (var value in refDataModel.values) {
    print(value);
  }
}
