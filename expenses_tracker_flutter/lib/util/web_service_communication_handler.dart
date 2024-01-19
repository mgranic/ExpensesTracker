import 'dart:async';
import 'dart:core';

import 'package:http/http.dart'; // Contains a client for making API calls

// chrome://inspect/#devices
class ServiceCommunicationHandler {
  final _timeout = 10; // seconds
  final String baseUrl = 'https:/localhost:5079'; // on device

  Future<String> getWebServiceResponse(String url) async {
    return (await get(Uri.parse(url))).body;
  }

  /// This function takes request function and responseHandlerFunction and executes them
  /// it also handles web service response timeout as well as other potential generic failures
  /// "request" and "respnseHandler" do bot have to handle any generic failure scenario
  void sendWebServiceRequest(Function request, Function responseHandler) async {
    request().then((response) {
      responseHandler(response);
    }).catchError((err) {
      print('Server communication error: ${err.toString()}');
    })
        .timeout(Duration(seconds: _timeout), onTimeout: () {
      print('HTTP request timeout');
    });
  }

  /// This function takes request function and executes it. It returns Future
  /// it returns future response that is received from the server
  Future<dynamic> returnSendWebServiceRequest(Function request) {
    return request().timeout(Duration(seconds: _timeout)).catchError((err) {
      print('Server communication error: ${err.toString()}');
    });
  }

  /// This function takes request function and responseHandlerFunction and executes them
  /// it also handles web service response timeout as well as other potential generic failures
  /// "request" and "respnseHandler" do bot have to handle any generic failure scenario
  void sendWebServiceRequestData(Function request, Function responseHandler, dynamic data, {Function? customCallback}) async {
    if (customCallback == null) {
      _sendWebServiceRequestData(request, responseHandler, data);
    } else {
      _sendWebServiceRequestDataCustomCallback(request, responseHandler, data, customCallback);
    }
  }

  /// This function takes request function and responseHandlerFunction and executes them
  /// it also handles web service response timeout as well as other potential generic failures
  /// "request" and "respnseHandler" do bot have to handle any generic failure scenario
  void _sendWebServiceRequestData(Function request, Function responseHandler, dynamic data) async {
    request(data).then((response) {
      responseHandler(response);
    }).catchError((err) {
      print('Server communication error: ${err.toString()}');
    })
        .timeout(Duration(seconds: _timeout), onTimeout: () {
      print('HTTP request timeout');
    });
  }

  /// This function takes request function and responseHandlerFunction and executes them
  /// it also handles web service response timeout as well as other potential generic failures
  /// "request" and "respnseHandler" do bot have to handle any generic failure scenario
  void _sendWebServiceRequestDataCustomCallback(Function request, Function responseHandler, dynamic data, Function customCallback) async {
    request(data).then((response) async {
      await responseHandler(response);
      customCallback();
    }).catchError((err) {
      print('Server communication error: ${err.toString()}');
    })
        .timeout(Duration(seconds: _timeout), onTimeout: () {
      print('HTTP request timeout');
    });
  }
}