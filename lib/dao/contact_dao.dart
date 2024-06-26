import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../models/contact.dart';

class ContactDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY AUTOINCREMENT , '
      '$_name TEXT, '
      '$_accountName INTEGER)';

  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _accountName = 'account_number';

  Future<int> save(Contact contact) async {
    final Database db = await getDatabase();
    Map<String, dynamic> contactMap = _toMap(contact);
    return db.insert(_tableName, contactMap);
  }

  Future<List<Contact>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Contact> contacts = _toList(result);
    return contacts;
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = {};
    contactMap[_name] = contact.name;
    contactMap[_accountName] = contact.accountNumber;
    return contactMap;
  }

  List<Contact> _toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = List.empty(growable: true);
    for (Map<String, dynamic> row in result) {
      final Contact contact = Contact(row[_id], row[_name], row[_accountName]);
      contacts.add(contact);
    }
    return contacts;
  }
}
