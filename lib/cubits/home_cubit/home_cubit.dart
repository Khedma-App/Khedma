import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:khedma/models/service_item.dart';
import 'package:khedma/screens/messages_screens/messages_layout_screen.dart';
import 'package:khedma/screens/more_screen.dart';
import 'package:khedma/screens/search_screen.dart';
import 'home_states.dart';
import '../../screens/home_screen.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 3;
  List<Widget> screens = [
    MoreScreen(),
    MessagesLayoutScreen(),
    SearchScreen(),
    HomeScreen(),
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(HomeChangeBottomNavState());
  }

  // ─── Search ─────────────────────────────────────────────────────────────────

  String searchQuery = '';

  void setSearchQuery(String query) {
    searchQuery = query;
    filterServices(query);
    emit(SearchFilteredState());
  }

  void filterByProfession(String profession) {
    filteredServices = allServices
        .where((service) => service.title == profession)
        .toList();
    emit(SearchFilteredState());
  }

  List<ServiceModel> filteredServices = List.from(allServices);

  void filterServices(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      filteredServices = List.from(allServices);
    } else {
      filteredServices = allServices.where((service) {
        return service.title.toLowerCase().contains(q);
      }).toList();
    }
    emit(SearchFilteredState());
  }

  // ─── Location ───────────────────────────────────────────────────────────────

  String currentLocation = 'جاري التحديد...';
  bool _locationFetched = false;

  /// Fetches the device's GPS location and reverse-geocodes it.
  /// Idempotent — subsequent calls are no-ops.
  Future<void> fetchLocation() async {
    if (_locationFetched) return;
    _locationFetched = true;

    try {
      // 1. Check if GPS service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        currentLocation = 'الـ GPS مغلق';
        if (!isClosed) emit(HomeLocationUpdatedState());
        return;
      }

      // 2. Check / request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          currentLocation = 'صلاحية مرفوضة';
          if (!isClosed) emit(HomeLocationUpdatedState());
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        currentLocation = 'صلاحية مرفوضة دائماً';
        if (!isClosed) emit(HomeLocationUpdatedState());
        return;
      }

      // 3. Get precise coordinates
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4. Reverse-geocode to area name
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        currentLocation = place.administrativeArea ??
            place.locality ??
            'منطقة غير معروفة';
      }

      if (!isClosed) emit(HomeLocationUpdatedState());
    } catch (_) {
      currentLocation = 'غير معروف';
      if (!isClosed) emit(HomeLocationUpdatedState());
    }
  }
}

// القائمة الأساسية للخدمات
final List<ServiceModel> allServices = [
  ServiceModel(title: "نقاش", imagePath: "assets/icons/النقاشه.png", count: "0"),
  ServiceModel(title: "سباك", imagePath: "assets/icons/السباكه.png", count: "0"),
  ServiceModel(title: "كهربائي", imagePath: "assets/icons/الكهرباء.png", count: "0"),
  ServiceModel(title: "نجار", imagePath: "assets/icons/النجاره.png", count: "0"),
  ServiceModel(title: "حداد", imagePath: "assets/icons/الحداده.png", count: "0"),
];