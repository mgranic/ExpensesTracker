import 'package:intl/intl.dart';

class TotalPrice {
  double total;
  String name;

  TotalPrice(this.total, this.name);

  TotalPrice.fromJson(Map<String, dynamic> json)
    : total = json['total'] as double,
      name = json['name'] as String;

  Map<String, dynamic> toJson() => {
    'total' : total,
    'name': name
  };
}