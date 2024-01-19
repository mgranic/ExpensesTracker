import 'package:expenses_tracker/model/total_price_model.dart';
import 'package:expenses_tracker/util/web_service_communication_handler.dart';
import 'package:expenses_tracker/model/expenses_model.dart';

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

  void getAllExpenses() async {
    expenseList =  _webComm.returnSendWebServiceRequest(_getAllExpensesRequest) as Future<List<Expense>>;
  }

  void getTotalPricePerCategory() async {
    totalPriceList =  _webComm.returnSendWebServiceRequest(_getTotalPricePerCategoryRequest) as Future<List<TotalPrice>>;
  }

   void getTotalMoneyThisMonth() async {
    moneySpentMonth =  _webComm.returnSendWebServiceRequest(_getTotalMoneySpentThisMonthRequest) as Future<double>;
  }

  // create request to create new expense
  static Future<http.Response> _createExpenseRequest() {
    var body = jsonEncode(Expense(1, "kava", 1.5, "caffe", DateTime.now(), 5));
    print("Create expense request == ${body}");
    return http.post(Uri.parse('http://localhost:5285/Expense/createExpense'), 
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

    final response = await http.post(Uri.parse('http://localhost:5285/Expense/getAllExpenses'), 
                                     headers: {
                                       'Content-Type': 'application/json',
                                     },
                                     body: body,
                                      );

    List<dynamic> list = json.decode(response.body);
    print("_getAllExpensesRequest response.body = ${response.body}");
    List<Expense> expList = <Expense>[];

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

    final response = await http.post(Uri.parse('http://localhost:5285/Expense/getTotalMoneySpentThisMonth'), 
                                     headers: {
                                       'Content-Type': 'application/json',
                                     },
                                     body: body,
                                      );

    var totalPrice = json.decode(response.body) as double;

    print("_getAllExpensesRequest response.body = ${response.body}");

    return totalPrice;
  }

  /// create HTTP request to server to get list of all expenses
  Future<List<TotalPrice>> _getTotalPricePerCategoryRequest() async { 
    var body = jsonEncode({
                            "id" : 5,
                            "name" : "xyz"
                          });

    final response = await http.post(Uri.parse('http://localhost:5285/Expense/getTotalPricePerCategory'), 
                                     headers: {
                                       'Content-Type': 'application/json',
                                     },
                                     body: body,
                                      );

    List<dynamic> list = json.decode(response.body);
    print("getTotalPricePerCategory response.body = ${response.body}");
    List<TotalPrice> expList = <TotalPrice>[];

    for (var jsonString in list) {
      var total = TotalPrice.fromJson(jsonString);
      print("_getAllExpensesRequest expense.name = ${total.name}");
      expList.add(total);
    }

    return expList;
  }

}