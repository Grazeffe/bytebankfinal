import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../models/contact.dart';
import '../../models/transaction.dart';
import '../webclient.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(baseUrl);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions = [];
    for (Map<String, dynamic> transactionJson in decodedJson) {
      final Map<String, dynamic> contactJson = transactionJson['contact'];
      final Transaction transaction = Transaction(
        transactionJson['id'],
        transactionJson['value'],
        Contact(
          0,
          contactJson['name'],
          contactJson['accountNumber'],
        ),
      );
      transactions.add(transaction);
    }
    return transactions;

    // return decodedJson
    //     .map((dynamic json) => Transaction.fromJson(json))
    //     .toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    debugPrint('baseUrl: $baseUrl');

    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(baseUrl,
        headers: {'Content-type': 'application/json', 'password': password},
        body: transactionJson);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }

    throw HttpException(_getErrorMessage(statusCode));
  }

  String _getErrorMessage(int statusCode) {
    if (_statusCodeResponses.containsKey(statusCode)) {
      return _statusCodeResponses[statusCode]!;
    }
    return 'Unknown error';
  }

  static final Map<int, String> _statusCodeResponses = {
    400: 'There was an error submitting transaction',
    401: 'Authentication failed',
    409: 'Transaction already exists'
  };
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);
}
