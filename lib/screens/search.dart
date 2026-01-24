import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:khedma/components/custom_search_app_bar.dart';
import 'package:khedma/components/service_item.dart';
import 'package:khedma/cubits/home_cubit/home_cubit.dart';
import 'package:khedma/cubits/home_cubit/home_states.dart';
import 'package:khedma/core/constants.dart';

class Search extends StatefulWidget {
  const Search({super.key});
  static String id = 'Sections';

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
          bottomNavigationBar: _buildGNav(cubit),
        );
      },
    );
  }

  Widget _buildGNav(HomeCubit cubit) {
    return Container(
      margin: EdgeInsets.all(kWidth(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: kWidth(10),
          vertical: kHeight(8),
        ),
        child: GNav(
          selectedIndex: cubit.currentIndex,
          onTabChange: (index) => cubit.changeBottomNav(index),
          gap: 8,
          activeColor: Colors.white,
          iconSize: 24,
          padding: EdgeInsets.symmetric(
            horizontal: kWidth(20),
            vertical: kHeight(12),
          ),
          tabBackgroundColor: Colors.orange,
          color: Colors.orange,
          tabs: const [
            GButton(icon: Icons.home, text: 'الرئيسية'),
            GButton(icon: Icons.search, text: 'بحث'),
            GButton(icon: Icons.message, text: 'محادثات'),
            GButton(icon: Icons.more_horiz, text: 'المزيد'),
          ],
        ),
      ),
    );
  }
}
