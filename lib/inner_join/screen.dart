import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_demo/inner_join/function/function.dart';
import 'package:sqflite_demo/inner_join/model/capital_model.dart';
import 'package:sqflite_demo/inner_join/model/country_model.dart';

class CountryCapitalScreen extends StatefulWidget {
  const CountryCapitalScreen({super.key,});
  @override
  State<CountryCapitalScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CountryCapitalScreen> {

  TextEditingController capitalName = TextEditingController();
  TextEditingController countryCode = TextEditingController();
  TextEditingController cCountryCode = TextEditingController();
  TextEditingController countryName = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: countryName,
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
                  controller: cCountryCode,
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
                ElevatedButton(onPressed: () async {
                  final country = CountryModel(countryCode: cCountryCode.text, countryName: countryName.text,);
                  addCountry(country);
                  countryName.clear();
                  cCountryCode.clear();
                },
                    child: Text('ADD')),
            
                FutureBuilder<List<CountryModel>>(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    // } else if (snapshot.hasError) {
                    //   return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No County found"));
                    }
            
                    List<CountryModel> country = snapshot.data!;
                    return ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final data = country[index];
                          return ListTile(
                            title: Text('countryName- ${data.countryName}'),
                            subtitle: Text('cCountryCode- ${data.countryCode}'),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: country.length);
                  },
                  future: getAllCountry(),
            
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: capitalName,
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
                  controller: countryCode,
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
                  final capital = CapitalModel(countryCode: countryCode.text, capitalName: capitalName.text,);
                  addCapital(capital);
                  capitalName.clear();
                  countryCode.clear();
                },
                    child: Text('ADD')),
            
                FutureBuilder<List<CapitalModel>>(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    // } else if (snapshot.hasError) {
                    //   return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No Capital found"));
                    }
            
                    List<CapitalModel> capital = snapshot.data!;
                    return ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final data = capital[index];
                          return ListTile(
                            title: Text('capitalName- ${data.capitalName}'),
                            subtitle: Text('countryCode- ${data.countryCode}'),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: capital.length);
                  },
                  future: getAllCapital(),
            
                ),
                SizedBox(
                  height: 30,
                ),
                FutureBuilder<List<Map<String,dynamic>>>(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                      // } else if (snapshot.hasError) {
                      //   return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No Country Capital found"));
                    }

                    List<Map<String,dynamic>> capital = snapshot.data!;
                    return ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final data = capital[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(data['countryCode']),
                              Text(data['countryName']),
                              Text(data['capitalId'].toString()),
                              Text(data['countryCode']),
                              Text(data['capitalName']),
                            ],
                          );
                          //   ListTile(
                          //   title: Text('capitalName- ${data.capitalName}'),
                          //   subtitle: Text('countryCode- ${data.countryCode}'),
                          // );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: capital.length);
                  },
                  future: getCountryCapitalData(),

                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}