import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/cubits/home_cubit/home_cubit.dart';
import 'package:khedma/firebase_options.dart';
import 'package:khedma/screens/auth_screens/auth_screen.dart';
import 'package:khedma/screens/auth_screens/auth_wrapper.dart';
import 'package:khedma/screens/auth_screens/recovery_flow.dart';
import 'package:khedma/screens/auth_screens/service_provider_register_screen.dart';
import 'package:khedma/screens/auth_screens/service_provider_screen.dart';
import 'package:khedma/screens/auth_screens/service_requester_register_screen.dart';
import 'package:khedma/screens/auth_screens/welcome_screen.dart';
import 'package:khedma/screens/main_layout_screen.dart';
import 'package:khedma/screens/search_screen.dart';
import 'package:khedma/screens/service_sections_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final supabase = Supabase.instance.client;

  Future<void> uploadImage() async {
    // 1. اختيار صورة من المعرض
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return; // المستخدم ألغى الاختيار

    // 2. تحويل الصورة إلى ملف (File)
    final imageFile = File(image.path);

    // 3. تحديد اسم فريد للملف لتجنب التكرار
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    // رفع الملف مباشرة في الـ Root الخاص بالباكيت
    final String path = fileName;
    try {
      // 4. عملية الرفع إلى الباكيت (اسمه 'images' مثلاً)
      await supabase.storage
          .from('Provider_images')
          .upload(
            path,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // 5. الحصول على رابط الصورة (إذا كان الباكيت Public)
      final String publicUrl = supabase.storage
          .from('Provider_images')
          .getPublicUrl(path);

      print('تم الرفع بنجاح! الرابط: $publicUrl');

      // الآن يمكنك حفظ هذا الرابط (publicUrl) في قاعدة البيانات (Table) بجانب بيانات المستخدم
    } catch (e) {
      print('خطأ أثناء الرفع: $e');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool seenWelcome = prefs.getBool('seenWelcome') ?? false;
  await Supabase.initialize(
    url: 'https://nmvxwdnbqlawzkncgbbb.supabase.co', // استبدله بـ URL مشروعك
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5tdnh3ZG5icWxhd3prbmNnYmJiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMwOTUwOTUsImV4cCI6MjA4ODY3MTA5NX0.6mmykTnyAReosiLTA0hG3CIkODhGs0lVWse3BmZkmqU', // استبدله بـ Key مشروعك
  );
  final user = Supabase.instance.client.auth.currentUser;
  print(
    '====================================================================Current User: ${user?.email}',
  );
  // StorageService storageService = StorageService();

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
    StorageService storageService = StorageService();
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => HomeCubit())],
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
          // الـ routes معطلة حالياً ومحفوظة كـ تعليق
          ServiceProviderScreen.id: (context) => ServiceProviderScreen(),
          /* MainLayoutScreen.id: (context) => MainLayoutScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          AuthScreen.id: (context) => const AuthScreen(),
          ServiceProviderRegisterScreen.id: (context) => ServiceProviderRegisterScreen(),
          ServiceRequesterRegisterScreen.id: (context) => ServiceRequesterRegisterScreen(),
          RecoveryFlow.id: (context) => RecoveryFlow(),
          SearchScreen.id: (context) => SearchScreen(),
          ServiceSectionsScreen.id: (context) => ServiceSectionsScreen(),
          */
        },
      ),
    );
  }
}
