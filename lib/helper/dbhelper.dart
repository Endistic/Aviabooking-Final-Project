import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prampracha_app/model/user_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'ContactData.db';
  static const _databaseVersion = 1;

  //singletion class
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(
      dataDirectory.path,
      _databaseName,
    );
    return await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, int version) async {
    var sql = '''CREATE TABLE ${Contact.tblContact} (
      ${Contact.colId} INTEGER PRIMARY KEY AUTOINCREMENT, ${Contact.colemail} TEXT NOT NULL, ${Contact.colpassword} TEXT NOT NULL, ${Contact.coluId} TEXT NOT NULL)''';
    await db.execute(sql);
    print("Create Success");
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    return await db.insert(
      Contact.tblContact,
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Future<int> updateContact(Contact contact) async {
  //   Database db = await database;
  //   return await db.update(
  //     Contact.tblContact,
  //     contact.toMap(),
  //     where: '${Contact.colId}=?',
  //     whereArgs: [contact.id],
  //   );
  // }

  // Future<int> deleteContact(int id) async {
  //   Database db = await database;
  //   return await db.delete(
  //     Contact.tblContact,
  //     where: '${Contact.colId}=?',
  //     whereArgs: [id],
  //   );
  // }

  Future<List<Contact>> fetchContacts() async {
    Database db = await database;
    List<Map<String, dynamic>> contacts = await db.query(
      Contact.tblContact,
    );
    return List.generate(contacts.length, (i) {
      return Contact(
        id: contacts[i]['id'],
        uId: contacts[i]['uId'],
        email: contacts[i]['email'],
        password: contacts[i]['password'],
      );
    });
  }
}
