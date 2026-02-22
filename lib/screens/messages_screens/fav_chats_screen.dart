import 'package:flutter/material.dart';

class FavChatsScreen extends StatelessWidget {
  const FavChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "هنا هتتعرض المحادثات المفضلة بس ❤️",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
      ),
      // هنا هتحط الـ ListView بتاع المحادثات المفضلة
    );
  }
}