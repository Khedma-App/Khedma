import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/components/home_header.dart';
import 'package:khedma/components/service_provider_card.dart';
import 'package:khedma/components/trusted_workers_banner.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/cubits/home_cubit/home_cubit.dart';
import 'package:khedma/cubits/home_cubit/home_states.dart';
import 'package:khedma/cubits/providers_cubit/providers_cubit.dart';
import 'package:khedma/cubits/providers_cubit/providers_states.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fire-and-forget: cubits handle all async logic internally.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProvidersCubit>().init();
      context.read<HomeCubit>().fetchLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Top Header (branding, location, search) ──
          BlocBuilder<HomeCubit, HomeStates>(
            buildWhen: (_, curr) => curr is HomeLocationUpdatedState,
            builder: (context, _) {
              return HomeHeader(
                currentLocation: HomeCubit.get(context).currentLocation,
              );
            },
          ),
          SizedBox(height: kHeight(15)),

          // ── Scrollable Content ──
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: kWidth(25)),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Ad banner
                    Image.asset('assets/images/jotun_ads.jpg'),
                    SizedBox(height: kHeight(15)),

                    // "عمال ذات ثقة" banner
                    const TrustedWorkersBanner(),
                    SizedBox(height: kHeight(15)),

                    // Section title "الاقرب لك"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'الاقرب لك',
                          style: TextStyle(
                            fontSize: kSize(20),
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: kHeight(15)),

                    // ── Provider List (reactive via ProvidersCubit) ──
                    BlocBuilder<ProvidersCubit, ProvidersStates>(
                      builder: (context, state) {
                        if (state is ProvidersLoadingState ||
                            state is ProvidersInitialState) {
                          return Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: kHeight(20)),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                              ),
                            ),
                          );
                        }

                        if (state is ProvidersErrorState) {
                          return Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: kHeight(20)),
                            child: Center(
                              child: Text(
                                state.message,
                                style: TextStyle(
                                  fontSize: kSize(16),
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }

                        if (state is ProvidersLoadedState) {
                          if (state.providers.isEmpty) {
                            return Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: kHeight(20)),
                              child: Center(
                                child: Text(
                                  'لا يوجد مقدمي خدمة في الوقت الحالي',
                                  style: TextStyle(
                                    fontSize: kSize(16),
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }

                          final isClient =
                              ProvidersCubit.get(context).isClient;

                          return ListView.builder(
                            itemCount: state.providers.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: ServiceProviderCard(
                                  worker: state.providers[index],
                                  isClient: isClient,
                                ),
                              );
                            },
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                    SizedBox(height: kHeight(30)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
