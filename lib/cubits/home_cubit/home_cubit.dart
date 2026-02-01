import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/models/service_item.dart';
import 'package:khedma/screens/search_screen.dart';
import 'package:khedma/screens/service_sections_screen_dart';
import 'home_states.dart';
import '../../screens/home_screen.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 3;

  List<Widget> screens = [
    const HomeScreen(),
    const ServiceSectionsScreen(),
    const SearchScreen(),
    const HomeScreen(),
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(HomeChangeBottomNavState());
  }

  // قائمة اللي هتتعرض وتتفلتر
  List<ServiceModel> filteredServices = List.from(allServices);

  void filterServices(String query) {
    if (query.isEmpty) {
      filteredServices = List.from(allServices);
    } else {
      filteredServices = allServices
          .where((service) => service.title.contains(query))
          .toList();
    }
    emit(SearchFilteredState());
  }
}

// القائمة الأساسية بدون ID
final List<ServiceModel> allServices = [
  ServiceModel(
    title: "أعطال الإطارات",
    imagePath: "assets/icons/اعطال الاطارات.png",
    count: "3",
  ),
  ServiceModel(
    title: "الباركية",
    imagePath: "assets/icons/الباركيه.png",
    count: "7",
  ),
  ServiceModel(
    title: "البناء",
    imagePath: "assets/icons/البناء.png",
    count: "12",
  ),
  ServiceModel(
    title: "التشطيبات",
    imagePath: "assets/icons/التشطيبات.png",
    count: "5",
  ),
  ServiceModel(
    title: "التنجيد",
    imagePath: "assets/icons/التنجيد.png",
    count: "10",
  ),
  ServiceModel(
    title: "الحدادة",
    imagePath: "assets/icons/الحداده.png",
    count: "6",
  ),
  ServiceModel(
    title: "الزجاج",
    imagePath: "assets/icons/الزجاج.png",
    count: "2",
  ),
  ServiceModel(
    title: "السباكة",
    imagePath: "assets/icons/السباكه.png",
    count: "6",
  ),
  ServiceModel(
    title: "السيراميك",
    imagePath: "assets/icons/السيراميك.png",
    count: "15",
  ),
  ServiceModel(
    title: "الكهرباء",
    imagePath: "assets/icons/الكهرباء.png",
    count: "8",
  ),
  ServiceModel(
    title: "المحارة",
    imagePath: "assets/icons/المحاره.png",
    count: "11",
  ),
  ServiceModel(
    title: "المقاولات",
    imagePath: "assets/icons/المقاولات.png",
    count: "2",
  ),
  ServiceModel(
    title: "الميكانيكا",
    imagePath: "assets/icons/الميكانكيا.png",
    count: "8",
  ),
  ServiceModel(
    title: "النجارة",
    imagePath: "assets/icons/النجاره.png",
    count: "7",
  ),
  ServiceModel(
    title: "النقاشة",
    imagePath: "assets/icons/النقاشه.png",
    count: "4",
  ),
  ServiceModel(
    title: "جبس وديكور",
    imagePath: "assets/icons/جبس وديكور.png",
    count: "7",
  ),
  ServiceModel(
    title: "دوكو وسمكرة",
    imagePath: "assets/icons/دوكو وسمكره.png",
    count: "5",
  ),
  ServiceModel(
    title: "صيانة الأجهزة المنزلية",
    imagePath: "assets/icons/صيانه الاجهزه المنزليه.png",
    count: "20",
  ),
  ServiceModel(title: "عامل", imagePath: "assets/icons/عامل.png", count: "9"),
  ServiceModel(
    title: "غسيل السيارات",
    imagePath: "assets/icons/غسيل السيارت.png",
    count: "14",
  ),
  ServiceModel(
    title: "فحص السيارات",
    imagePath: "assets/icons/فحص السيارات.png",
    count: "3",
  ),
  ServiceModel(
    title: "كهرباء السيارات",
    imagePath: "assets/icons/كهرباء السيارات.png",
    count: "6",
  ),
  ServiceModel(
    title: "ميكانيكي موتوسيكل",
    imagePath: "assets/icons/ميكانيكي موتوسيكل.png",
    count: "4",
  ),
];
