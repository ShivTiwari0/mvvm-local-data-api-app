import 'dart:async';
import 'package:geekrabit_project/model/employe_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'employees.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE employees( id INTEGER PRIMARY KEY,employee_name TEXT NOT NULL,employee_salary INTEGER NOT NULL,employee_age INTEGER NOT NULL,profile_image TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<List<Data>> retrieveEmployees() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('employees');
    return List.generate(maps.length, (i) {
      print('map:::::::::${maps[i]['employee_salary']}');
      return Data(
        id: maps[i]['id'],
        employeeName: maps[i]['employee_name'],
        employeeSalary: maps[i]['employee_salary'],
        employeeAge: maps[i]['employee_age'],
        profileImage: maps[i]['profile_image'],
      );
    });
  }

  Future<List<Data>> insertEmployees(List<Data> employees) async {
    final Database db = await database;
    await db.transaction((txn) async {
      for (final employee in employees) {
        print('database:::::::::${employee.employeeName}');
        await txn.insert(
          'employees',
          employee.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
    return employees;
  }

  Future<int> updateEmployee(Data employee) async {
    final Database db = await database;
    return await db.update(
      'employees',
      employee.toJson(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    final Database db = await database;
    return await db.delete(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
