import 'package:flutter/material.dart';
import 'package:khedma/screens/messages_screens/chat_screen.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({super.key});

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  //قائمة البيانات
  final List<Map<String, dynamic>> chats = [
    {
      "name": "محمود السيد",
      "message": "السلام عليكم ورحمة الله وبركاته",
      "isFavorite": false,
    },
    {"name": "السيد ابراهيم", "message": "الشقة 95 متر", "isFavorite": false},
    {"name": "أحمد علي", "message": "تمام يا هندسة", "isFavorite": false},
  ];

  @override
  Widget build(BuildContext context) {
    // 🔥 استبدلنا Scaffold بـ Container
    return Container(
      color: Colors.grey[100],
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: IconButton(
                icon: Icon(
                  chats[index]['isFavorite']
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: chats[index]['isFavorite'] ? Colors.red : Colors.grey,
                ),
                onPressed: () async {
                  if (chats[index]['isFavorite']) {
                    bool? confirm = await _showConfirmDialog(
                      context,
                      chats[index]['name'],
                    );
                    if (confirm == true) {
                      setState(() {
                        chats[index]['isFavorite'] = false;
                      });
                    }
                  } else {
                    setState(() {
                      chats[index]['isFavorite'] = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "تمت الإضافة للمفضلة",
                          textAlign: TextAlign.right,
                        ),
                        duration: Duration(milliseconds: 600),
                      ),
                    );
                  }
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen(userName: chats[index]['name']!),
                  ),
                );
              },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              trailing: GestureDetector(
                onTap: () =>
                    _showLargeImage(context, index, chats[index]['name']!),
                child: Hero(
                  tag: 'avatar_all_$index', // تغيير الـ tag لعدم التداخل
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.purple[50],
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.deepPurple[400],
                    ),
                  ),
                ),
              ),
              title: Text(
                chats[index]['name']!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Color(0xFF333333),
                ),
              ),
              subtitle: Text(
                chats[index]['message']!,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تأكيد", textAlign: TextAlign.right),
        content: Text(
          "هل تريد إزالة $name من المفضلة؟",
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("تأكيد", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showLargeImage(BuildContext context, int index, String name) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Center(
        child: Hero(
          tag: 'avatar_all_$index',
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.person,
                      size: 150,
                      color: Colors.deepPurple,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.black26,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      name,
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}