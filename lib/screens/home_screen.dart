import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/components/empty_state_widget.dart';
import 'package:khedma/components/home_header.dart';
import 'package:khedma/components/service_provider_card.dart';
import 'package:khedma/components/shimmer_loading.dart';
import 'package:khedma/components/trusted_workers_banner.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/cubits/home_cubit/home_cubit.dart';
import 'package:khedma/cubits/home_cubit/home_states.dart';
import 'package:khedma/cubits/providers_cubit/providers_cubit.dart';
import 'package:khedma/cubits/providers_cubit/providers_states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<ProvidersCubit>().retry();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: kWidth(25)),
                      child: Image.asset('assets/images/jotun_ads.jpg'),
                    ),
                    SizedBox(height: kHeight(15)),

                    // "عمال ذات ثقة" banner
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: TrustedWorkersBanner(),
                    ),
                    SizedBox(height: kHeight(15)),

                    // Section title "الاقرب لك"
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: kWidth(25)),
                      child: Row(
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
                    ),
                    SizedBox(height: kHeight(15)),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: kWidth(25)),
                      child: BlocBuilder<ProvidersCubit, ProvidersStates>(
                        builder: (context, state) {
                          if (state is ProvidersLoadingState ||
                              state is ProvidersInitialState) {
                            return ListView.builder(
                              itemCount: 3,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, __) => const ShimmerProviderCard(),
                            );
                          }

                          if (state is ProvidersErrorState) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: kHeight(20)),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      state.message,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: kSize(14),
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: kHeight(12)),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        context.read<ProvidersCubit>().retry();
                                      },
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('إعادة المحاولة'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (state is ProvidersLoadedState) {
                            if (state.providers.isEmpty) {
                              return const EmptyStateWidget(
                                icon: Icons.group_off_outlined,
                                title: 'لا يوجد مقدمي خدمة',
                                subtitle: 'لم يتم العثور على مقدمي خدمة في الوقت الحالي',
                              );
                            }

                            final isClient = ProvidersCubit.get(context).isClient;

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

                          return const SizedBox.shrink();
                        },
                      ),
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
