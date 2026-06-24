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

import 'package:khedma/models/service_provider_model.dart';
import 'package:khedma/models/service_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<ServiceProviderModel> _sortProvidersByLocation({
    required List<ServiceProviderModel> providers,
    required String rawLocation,
  }) {
    if (rawLocation.isEmpty ||
        rawLocation == 'جاري التحديد...' ||
        rawLocation == 'غير معروف' ||
        rawLocation == 'الـ GPS مغلق' ||
        rawLocation == 'صلاحية مرفوضة' ||
        rawLocation == 'صلاحية مرفوضة دائماً') {
      // Default fallback: sort by rating then completed orders
      final list = List<ServiceProviderModel>.from(providers);
      list.sort((a, b) {
        int cmp = b.rating.compareTo(a.rating);
        if (cmp != 0) return cmp;
        return b.completedOrders.compareTo(a.completedOrders);
      });
      return list;
    }

    final cleanLocation = rawLocation.toLowerCase();
    String matchedGov = '';
    String matchedCity = '';

    // 1. Try matching city in EgyptData.egyptData
    for (final entry in EgyptData.egyptData.entries) {
      final gov = entry.key;
      final cities = entry.value;
      for (final city in cities) {
        final lowerCity = city.toLowerCase();
        if (cleanLocation.contains(lowerCity) ||
            (city == "مدينة نصر" && (cleanLocation.contains("nasr") || cleanLocation.contains("نصر"))) ||
            (city == "مصر الجديدة" && (cleanLocation.contains("heliopolis") || cleanLocation.contains("مصر جديدة"))) ||
            (city == "المعادي" && (cleanLocation.contains("maadi") || cleanLocation.contains("معادي"))) ||
            (city == "6 أكتوبر" && (cleanLocation.contains("october") || cleanLocation.contains("أكتوبر"))) ||
            (city == "الشيخ زايد" && (cleanLocation.contains("zayed") || cleanLocation.contains("زايد"))) ||
            (city == "الدقي" && (cleanLocation.contains("dokki") || cleanLocation.contains("دقي"))) ||
            (city == "شبرا" && (cleanLocation.contains("shobra") || cleanLocation.contains("شبرا")))) {
          matchedGov = gov;
          matchedCity = city;
          break;
        }
      }
      if (matchedGov.isNotEmpty) break;
    }

    // 2. Try matching governorate directly
    if (matchedGov.isEmpty) {
      final Map<String, String> govMap = {
        'cairo': 'القاهرة', 'قاهرة': 'القاهرة',
        'giza': 'الجيزة', 'جيزة': 'الجيزة',
        'alexandria': 'الإسكندرية', 'اسكندرية': 'الإسكندرية', 'إسكندرية': 'الإسكندرية',
        'dakahlia': 'الدقهلية', 'دقهلية': 'الدقهلية',
        'sharqia': 'الشرقية', 'شرقية': 'الشرقية',
        'gharbia': 'الغربية', 'غربية': 'الغربية',
        'monufia': 'المنوفية', 'منوفية': 'المنوفية',
        'qalyubia': 'القليوبية', 'قليوبية': 'القليوبية',
        'beheira': 'البحيرة', 'بحيرة': 'البحيرة',
        'kafr': 'كفر الشيخ', 'كفر الشيخ': 'كفر الشيخ',
        'fayoum': 'الفيوم', 'فيوم': 'الفيوم',
        'beni suef': 'بني سويف', 'بني سويف': 'بني سويف',
        'minya': 'المنيا', 'منيا': 'المنيا',
        'asyut': 'أسيوط', 'أسيوط': 'أسيوط',
        'sohag': 'سوهاج', 'سوهاج': 'سوهاج',
        'qena': 'قنا', 'قنا': 'قنا',
        'luxor': 'الأقصر', 'أقصر': 'الأقصر',
        'aswan': 'أسوان', 'أسوان': 'أسوان',
        'red sea': 'البحر الأحمر', 'البحر الأحمر': 'البحر الأحمر',
        'new valley': 'الوادي الجديد', 'الوادي الجديد': 'الوادي الجديد',
        'matrouh': 'مطروح', 'مطروح': 'مطروح',
        'sinai': 'شمال سيناء', 'سيناء': 'شمال سيناء',
        'ismailia': 'الإسماعيلية', 'إسماعيلية': 'الإسماعيلية',
        'suez': 'السويس', 'سويس': 'السويس',
        'port said': 'بورسعيد', 'بورسعيد': 'بورسعيد',
        'damietta': 'دمياط', 'دمياط': 'دمياط',
      };

      for (final key in govMap.keys) {
        if (cleanLocation.contains(key)) {
          matchedGov = govMap[key]!;
          break;
        }
      }
    }

    final sortedList = List<ServiceProviderModel>.from(providers);

    sortedList.sort((a, b) {
      int getScore(ServiceProviderModel p) {
        if (matchedGov.isNotEmpty) {
          if (p.governorate == matchedGov) {
            if (matchedCity.isNotEmpty && p.city == matchedCity) {
              return 0; // Same city & governorate
            }
            return 1; // Same governorate, different city
          }
        }
        if (p.canWorkOutsideGovernorate) {
          return 2; // Different governorate, but willing to travel
        }
        return 3; // Different governorate, unwilling to travel
      }

      final scoreA = getScore(a);
      final scoreB = getScore(b);

      if (scoreA != scoreB) {
        return scoreA.compareTo(scoreB);
      }

      // Tie-breaker 1: Rating (higher first)
      int ratingCmp = b.rating.compareTo(a.rating);
      if (ratingCmp != 0) return ratingCmp;

      // Tie-breaker 2: Completed orders (higher first)
      return b.completedOrders.compareTo(a.completedOrders);
    });

    return sortedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
         
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

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: TrustedWorkersBanner(),
                    ),
                    SizedBox(height: kHeight(15)),

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
                      child: BlocBuilder<HomeCubit, HomeStates>(
                        buildWhen: (_, curr) => curr is HomeLocationUpdatedState,
                        builder: (context, homeState) {
                          final rawLocation = HomeCubit.get(context).currentLocation;
                          
                          return BlocBuilder<ProvidersCubit, ProvidersStates>(
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
                                final sortedProviders = _sortProvidersByLocation(
                                  providers: state.providers,
                                  rawLocation: rawLocation,
                                );

                                return ListView.builder(
                                  itemCount: sortedProviders.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 15.0),
                                      child: ServiceProviderCard(
                                        worker: sortedProviders[index],
                                        isClient: isClient,
                                      ),
                                    );
                                  },
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          );
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
