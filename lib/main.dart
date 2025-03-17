import 'package:flutter/material.dart';
import 'package:sqflite_demo/model/student_model.dart';

import 'functions/db_functions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await openMyDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                  ),
                  enabledBorder: OutlineInputBorder(
                  )
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: age,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                    ),
                    enabledBorder: OutlineInputBorder(
                    )
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(onPressed: (){
                final student = StudentModel(name: name.text, age: age.text,);
                addStudent(student);
                name.clear();
                age.clear();
              },
                  child: Text('ADD')),

              FutureBuilder<List<StudentModel>>(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No students found"));
                  }

                  List<StudentModel> students = snapshot.data!;
                  return ListView.separated(
                    shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final data = students[index];
                        return ListTile(
                          title: Text('name- ${data.name}'),
                          subtitle: Text('age- ${data.age}'),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: students.length);
                },
                future: getAllStudent(),

              )
            ],
          ),
        ),
      ),
    );
  }
}
