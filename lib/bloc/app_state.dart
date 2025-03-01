import 'package:african_countries/models/country_list_model.dart';
import 'package:african_countries/models/country_model.dart';

class AppState {
  final bool isLoading;
  final List<CountryModel> countries;
  final SingleCountryModel? country;

  const AppState({
    this.isLoading = false,
    this.countries = const [],
    this.country,
  });

  copyWith({
    bool? isLoading,
    List<CountryModel>? countries,
    SingleCountryModel? country,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      countries: countries ?? this.countries,
      country: country ?? this.country,
    );
  }
}
