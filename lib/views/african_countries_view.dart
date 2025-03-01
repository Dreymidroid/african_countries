import 'package:african_countries/bloc/app_bloc.dart';
import 'package:african_countries/bloc/app_event.dart';
import 'package:african_countries/bloc/app_state.dart';
import 'package:african_countries/views/single_country_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AfricanCountriesView extends StatefulWidget {
  const AfricanCountriesView({super.key});

  @override
  State<AfricanCountriesView> createState() => _AfricanCountriesViewState();
}

class _AfricanCountriesViewState extends State<AfricanCountriesView> {
  @override
  void initState() {
    super.initState();
    context.read<AppBloc>().add(GetAfricanCountriesEvent(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white.withOpacity(.6),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('African Countries', style: TextStyle(color: Colors.white),),
      ),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return state.isLoading
              ? const Center(
                  child: LinearProgressIndicator(),
                )
              : state.countries.isEmpty
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No countries found'),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<AppBloc>()
                                  .add(GetAfricanCountriesEvent(context));
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          state.countries.length,
                          (index) => ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => SingleCountryView(
                                  countryName:
                                      state.countries[index].name.official,
                                ),
                              ));
                            },
                            leading: Image.network(
                              state.countries[index].flags.png,
                              height: 20,
                              width: 20,
                            ),
                            title: Text(
                              state.countries[index].name.common,
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 12),
                          ),
                        ),
                      ),
                    );
        },
      ),
    );
  }
}
