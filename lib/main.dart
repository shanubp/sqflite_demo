import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_demo/firebase_notification/service/notification_service.dart';

import 'firebase_options.dart';
import 'functions/db_functions.dart';
import 'functions/model/student_model.dart';
import 'inner_join/function/function.dart';
import 'inner_join/screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.instance.initialize();
  await openMyDatabase();
  // await openMyCCDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StudentsList(),
      // home:  CountryCapitalScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: age,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder()),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    final student = StudentModel(
                      name: name.text,
                      age: age.text,
                    );
                    addStudent(student);
                    name.clear();
                    age.clear();
                    Navigator.pop(context);
                  },
                  child: Text('ADD')),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentsList extends StatefulWidget {
  const StudentsList({Key? key}) : super(key: key);

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  List<StudentModel> students = [];
  bool isLoading = false;
  int limit = 3;
  int offset = 0;
  final ScrollController _scrollController = ScrollController();

  Future<void> fetchStudents() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    List<StudentModel> newStudent =
        await getAllStudents(limit: limit, offset: 0);
    setState(() {
      students = newStudent;
      isLoading = false;
    });
  }

  void _scrollListener() {
    log("Called out");
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        setState(() {
          isLoading = true;
        });
        offset++;
        getPaginatedData(limit: limit, page: offset).then((data) {
          setState(() {
            students.addAll(data);
            isLoading = false;
          });
        });

        log("Called");
      }
    }
  }

  @override
  void initState() {
    fetchStudents();

    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
            child: Text('ADD')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              students.isEmpty && !isLoading
                  ? Center(child: Text("No students found"))
                  : SizedBox(
                      height: limit * 70.0,
                      child: Container(
                          // height: 200,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: CustomScrollView(
                            controller: _scrollController,
                            slivers: [
                              SliverList.builder(
                                itemBuilder: (context, index) {
                                  if (index >= students.length) {
                                    return isLoading
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : SizedBox();
                                  }
                                  final data = students[index];
                                  return ListTile(
                                    title: Text('name- ${data.name}'),
                                    subtitle: Text('age- ${data.age}'),
                                  );
                                },
                                itemCount: students.length,
                              )
                            ],
                          )),
                    )
            ],
          ),
        ),
      ),

      // Container(
      //   height: 200,
      //   child: CustomScrollView(
      //     controller: _scrollController,
      //     slivers: [
      //       SliverList.builder(
      //         itemBuilder: (context, index) {
      //           if (index >= students.length) {
      //             return isLoading
      //                 ? Center(child: CircularProgressIndicator())
      //                 : SizedBox();
      //           }
      //           final data = students[index];
      //           return ListTile(
      //             title: Text('name- ${data.name}'),
      //             subtitle: Text('age- ${data.age}'),
      //           );
      //         },
      //         itemCount: students.length,
      //       ),
      //       // Padding(
      //       //   padding: const EdgeInsets.all(8.0),
      //       //   child: SingleChildScrollView(
      //       //     controller: _scrollController,
      //       //     child: Column(
      //       //       mainAxisAlignment: MainAxisAlignment.center,
      //       //       children: [
      //       //         students.isEmpty && !isLoading
      //       //             ? Center(child: Text("No students found"))
      //       //             : Container(
      //       //                 // height: 400,
      //       //                 decoration: BoxDecoration(
      //       //                     border: Border.all(color: Colors.black)),
      //       //                 child: ListView.builder(
      //       //                   shrinkWrap: true,
      //
      //       //                   // itemCount: students.isEmpty ? 0 : students.length + (isLoading ? 1 : 0),
      //       //                 ),
      //       //               )
      //       //       ],
      //       //     ),
      //       //   ),
      //       // ),
      //     ],
      //   ),
      // ),
    );
  }
}
