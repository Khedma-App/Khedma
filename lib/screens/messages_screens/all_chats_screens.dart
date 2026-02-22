import 'package:flutter/material.dart';

class AllChatsScreen extends StatelessWidget {
  const AllChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "هنا هتتعرض كل المحادثات 💬",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      // هنا هتحط الـ ListView بتاع كل المحادثات
    );
  }
}