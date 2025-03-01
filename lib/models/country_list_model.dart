import 'package:african_countries/models/country_model.dart';

class CountryModel {
  final Flags flags;
  final Name name;
  final List<String> capital;
  final Map<String, String> languages;

  CountryModel({
    required this.flags,
    required this.name,
    required this.capital,
    required this.languages,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      flags: Flags.fromJson(json['flags']),
      name: Name.fromJson(json['name']),
      capital: List<String>.from(json['capital']),
      languages: Map<String, String>.from(json['languages']),
    );
  }
}
