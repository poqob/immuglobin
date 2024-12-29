// RefValue sınıfı
class RefValue {
  final int subj;
  final double gms;
  final double min;
  final double max;
  final int? minAge;
  final int? maxAge;

  RefValue({
    required this.subj,
    required this.gms,
    required this.min,
    required this.max,
    this.minAge,
    this.maxAge,
  });

  // JSON'dan RefValue nesnesi oluşturma
  factory RefValue.fromJson(Map<String, dynamic> json) {
    return RefValue(
      subj: json['subj'],
      gms: json['gms'].toDouble(),
      min: json['min'].toDouble(),
      max: json['max'].toDouble(),
      minAge: json['min_age'],
      maxAge: json['max_age'],
    );
  }

  @override
  String toString() {
    return 'RefValue(subj: $subj, gms: $gms, min: $min, max: $max, minAge: $minAge, maxAge: $maxAge)';
  }
}
