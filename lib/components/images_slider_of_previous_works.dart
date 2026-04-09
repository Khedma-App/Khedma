import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class ImagesSliderOfPreviousWorks extends StatefulWidget {
  const ImagesSliderOfPreviousWorks({super.key, required this.images});

  // هذه القائمة الآن ستحتوي على روابط (URLs) من Supabase
  final List<String> images;

  @override
  State<ImagesSliderOfPreviousWorks> createState() =>
      _ImagesSliderOfPreviousWorksState();
}

class _ImagesSliderOfPreviousWorksState
    extends State<ImagesSliderOfPreviousWorks> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // إذا كانت القائمة فارغة، نعرض صورة افتراضية أو مساحة فارغة
    if (widget.images.isEmpty) {
      return Container(
        height: kHeight(320),
        width: double.infinity,
        color: Colors.grey[300],
        child: const Icon(
          Icons.image_not_supported,
          size: 50,
          color: Colors.grey,
        ),
      );
    }

    return Column(
      children: [
        // 1. Photo Slider
        SizedBox(
          height: kHeight(320),
          width: double.infinity,
          child: PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.images[index],
                fit: BoxFit.cover,
                // عرض مؤشر تحميل أثناء جلب الصورة من السيرفر
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        color: kPrimaryColor,
                      ),
                    ),
                  );
                },
                // التعامل مع الروابط التالفة أو مشاكل الإنترنت
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, color: Colors.grey, size: 40),
                        SizedBox(height: 8),
                        Text(
                          "تعذر تحميل الصورة",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),

        // 2. Indicators (نقاط التمرير)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 15),
                width: _currentIndex == index
                    ? 20
                    : 8, // جعل النقطة النشطة أعرض قليلاً
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _currentIndex == index
                      ? kPrimaryColor // اللون الأساسي للتطبيق
                      : Colors.grey.shade300,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
