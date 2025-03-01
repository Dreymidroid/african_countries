import 'package:african_countries/bloc/app_bloc.dart';
import 'package:african_countries/repository/app_repository.dart';
import 'package:african_countries/utils/network_request_helper/dio_base.dart';
import 'package:african_countries/views/african_countries_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppNetworkRequest.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AppRepository(),
      child: BlocProvider(
        create: (context) => AppBloc(
          context.read<AppRepository>(),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData(
            primaryColor: Colors.blue[900],
            scaffoldBackgroundColor: const Color.fromARGB(255, 2, 17, 40),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
            ),
          ),
          home: const AfricanCountriesView(),
        ),
      ),
    );
  }
}
