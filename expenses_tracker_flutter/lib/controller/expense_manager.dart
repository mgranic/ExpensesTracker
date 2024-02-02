import 'package:expenses_tracker/model/total_price_model.dart';
import 'package:expenses_tracker/util/web_service_communication_handler.dart';
import 'package:expenses_tracker/model/expenses_model.dart';
import 'package:expenses_tracker/model/filter_model.dart';
import 'package:expenses_tracker/config/web_service_config.dart';

import 'package:http/http.dart' as http;
import "dart:convert";

class ExpenseManager {

  late Future<List<Expense>> expenseList;
  late Future<List<TotalPrice>> totalPriceList;
  late ServiceCommunicationHandler _webComm = ServiceCommunicationHandler();
  late Future<double> moneySpentMonth;

  ExpenseManager() {
    _webComm = ServiceCommunicationHandler();
    expenseList =  _webComm.returnSendWebServiceRequest(_getAllExpensesRequest) as Future<List<Expense>>; // get all expenses
    moneySpentMonth =  _webComm.returnSendWebServiceRequest(_getTotalMoneySpentThisMonthRequest) as Future<double>;
    totalPriceList = _webComm.returnSendWebServiceRequest(_getTotalPricePerCategoryRequest) as Future<List<TotalPrice>>;
  }

  // sed request to server to create new expense
  void createExpense() async {
    _webComm.sendWebServiceRequest(_createExpenseRequest, _createExpenseResponseHandler);
  }

  // get all expenses from server
  void getAllExpenses() async {
    expenseList =  _webComm.returnSendWebServiceRequest(_getAllExpensesRequest) as Future<List<Expense>>;
  }

  // get total money spent for each category
  void getTotalPricePerCategory() async {
    totalPriceList =  _webComm.returnSendWebServiceRequest(_getTotalPricePerCategoryRequest) as Future<List<TotalPrice>>;
  }

  // get total money spent this month
  void getTotalMoneyThisMonth() async {
    moneySpentMonth =  _webComm.returnSendWebServiceRequest(_getTotalMoneySpentThisMonthRequest) as Future<double>;
  }

  void filterExpenses(Filter filter) async {
    expenseList =  _webComm.returnSendWebServiceRequestParam(_filterExpensesRequest, filter) as Future<List<Expense>>;
  }

  // create request to create new expense
  static Future<http.Response> _createExpenseRequest() {
    var body = jsonEncode(Expense(1, "kava", 1.5, "caffe", DateTime.now(), 5));
    print("Create expense request == ${body}");
    return http.post(Uri.parse(createExpenseUrl),
                              headers: {
                                'Content-Type': 'application/json',
                              },
                              body: body,
                            );
  }

  // handle response of create expense request
  void _createExpenseResponseHandler(http.Response response) {
    print("sa servera smo dobili ${response.body}");
  }

  /// create HTTP request to server to get list of all expenses
  Future<List<Expense>> _getAllExpensesRequest() async { 
    var body = jsonEncode({
                            "id" : 5,
                            "name" : "xyz"
                          });

    final response = await http.post(Uri.parse(getAllExpensesUrl),
                                     headers: {
                                       'Content-Type': 'application/json',
                                     },
                                     body: body,
                                      );

    List<dynamic> list = json.decode(response.body);
    print("_getAllExpensesRequest response.body = ${response.body}");
    List<Expense> expList = <Expense>[];

    // prepare list of Expense objects form JSON string
    for (var jsonString in list) {
      var expense = Expense.fromJson(jsonString);
      print("_getAllExpensesRequest expense.timestamp = ${expense.timestamp}");
      expList.add(expense);
    }

    return expList;
  }

  /// create HTTP request to server to get total money spent this month
  Future<double> _getTotalMoneySpentThisMonthRequest() async { 
    var body = jsonEncode({
                            "id" : 5,
                            "name" : "xyz"
                          });

    final response = await http.post(Uri.parse(getTotalMoneySpentThisMonthUrl), 
                                     headers: {
                                       'Content-Type': 'application/json',
                                     },
                                     body: body,
                                      );

    var totalPrice = json.decode(response.body) as double;

    print("_getAllExpensesRequest response.body = ${response.body}");

    return totalPrice;
  }

  /// create HTTP request get total money spent for each category
  Future<List<TotalPrice>> _getTotalPricePerCategoryRequest() async { 
    var body = jsonEncode({
                            "id" : 5,
                            "name" : "xyz"
                          });

    final response = await http.post(Uri.parse(getTotalPricePerCategoryUrl), 
                                     headers: {
                                       'Content-Type': 'application/json',
                                     },
                                     body: body,
                                      );

    List<dynamic> list = json.decode(response.body);
    print("getTotalPricePerCategory response.body = ${response.body}");
    List<TotalPrice> expList = <TotalPrice>[];

    // prepare list of TotalPrice objects form JSON string
    for (var jsonString in list) {
      var total = TotalPrice.fromJson(jsonString);
      print("_getAllExpensesRequest expense.name = ${total.name}");
      expList.add(total);
    }

    return expList;
  }

  /// get list of expenses based on filter specified in the function parameter
  Future<List<Expense>> _filterExpensesRequest(Filter filter) async { 
    print("_filterExpensesRequest filter.filterDateFrom = ${filter.filterDateFrom}");
    var body = jsonEncode(filter);
    final response = await http.post(Uri.parse(searchExpensesFilterUrl),
                                     headers: {
                                       'Content-Type': 'application/json',
                                     },
                                     body: body,
                                      );

    List<dynamic> list = json.decode(response.body);
    print("_filterExpensesRequest response.body = ${response.body}");
    List<Expense> expList = <Expense>[];

    // prepare list of Expense objects form JSON string
    for (var jsonString in list) {
      var expense = Expense.fromJson(jsonString);
      print("_filterExpensesRequest expense.timestamp = ${expense.timestamp}");
      expList.add(expense);
    }


    return expList;
  }

}