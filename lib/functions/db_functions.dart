import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'model/student_model.dart';


late Database _database;

Future<void> openMyDatabase()async {
  _database = await openDatabase(
    'student.db',
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE student('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'age TEXT)');
    },
  );
}

Future<void> addStudent(StudentModel model)async {
  _database.rawInsert(
    'INSERT INTO student (name,age) VALUES (?,?)',
    [model.name,model.age]
  );
  getAllStudents();
}
//
// Future<List<StudentModel>> getAllStudent() async {
//   final value = await _database.rawQuery('SELECT * FROM student');
//   print(value);

// List<StudentModel> student = value.map((e) =>
//     StudentModel.fromMap(e),).toList();
// return student;
// }


Future<List<StudentModel>> getAllStudents({int limit = 0, int offset = 0}) async {
  final value = await _database.rawQuery('SELECT * FROM student LIMIT ? OFFSET ?', [limit, offset]);
  print(value);
  return value.map((e) => StudentModel.fromMap(e)).toList();
}