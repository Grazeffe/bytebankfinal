import 'package:bytebankfinal/dao/contact_dao.dart';
import 'package:flutter/material.dart';

import '../models/contact.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _accountNumberController =
      TextEditingController();

  final ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New contact')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full name'),
                style: const TextStyle(fontSize: 24.0)),
            Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                    controller: _accountNumberController,
                    decoration: const InputDecoration(labelText: 'Account number'),
                    style: const TextStyle(fontSize: 24.0),
                    keyboardType: TextInputType.number)),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                      child: const Text('Create'),
                      onPressed: () {
                        final String name = _nameController.text;
                        final int? accountNumber =
                            int.tryParse(_accountNumberController.text);
                        if (name.isNotEmpty && accountNumber != null) {
                          final newContact = Contact(0, name, accountNumber);
                          _dao
                              .save(newContact)
                              .then((id) => Navigator.pop(context));
                        }
                      })),
            )
          ],
        ),
      ),
    );
  }
}
