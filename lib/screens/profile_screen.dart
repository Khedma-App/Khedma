import 'package:flutter/material.dart';
import 'package:khedma/components/custom_logout_button.dart';
import 'package:khedma/components/custom_profile_header.dart';
import 'package:khedma/components/custom_profile_option_item.dart';
import 'package:khedma/core/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static String id = 'profilescreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "يوسف مهران";
  String userPhone = "01011709303";
  String userImagePath = "assets/images/home_background.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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

                if (updatedData != null && updatedData is Map<String, String>) {
                  setState(() {
                    userName = updatedData['name'] ?? userName;
                    userPhone = updatedData['phone'] ?? userPhone;
                    userImagePath = updatedData['image'] ?? userImagePath;
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

                  SizedBox(height: kHeight(100)),
                  CustomLogoutButton(
                    onTap: () {
                      // Logic تسجيل الخروج
                    },
                  ),
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
