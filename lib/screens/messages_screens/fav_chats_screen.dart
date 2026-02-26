import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class FavChatsScreen extends StatelessWidget {
  const FavChatsScreen({super.key, required List<dynamic> favoriteChats});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> favList = [
      {"name": "محمود السيد"},
      {"name": "السيد ابراهيم"},
    ];

    // 🔥 استبدلنا Scaffold بـ Container
    return Container(
      color: Colors.grey[100],
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favList.length,
        itemBuilder: (context, index) {
          return _buildFavoriteCard(favList[index]['name']!);
        },
      ),
    );
  }

  Widget _buildFavoriteCard(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: kHeight(150), // انتبه: يفضل إعطاء ارتفاع ثابت للكارت
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          //القلب
          const Positioned(
            top: 25,
            left: 25,
            child: Icon(Icons.favorite, color: Colors.red, size: 40),
          ),

          //  الاسم وصورة الشخص
          Positioned(
            top: 20,
            right: 20,
            child: Row(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.purple[50],
                  child: const Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),

          //زرارالملف الشخصي
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6911F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                ),
                child: const Text(
                  "الملف الشخصي",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
