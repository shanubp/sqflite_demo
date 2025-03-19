import 'package:sqflite_demo/functions/model/student_model.dart';

class CapitalModel{
  final String capitalName;
  final int? capitalId;
  final String countryCode;

  CapitalModel({
    required this.capitalName,
     this.capitalId,
    required this.countryCode
});

  factory CapitalModel.fromMap(Map<String,dynamic> json){
    return(
    CapitalModel(capitalName: json['capitalName'], capitalId: json['capitalId'],
        countryCode: json['countryCode'])
    );
  }

  Map<String,dynamic>toMap(){
    return{
      'capitalName': this.capitalName,
      'capitalId': capitalId,
      'countryCode': countryCode
    };
  }

}