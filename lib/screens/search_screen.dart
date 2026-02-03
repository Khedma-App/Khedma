import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/components/custom_search_app_bar.dart';
import 'package:khedma/components/custom_service_item.dart';
import 'package:khedma/cubits/home_cubit/home_cubit.dart';
import 'package:khedma/cubits/home_cubit/home_states.dart';
import 'package:khedma/core/constants.dart';

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
        var list = cubit.filteredServices;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kHeight(150)),
            child: CustomSearchAppBar(
              onChanged: (value) => cubit.filterServices(value),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
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
                    child: list.isEmpty
                        ? const Center(child: Text("لا توجد نتائج بحث مطابقة"))
                        : ListView.builder(
                            itemCount: list.length,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              vertical: kHeight(10),
                            ),
                            itemBuilder: (context, index) {
                              return ServiceItem(service: list[index]);
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
