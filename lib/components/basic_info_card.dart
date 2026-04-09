import 'dart:io';
import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class BasicInfoCard extends StatelessWidget {
  final File? profileImage;
  final TextEditingController nameController;
  final VoidCallback onPickImage;
  final String? nameError;
  final String? profileImageError;
  final Function(String) onNameChanged;

  const BasicInfoCard({
    super.key,
    required this.profileImage,
    required this.nameController,
    required this.onPickImage,
    this.nameError,
    this.profileImageError,
    required this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle hintStyle = TextStyle(
      fontFamily: 'Cairo',
      fontSize: kSize(10),
      fontWeight: FontWeight.w700,
      color: const Color(0xFF838383),
      height: 1.0,
    );

    final TextStyle errorStyle = TextStyle(
      fontSize: kSize(11),
      color: Colors.red,
      fontWeight: FontWeight.w500,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kSize(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: kSize(15),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: TextDirection.ltr,
            children: [
              CircleAvatar(
                radius: kSize(35),
                backgroundColor: const Color(0xFFE0E0E0),
                backgroundImage: profileImage != null
                    ? FileImage(profileImage!)
                    : null,
              ),
              SizedBox(width: kWidth(11)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      style: TextStyle(
                        fontSize: kSize(16),
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'يوسف مهران',
                        hintStyle: TextStyle(
                          fontSize: kSize(16),
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      onChanged: onNameChanged,
                    ),
                    SizedBox(height: kHeight(11)),
                    GestureDetector(
                      onTap: onPickImage,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: kWidth(12),
                          vertical: kHeight(6),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD0D0D0)),
                          borderRadius: BorderRadius.circular(kSize(8)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: kWidth(6)),
                            Text(
                              profileImage == null
                                  ? 'اضافة صورة شخصية'
                                  : 'تعديل الصورة الشخصية',
                              style: hintStyle,
                            ),
                            Icon(
                              Icons.add,
                              color: Colors.grey[600],
                              size: kSize(18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (profileImageError != null)
            Padding(
              padding: EdgeInsets.only(top: kHeight(8)),
              child: Text(profileImageError!, style: errorStyle),
            ),
          if (nameError != null)
            Padding(
              padding: EdgeInsets.only(top: kHeight(8)),
              child: Text(nameError!, style: errorStyle),
            ),
        ],
      ),
    );
  }
}
