import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khedma/components/custom_logout_button.dart';
import 'package:khedma/components/custom_profile_header.dart';
import 'package:khedma/components/custom_profile_option_item.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/screens/auth_screens/auth_screen.dart';
import 'package:khedma/services/user_service.dart';
import 'about_us_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static String id = 'profilescreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  StreamSubscription? _userSub;

  String userName = '';
  String userPhone = '';
  String userImagePath = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _userSub = _userService.watchUser(uid).listen((userModel) {
      if (!mounted || userModel == null) return;
      setState(() {
        userName = userModel.fullName;
        userPhone = userModel.phone.isNotEmpty ? userModel.phone : userModel.email;
        _isLoading = false;
      });
    });

    // Also fetch the raw doc once to get profileImageUrl from providerData
    _userService.getUserById(uid).then((user) {
      // The profileImageUrl is stored inside providerData in Firestore
      // but not parsed into the ProviderData model — get from raw doc
      FirebaseFirestore.instance.collection('users').doc(uid).get().then((doc) {
        if (!mounted || doc.data() == null) return;
        final data = doc.data()!;
        final providerData = data['providerData'] as Map<String, dynamic>?;
        final imgUrl = providerData?['profileImageUrl'] as String? ?? '';
        if (imgUrl.isNotEmpty && mounted) {
          setState(() => userImagePath = imgUrl);
        }
      });
    }).catchError((_) {});
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'تسجيل الخروج',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'هل أنت متأكد من تسجيل الخروج؟',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AuthScreen.id, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE19113)))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // استخدام كلاس الهيدر
                  ProfileHeaderSection(
                    userName: userName,
                    userPhone: userPhone,
                    userImagePath: userImagePath,
                    onEditTap: () async {
                      final updatedData = await Navigator.pushNamed(
                        context,
                        'edit_profile',
                        arguments: {
                          'name': userName,
                          'phone': userPhone,
                          'image': userImagePath,
                        },
                      );

                      if (updatedData != null &&
                          updatedData is Map<String, String>) {
                        setState(() {
                          userName = updatedData['name'] ?? userName;
                          userPhone = updatedData['phone'] ?? userPhone;
                          userImagePath =
                              updatedData['image'] ?? userImagePath;
                        });
                      }
                    },
                  ),

                  SizedBox(height: kHeight(100)),

                  // قائمة الخيارات
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kWidth(25)),
                    child: Column(
                      children: [
                        CustomProfileOptionItem(
                          title: "المحفظة والرصيد",
                          icon: Icons.account_balance_wallet,
                          hasNotification: true,
                          onTap: () {},
                        ),
                        CustomProfileOptionItem(
                          title: "عناويني المسجلة",
                          icon: Icons.location_on,
                          onTap: () {},
                        ),
                        CustomProfileOptionItem(
                          title: "الدعم والمساعدة",
                          icon: Icons.headset_mic,
                          onTap: () {},
                        ),
                        CustomProfileOptionItem(
                          title: "من نحن",
                          icon: Icons.info_outline,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AboutUsScreen(),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: kHeight(100)),
                        CustomLogoutButton(onTap: _confirmLogout),
                        SizedBox(height: kHeight(40)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
