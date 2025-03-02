import 'package:african_countries/models/country_list_model.dart';
import 'package:african_countries/models/country_model.dart';
import 'package:african_countries/utils/endpoints.dart';
import 'package:african_countries/utils/network_request_helper/dio_base.dart';
import 'package:african_countries/utils/network_request_helper/request_model.dart';

class AppRepository {
  Future<AppHttpResponse> getAfricanCountries() async {
    AppHttpResponse response = await AppNetworkRequest.makeRequest(
      Endpoints.getAfricanCountries,
    );

    if (response is SuccessResponse) {
      return response.withConverter((res) {
        final countries =
            (res as List).map((e) => CountryModel.fromJson(e)).toList();

        return countries;
      });
    }

    return response;
  }

  Future<AppHttpResponse> getSingleCountry(String countryName) async {
    AppHttpResponse response = await AppNetworkRequest.makeRequest(
      '${Endpoints.getSingleCountry}/$countryName',
    );

    if (response is SuccessResponse) {
      return response.withConverter((res) {
        final country = (res as List)
            .map((e) => SingleCountryModel.fromJson(e))
            .firstOrNull;

        return country;
      });
    }

    return response;
  }
}
