import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../../models/contact.dart';
import '../../models/transaction.dart';
import '../webclient.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response =
        await client.get(baseUrl).timeout(Duration(seconds: 5));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions = [];
    for (Map<String, dynamic> transactionJson in decodedJson) {
      final Map<String, dynamic> contactJson = transactionJson['contact'];
      final Transaction transaction = Transaction(
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

  Future<Transaction> save(Transaction transaction) async {
    debugPrint('baseUrl: $baseUrl');

    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client
        .post(baseUrl,
            headers: {'Content-type': 'application/json', 'password': '1000'},
            body: transactionJson)
        .timeout(Duration(seconds: 10));

    return Transaction.fromJson(jsonDecode(response.body));
  }
}
