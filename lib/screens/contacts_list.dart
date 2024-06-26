import 'package:bytebankfinal/models/contact.dart';
import 'package:bytebankfinal/screens/contact_form.dart';
import 'package:flutter/material.dart';

import '../dao/contact_dao.dart';

class ContactsList extends StatefulWidget {
  ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
        ),
        body: FutureBuilder<List<Contact>>(
            future: _dao.findAll(),
            // Future.delayed(Duration(seconds: 1)).then((value) => findAll()),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  break;
                case ConnectionState.waiting:
                  {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text('Loading...')
                        ],
                      ),
                    );
                  }
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                  {
                    final List<Contact> contacts = snapshot.requireData;
                    return ListView.builder(
                        itemBuilder: (context, index) {
                          return _ContactItem(contacts[index]);
                        },
                        itemCount: contacts.length);
                  }
              }
              return const Text('Unknown error :(');
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => const ContactForm()))
                  .then((value) => setState(() {}));
            },
            child: const Icon(Icons.add)));
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;

  const _ContactItem(this.contact);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Text(contact.name, style: const TextStyle(fontSize: 24.0)),
      subtitle: Text(contact.accountNumber.toString(),
          style: const TextStyle(fontSize: 16.0)),
    ));
  }
}
