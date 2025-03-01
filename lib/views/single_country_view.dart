import 'package:african_countries/bloc/app_bloc.dart';
import 'package:african_countries/bloc/app_event.dart';
import 'package:african_countries/bloc/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:gap/gap.dart';

class SingleCountryView extends StatefulWidget {
  final String countryName;
  const SingleCountryView({super.key, required this.countryName});

  @override
  State<SingleCountryView> createState() => _SingleCountryViewState();
}

class _SingleCountryViewState extends State<SingleCountryView> {
  @override
  void initState() {
    super.initState();
    context
        .read<AppBloc>()
        .add(GetSingleCountryEvent(context, countryName: widget.countryName));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __) {
        context.read<AppBloc>().add(const CancelLoadingEvent());
      },
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          shadowColor: Colors.white.withOpacity(.6),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            widget.countryName,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return state.isLoading
                ? const Center(
                    child: LinearProgressIndicator(),
                  )
                : state.country == null
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('An error occurred'),
                            ElevatedButton(
                              onPressed: () {
                                context.read<AppBloc>().add(
                                    GetSingleCountryEvent(context,
                                        countryName: widget.countryName));
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            const Gap(20),
                            FlutterCarousel(
                              options: FlutterCarouselOptions(
                                height: 200.0,
                                showIndicator: true,
                                slideIndicator: CircularStaticIndicator(
                                  slideIndicatorOptions: SlideIndicatorOptions(
                                    itemSpacing: 15,
                                    indicatorRadius: 4,
                                    enableAnimation: true,
                                    indicatorBackgroundColor: Colors.grey,
                                    currentIndicatorColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                ),
                                enlargeFactor: .25,
                                autoPlay: true,
                                floatingIndicator: true,
                                // controller: _carouselController,
                              ),
                              items: List.generate(
                                  2,
                                  (index) => Container(
                                        padding: const EdgeInsets.all(14),
                                        margin: const EdgeInsets.only(right: 8),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Image.network(
                                          index == 1
                                              ? state.country!.flags.png
                                              : state.country!.coatOfArms.png,
                                        ),
                                      )),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Gap(12),
                                    Text(
                                      state.country?.name.common ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    const Gap(16),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _tile(
                                          context,
                                          title: 'Currency',
                                          body: state
                                                  .country
                                                  ?.currencies
                                                  .entries
                                                  .firstOrNull
                                                  ?.value
                                                  .name ??
                                              '',
                                        ),
                                        _tile(
                                          context,
                                          title: 'Population',
                                          body: state.country?.population
                                                  .toString() ??
                                              'N/A',
                                        ),
                                      ],
                                    ),
                                    const Gap(8),
                                    _tile(
                                      context,
                                      title: 'Flag description',
                                      body: state.country?.flags.alt ?? '',
                                    ),
                                    const Gap(8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _tile(
                                          context,
                                          title: 'Capital',
                                          body: state.country?.capital
                                                  .firstOrNull ??
                                              '',
                                        ),
                                        _tile(
                                          context,
                                          title: 'Sub region',
                                          body: state.country?.subregion ?? '',
                                        ),
                                         _tile(
                                          context,
                                          title: 'Language',
                                          body: state.country?.languages.entries.firstOrNull?.value ?? '',
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
          },
        ),
      ),
    );
  }
}

Widget _tile(
  BuildContext context, {
  required String title,
  required String body,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromARGB(255, 12, 39, 79),
        // color: const Color(0xFF181818),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(12),
          Text(body)
        ],
      ),
    );
