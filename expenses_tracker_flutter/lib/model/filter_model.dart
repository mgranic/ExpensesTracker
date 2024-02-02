
import 'package:intl/intl.dart';

class Filter {
  int userId;

  bool filterName;
  String name;

  bool filterCategory;
  String category;

  bool filterDateFrom;
  DateTime dateFrom;

  bool filterDateTo;
  DateTime dateTo;

  Filter(this.userId, this.filterName, this.name, this.filterCategory, this.category, this.filterDateFrom,
         this.dateFrom, this.filterDateTo, this.dateTo);

  Filter.byName(int userId, String name)
    : this.userId = userId,
      this.name = name,
      this.filterName = true,
      this.filterCategory = false,
      this.category = "",
      this.filterDateFrom = false,
      this.dateFrom =  DateTime(2024),
      this.filterDateTo = false,
      this.dateTo = DateTime(2024);

    Filter.byDateFrom(int userId, DateTime dateFrom)
      : this.userId = userId,
        this.name = "",
        this.filterName = false,
        this.filterCategory = false,
        this.category = "",
        this.filterDateFrom = true,
        this.dateFrom = dateFrom,
        this.filterDateTo = false,
        this.dateTo = DateTime(2024);

  Filter.fromJson(Map<String, dynamic> json)
    : userId = json['userId'] as int,
      filterName = json['filterName'] as bool,
      name = json['name'] as String,
      filterCategory = json['filterCategory'] as bool,
      category = json['category'] as String,
      filterDateFrom = json['filterDateFrom'] as bool,
      dateFrom = DateTime.parse(json['dateFrom']),
      filterDateTo = json['filterDateTo'] as bool,
      dateTo = DateTime.parse(json['dateTo']);

  Map<String, dynamic> toJson() => {
    'userId' : userId,
    'filterName': filterName,
    'name': name,
    'filterCategory': filterCategory,
    'category': category,
    'filterDateFrom': filterDateFrom,
    'dateFrom': DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSSSSZ').format(dateFrom),
    'filterDateTo': filterDateTo,
    'dateTo': DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSSSSZ').format(dateTo)
  };
}