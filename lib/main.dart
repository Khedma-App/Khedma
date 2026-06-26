import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/cubits/home_cubit/home_cubit.dart';
import 'package:khedma/cubits/providers_cubit/providers_cubit.dart';
import 'package:khedma/firebase_options.dart';
import 'package:khedma/screens/auth_screens/auth_screen.dart';
import 'package:khedma/screens/auth_screens/auth_wrapper.dart';
import 'package:khedma/screens/auth_screens/recovery_flow.dart';
import 'package:khedma/screens/auth_screens/service_provider_register_screen.dart';
import 'package:khedma/screens/auth_screens/service_provider_screen.dart';
import 'package:khedma/screens/auth_screens/service_requester_register_screen.dart';
import 'package:khedma/screens/auth_screens/welcome_screen.dart';
import 'package:khedma/screens/edit_profile_screen.dart';
import 'package:khedma/screens/main_layout_screen.dart';
import 'package:khedma/screens/order_history_screen.dart';
import 'package:khedma/screens/profile_screen.dart';
import 'package:khedma/screens/profile_update_screen.dart';
import 'package:khedma/screens/requests_factor_screen.dart';
import 'package:khedma/screens/search_screen.dart';
import 'package:khedma/screens/service_sections_screen.dart';
import 'package:khedma/services/provider_service.dart';
import 'package:khedma/screens/service_contract_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:khedma/services/notification_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    NotificationService.initialize().catchError((e) {
      debugPrint('Notification init error: $e');
    });
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool seenWelcome = prefs.getBool('seenWelcome') ?? false;

  // StorageService storageService = StorageService();

  // runApp(MyApp());
  runApp(MyApp(seenWelcome: seenWelcome));

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool seenWelcome;

  const MyApp({super.key, required this.seenWelcome});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(
          create: (context) =>
              ProvidersCubit(providerService: ProviderService()),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'cairo'),
        debugShowCheckedModeBanner: false,

        home: Builder(
          builder: (context) {
            initScreenSize(context);

            return seenWelcome ? const AuthWrapper() : WelcomeScreen();
          },
        ),

        routes: {
          ServiceProviderScreen.id: (context) => ServiceProviderScreen(),
          MainLayoutScreen.id: (context) => MainLayoutScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          AuthScreen.id: (context) => const AuthScreen(),
          ServiceProviderRegisterScreen.id: (context) =>
              ServiceProviderRegisterScreen(),
          ServiceRequesterRegisterScreen.id: (context) =>
              ServiceRequesterRegisterScreen(),
          RecoveryFlow.id: (context) => RecoveryFlow(),
          SearchScreen.id: (context) => SearchScreen(),
          ServiceSectionsScreen.id: (context) => ServiceSectionsScreen(),
          OrderHistoryScreen.id: (context) => OrderHistoryScreen(),
          ProfileScreen.id: (context) => ProfileScreen(),
          EditProfileScreen.id: (context) => EditProfileScreen(),
          ProfileUpdateScreen.id: (context) => ProfileUpdateScreen(),
          RequestsFactorScreen.id: (context) => RequestsFactorScreen(),
          ServiceContractScreen.id: (context) => ServiceContractScreen(),
        },
      ),
    );
  }
}
