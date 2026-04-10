import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/cubits/messages_cubit/messages_cubit.dart';
import 'package:khedma/cubits/messages_cubit/messages_states.dart';
import 'package:khedma/screens/messages_screens/chat_screen.dart';

class FavChatsScreen extends StatelessWidget {
  const FavChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return BlocBuilder<MessagesCubit, MessagesStates>(
      builder: (context, state) {
        final cubit = MessagesCubit.get(context);
        final favList = cubit.favoriteChatRooms;

        if (favList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 60, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'لا توجد محادثات مفضلة',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        // 🔥 استبدلنا Scaffold بـ Container
        return Container(
          color: Colors.grey[100],
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favList.length,
            itemBuilder: (context, index) {
              final chat = favList[index];
              final otherName = chat.getOtherName(myUid);
              final otherImage = chat.getOtherImage(myUid);

              return _buildFavoriteCard(
                context,
                name: otherName,
                imageUrl: otherImage,
                chatRoomId: chat.id,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context, {
    required String name,
    required String imageUrl,
    required String chatRoomId,
  }) {
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
                  backgroundImage:
                      imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  child: imageUrl.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.deepPurple,
                        )
                      : null,
                ),
              ],
            ),
          ),

          //زرارالملف الشخصي → يفتح المحادثة
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatRoomId: chatRoomId,
                        userName: name,
                      ),
                    ),
                  );
                },
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
