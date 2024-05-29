import 'dart:async';

import 'package:bytebankfinal/components/response_dialog.dart';
import 'package:bytebankfinal/components/transaction_auth_dialog.dart';
import 'package:bytebankfinal/http/webclients/transaction_webclient.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../components/progress.dart';
import '../models/contact.dart';
import '../models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                visible: _sending,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Progress(message: 'Sending...'),
                ),
              ),
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(enableFeedback:false),
                    child: Text('Transfer'),
                    onPressed: () {
                      final double value = double.parse(_valueController.text);
                      final transactionCreated =
                          Transaction(Uuid().v4(), value, widget.contact);
                      showDialog(
                          context: context,
                          builder: (contextDialog) {
                            return TransactionAuthDialog(onConfirm: (password) {
                              _save(transactionCreated, password, context);
                            });
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(Transaction transactionCreated, String password,
      BuildContext context) async {
    Transaction transaction =
        await _send(transactionCreated, password, context);

    await _showSuccessfulMessage(transaction, context);
  }

  Future<void> _showSuccessfulMessage(
      Transaction transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog('Successful transaction');
          });
      Navigator.pop(context);
    }
  }

  Future<Transaction> _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    setState(() {
      _sending = true;
    });
    final Transaction transaction = await _webClient
        .save(transactionCreated, password)
        .catchError(
            (ex) => _showFailureMessage(context,
                message: 'Falha na conexão, tente novamente mais tarde'),
            test: (ex) => ex is TimeoutException)
        .catchError((ex) => _showFailureMessage(context, message: ex.message),
            test: (ex) => ex is HttpException)
        .catchError((ex) => _showFailureMessage(context),
            test: (ex) => ex is Exception)
        .whenComplete(() {
      setState(() {
        _sending = false;
      });
    });
    return transaction;
  }

  void _showFailureMessage(BuildContext context,
      {String message = 'Unknown error'}) {
    showDialog(
        context: context, builder: (contextDialog) => FailureDialog(message));
  }
}
