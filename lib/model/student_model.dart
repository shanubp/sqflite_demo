class StudentModel{
  final String name;
  final String age;
  final int? id;

  const StudentModel({
    required this.name,
    required this.age,
     this.id,
  });


  StudentModel copyWith({
    String? name,
    String? age,
    int? id,
  }) {
    return StudentModel(
      name: name ?? this.name,
      age: age ?? this.age,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'age': this.age,
      'id': this.id,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      name: map['name'] as String,
      age: map['age'] as String,
      id: map['id'] as int,
    );
  }

}