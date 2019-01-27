//import 'dart:async';
//import 'dart:convert';
//import 'dart:io';
////import 'package:TruckSolution/';
//import 'package:path/path.dart';
//
//import 'package:path_provider/path_provider.dart';
//import 'package:sqflite/sqflite.dart';
//
//class DBProvider {
//  //Private constructor, so only this class can create a single instance of itself resulting in a singleton
//  DBProvider._();
//
//  //public variable our main will use to access database functions
//  static final DBProvider provider = DBProvider._();
//
//  static Database _database;
//
//  Future<Database> get database async {
//    if (_database != null)
//      return _database;
//
//    // if _database is null we instantiate it
//    _database = await initDB();
//    return _database;
//  }
//
//
//  initDB() async {
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    String path = join(documentsDirectory.path, "TestDB.db");
//    return await openDatabase(path, version: 1, onOpen: (db) {},
//        onCreate: (Database db, int version) async {
//          await db.execute("CREATE TABLE Habits ("
//                "id INTEGER PRIMARY KEY,"
//                "good TEXT,"
//                "bad TEXT"
//              ")");
//        });
//  }
//
//  //if returns null, habit already exist and cannot create a new one
//  _newHabits() async {
//    final db = await database;
//    //get the biggest id in the table
//    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Habits");
//    int id = table.first["id"];
//    if (id != null)
//      if (id >= 1) return null;
//
//    //insert to the table using the new id
//    var raw = await db.rawInsert(
//        "INSERT Into Habits (id,good,bad)"
//            " VALUES (?,?,?)",
//        [id, "[]", "[]"]);
//    return raw;
//  }
//
//  Future <List<List<Habit>>> getHabits() async {
//    final db = await database;
//    //get the biggest id in the table
//    var table = await db.rawQuery("SELECT MAX(id) as id FROM Habits");
//    int id = table.first["id"];
//
//    if (id == null) {
//      await _newHabits();
//      return getHabits();
//    }
//
//    var res = await db.query("Habits", where: "id = ?", whereArgs: [id]);
//
//    List<Habit> good = _habitListFromJson(res.first["good"]);
//    List<Habit> bad = _habitListFromJson(res.first["bad"]);
//
//    return [good, bad];
//  }
//
//  Future<bool> updateHabits(List<List<Habit>> newHabits) async {
//    final db = await database;
//
//    List<Habit> good = newHabits[0];
//    List<Habit> bad = newHabits[1];
//
//    Map <String, dynamic> map = {"good": _habitListToJson(good), "bad":_habitListToJson(bad)};
//
//    var res = await db.update("Habits", map,
//        where: "id = 1");//, whereArgs: [newClient.id]);
//
//    return true;
//  }
//
//
//}
//
//String _habitListToJson(List<Habit> habits) {
//  List<String> strings = new List();
//  for (Habit habit in habits)
//    strings.add(habit.toJson());
//  return jsonEncode(strings);
//}
//
//
//List<Habit> _habitListFromJson(String json) {
//  List<Habit> habits = new List();
//  List<dynamic> dynamicList = jsonDecode(json);
//  for (String habitJson in dynamicList)
//    habits.add(Habit.fromJson(habitJson));
//  return habits;
//}