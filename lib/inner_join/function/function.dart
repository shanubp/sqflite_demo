import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_demo/inner_join/model/capital_model.dart';
import 'package:sqflite_demo/inner_join/model/country_model.dart';


late Database _database;

Future<void> openMyCCDatabase()async {
  _database = await openDatabase(
    'capital.db',
    version: 1,
    onCreate: (db, version) async {
      await db.execute(''
          'CREATE TABLE country(countryCode TEXT PRIMARY KEY,countryName TEXT)');

      await db.execute(
          'CREATE TABLE capital ('
              'capitalId INTEGER PRIMARY KEY, '
              'capitalName TEXT NOT NULL, '
              'countryCode TEXT NOT NULL, '
              'FOREIGN KEY (countryCode) REFERENCES country (countryCode) ON DELETE CASCADE'
              ')'
      );

    },
  );
}

Future<void> addCountry(CountryModel model)async {
  _database.rawInsert(
      'INSERT INTO country (countryCode,countryName) VALUES (?,?)',
      [model.countryCode,model.countryName]
  );
  getAllCountry();
}

Future<List<CountryModel>> getAllCountry() async {
  final value = await _database.rawQuery('SELECT * FROM country');
  print(value);

  List<CountryModel> country = value.map((e) =>
      CountryModel.fromMap(e),).toList();
  return country;
}

Future<void> addCapital(CapitalModel model)async {
  await _database.rawInsert(
      'INSERT INTO capital (countryCode,capitalName) VALUES (?,?)',
      [model.countryCode,model.capitalName]
  );
  getAllCapital();
}

Future<List<CapitalModel>> getAllCapital() async {
  final value = await _database.rawQuery('SELECT * FROM capital');
  print(value);

  List<CapitalModel> capital = value.map((e) =>
      CapitalModel.fromMap(e),).toList();
  return capital;
}


Future<List<Map<String,dynamic>>> getCountryCapitalData() async{
  return await _database.rawQuery('SELECT * FROM country INNER JOIN capital ON country.countryCode = capital.countryCode');
}