import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/components/build_custom_bottom_nav_bar.dart';
import 'package:khedma/cubits/home_cubit/home_cubit.dart';
import 'package:khedma/cubits/home_cubit/home_states.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key, this.initialIndex, this.targetChatUser});

  final int? initialIndex;
  final dynamic targetChatUser;

  static String id = 'main_layout_screen';
  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  @override
  void initState() {
    super.initState();
    checkUserStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = HomeCubit.get(context);

      if (widget.initialIndex != null) {
        cubit.changeBottomNav(widget.initialIndex!);
      }

      // if (widget.targetChatUser != null) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ChatDetailsScreen(
      //         user: widget.targetChatUser,
      //       ),
      //     ),
      //   );
      // }
    });
  }

  Future<void> checkUserStatus() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // محاولة تحديث بيانات المستخدم من السيرفر
        await user.reload();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // إذا لم يجد المستخدم، قم بتسجيل الخروج يدوياً
        await FirebaseAuth.instance.signOut();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);

        return Scaffold(
          backgroundColor: Colors.white,
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BuildCustomBottomNavBar(cubit: cubit),
        );
      },
    );
  }
}
