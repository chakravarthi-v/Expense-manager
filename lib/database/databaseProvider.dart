import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction.dart';
import 'package:try_app/models/transaction.dart' as tran;
import 'package:try_app/main.dart' as main;
class DatabaseProvider{
  DatabaseProvider._();
  static final DatabaseProvider db=DatabaseProvider._();
  static Database _database;
  //checking whether a SQLite database exists or not,if no then we're initializing a new one
  Future<Database> get dataBase async{
    if(_database!=null){
      return _database;
    }
    _database=await initDB();
    return _database;
  }
  //initialization takes place here
  initDB() async{
    Directory documentsDirectory=await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path,version:1,onOpen: (db){},
    onCreate: (db, version) async {
      await db.execute("CREATE TABLE Trap ("
          "id INTEGER PRIMARY KEY,"
          "ids TEXT,"
          "title TEXT,"
          "amount REAL,"
          "date TEXT"
          ")");
    },);
  }
  //adding persons to database
  addTranasactionToDatabase(tran.Transaction trans) async{
    print('reached');
    final db=await dataBase;
    var raw=await db.insert("Trap",trans.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }
  //deleting persons to database
  deleteTransaction(String id)async {
    final db=await dataBase;
    db.delete("Trap",where:"ids = ?",whereArgs: [id]);
  }
  //getting all transaction from the database
  Future<List<tran.Transaction>>getAllTransaction() async {
    final db=await dataBase;
    var response =await db.query("Trap");
    List<tran.Transaction> list=response.map((e) => tran.Transaction.fromMap(e)).toList();
    return list;
  }


}
