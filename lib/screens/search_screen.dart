import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/components/custom_search_app_bar.dart';
import 'package:khedma/components/custom_service_item.dart';
import 'package:khedma/cubits/home_cubit/home_cubit.dart';
import 'package:khedma/cubits/home_cubit/home_states.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/service_item.dart';
import 'service_sections_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static String id = 'SearchScreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        var cubit = HomeCubit.get(context);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kHeight(150)),
            child: CustomSearchAppBar(
              onChanged: (value) {
                cubit.setSearchQuery(value.trim());
              },
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('professions_stats')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Center(child: CircularProgressIndicator());

              List<ServiceModel> services = snapshot.data!.docs.map((doc) {
                return ServiceModel(
                  title: doc.id,
                  imagePath: 'assets/icons/${doc.id}.png',
                  count: (doc['count'] ?? 0).toString(),
                );
              }).toList();

              final query = cubit.searchQuery.toLowerCase();
              var filtered = query.isEmpty
                  ? services
                  : services
                        .where((s) => s.title.toLowerCase().contains(query))
                        .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: kWidth(25),
                      top: kHeight(20),
                      bottom: kHeight(10),
                    ),
                    child: Text(
                      "حرف البنـاء والمعمـار",
                      style: TextStyle(
                        fontSize: kWidth(20),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: kHeight(10)),
                      itemBuilder: (context, index) {
                        final service = filtered[index];
                        return GestureDetector(
                          onTap: () {
                            // عند الضغط على المهنة، اذهب لصفحة العمال مع تمرير المهنة
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ServiceSectionsScreen(
                                  profession: service.title,
                                ),
                              ),
                            );
                          },
                          child: ServiceItem(service: service),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
