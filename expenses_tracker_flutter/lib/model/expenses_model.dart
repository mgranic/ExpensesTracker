
import 'package:intl/intl.dart';

class Expense {
  int id;
  String name;
  double price;
  String category;
  DateTime timestamp;
  int userId;

  Expense(this.id, this.name, this.price, this.category, this.timestamp, this.userId);

  Expense.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int,
      name = json['name'] as String,
      price = json['price'] as double,
      category = json['category'] as String,
      timestamp = DateTime.parse(json['timestamp']),
      userId = json['userId'] as int;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name': name,
    'price': price,
    'category': category,
    'timestamp': DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSSSSZ').format(timestamp),//timestamp.toString(),
    'userId' : userId
  };
}