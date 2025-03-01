import 'package:flutter/material.dart' show BuildContext;

abstract class AppEvent {
  const AppEvent();
}

class GetAfricanCountriesEvent extends AppEvent {
  final BuildContext context;
  const GetAfricanCountriesEvent(this.context);
}

class GetSingleCountryEvent extends AppEvent {
  final BuildContext context;

  final String countryName;
  const GetSingleCountryEvent(
    this.context, {
    required this.countryName,
  });
}

class CancelLoadingEvent extends AppEvent {
  const CancelLoadingEvent();
}