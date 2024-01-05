import 'package:expenses_tracker/util/web_service_communication_handler.dart';
import 'package:expenses_tracker/model/expenses_model.dart';

import 'package:http/http.dart' as http;
import "dart:convert";

class HomePageController {

  // sed request to server to create new expense
  void createExpense() {
    print("Create new expense executed");
     ServiceCommunicationHandler webComm = ServiceCommunicationHandler();
      webComm.sendWebServiceRequest(_createExpenseRequest, _createExpenseResponseHandler);
  }

  Future<http.Response> _createExpenseRequest() {
    //return http.get(Uri.parse('http://localhost:5079/MotivationalQuoteApi/GetMotivationalQuote/radiiiiixxx'));   
    // var body = jsonEncode(<String, dynamic>{
    //  'id': 1,
    //  'name': 'Kava',
    //  'price' : 1.5,
    //  'userId' : 5
    //});

    var body = jsonEncode(Expense(1, "kava", 1.5, 5));
    return http.post(Uri.parse('http://localhost:5285/Expense/createExpense'), 
                              headers: {
                                'Content-Type': 'application/json',
                              },
                              body: body,
                            );
  }

  void _createExpenseResponseHandler(http.Response response) {
    print("sa servera smo dobili ${response.body}");
  }

}