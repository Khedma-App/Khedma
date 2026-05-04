import 'dart:io';
import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/screens/edit_profile_screen.dart';

class ProfileHeaderSection extends StatelessWidget {
  final String userName;
  final String userPhone;
  final String userImagePath;
  final VoidCallback onEditTap;

  const ProfileHeaderSection({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.userImagePath,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: kHeight(150),
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: kHeight(75),
              bottom: kHeight(20),
              left: kSize(25),
              right: kSize(25),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(kSize(35)),
                bottomRight: Radius.circular(kSize(35)),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  userPhone,
                  style: TextStyle(
                    fontSize: kSize(13),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: kSize(15),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          height: kHeight(180),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE19113),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(screenWidth * 0.5, 80),
              bottomRight: Radius.elliptical(screenWidth * 0.5, 80),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: kHeight(10)),
                Image.asset(
                  "assets/images/logo.png",
                  height: kHeight(35),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),

        Positioned(
          top: kHeight(100),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: CircleAvatar(
              radius: kSize(55),
              backgroundImage: userImagePath.startsWith('assets')
                  ? AssetImage(userImagePath)
                  : FileImage(File(userImagePath)) as ImageProvider,
            ),
          ),
        ),

        // 4. زر التعديل (Edit Icon)
        Positioned(
          top: kHeight(195),
          right: screenWidth * 0.36,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, EditProfileScreen.id);
            },
            child: Container(
              padding: EdgeInsets.all(kSize(5)),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: kSize(6)),
                ],
              ),
              child: Icon(
                Icons.edit_outlined,
                size: kSize(22),
                color: const Color(0xFFE19113),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
