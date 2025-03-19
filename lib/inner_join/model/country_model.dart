
class CountryModel {
  final String countryName;

  final String countryCode;

  CountryModel({required this.countryName, required this.countryCode});

  factory CountryModel.fromMap(Map<String, dynamic> json) {
    return (CountryModel(
        countryName: json['countryName'], countryCode: json['countryCode']));
  }

  Map<String, dynamic> toMap() {
    return {'countryName': this.countryName, 'countryCode': countryCode};
  }
}
