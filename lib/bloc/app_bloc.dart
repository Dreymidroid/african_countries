import 'package:african_countries/bloc/app_event.dart';
import 'package:african_countries/bloc/app_state.dart';
import 'package:african_countries/repository/app_repository.dart';
import 'package:african_countries/utils/network_request_helper/request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AppRepository _repository;
  AppBloc(this._repository) : super(const AppState()) {
    on<GetAfricanCountriesEvent>(_getAfricanCountries);
    on<GetSingleCountryEvent>(_getSingleCountry);
    on<CancelLoadingEvent>(_cancelLoadingEvent);
  }

  void _getAfricanCountries(
      GetAfricanCountriesEvent event, Emitter<AppState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await _repository.getAfricanCountries();

    if (response is SuccessResponse) {
      emit(state.copyWith(isLoading: false, countries: response.data));
    } else {
      if (event.context.mounted) {
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(
            content: Text(response.message),
          ),
        );
      }
      emit(state.copyWith(isLoading: false));
    }
  }

  void _getSingleCountry(
      GetSingleCountryEvent event, Emitter<AppState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await _repository.getSingleCountry(event.countryName);

    if (response is SuccessResponse) {
      emit(state.copyWith(isLoading: false, country: response.data));
    } else {
      if (event.context.mounted) {
        Navigator.of(event.context).pop();
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(
            content: Text(response.message),
          ),
        );
      }
      emit(state.copyWith(isLoading: false));
    }
  }

  void _cancelLoadingEvent(
    CancelLoadingEvent event,
    Emitter<AppState> appState,
  ) async {
    emit(state.copyWith(isLoading: false));
  }
}
