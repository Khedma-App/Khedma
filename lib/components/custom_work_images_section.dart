import 'dart:io';
import 'dart:ui' as BorderType;
import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:dotted_border/dotted_border.dart'; // استيراد المكتبة

class CustomWorkImagesSection extends StatelessWidget {
  final List<File> images;
  final VoidCallback onAddImage;
  final Function(int) onRemoveImage;

  const CustomWorkImagesSection({
    super.key,
    required this.images,
    required this.onAddImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kSize(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'صور ختامية للعمل',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: kSize(16),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF211B12),
            ),
          ),
          SizedBox(height: kHeight(12)),
          Directionality(
            textDirection: TextDirection.rtl,
            child: SizedBox(
              height: kHeight(90),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length + 1,
                separatorBuilder: (context, index) =>
                    SizedBox(width: kWidth(12)),
                itemBuilder: (context, index) {
                  if (index < images.length) {
                    return _buildImageItem(index);
                  } else {
                    return _buildAddPlaceholder();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageItem(int index) {
    return Stack(
      children: [
        Container(
          width: kWidth(90),
          height: kHeight(90),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kSize(12)),
            image: DecorationImage(
              image: FileImage(images[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: kSize(5),
          left: kSize(5),
          child: GestureDetector(
            onTap: () => onRemoveImage(index),
            child: Container(
              padding: EdgeInsets.all(kSize(2)),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: kSize(16), color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddPlaceholder() {
    return GestureDetector(
      onTap: onAddImage,
      child: DottedBorder(
        options: RectDottedBorderOptions(
          color: const Color(0xFFD6C4AE),
          strokeWidth: 1.5,
          dashPattern: const [6, 4],
        ),
        child: Container(
          width: kWidth(90),
          height: kHeight(90),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(kSize(12)),
          ),
          child: Center(
            child: Icon(
              Icons.add_photo_alternate_outlined,
              color: const Color(0xFF8C867E),
              size: kSize(30),
            ),
          ),
        ),
      ),
    );
  }
}
