import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/components/empty_state_widget.dart';
import 'package:khedma/components/shimmer_loading.dart';
import 'package:khedma/cubits/messages_cubit/messages_cubit.dart';
import 'package:khedma/cubits/messages_cubit/messages_states.dart';
import 'package:khedma/screens/messages_screens/chat_screen.dart';

class AllChatsScreen extends StatelessWidget {
  const AllChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return BlocBuilder<MessagesCubit, MessagesStates>(
      builder: (context, state) {
        final cubit = MessagesCubit.get(context);
        final chats = cubit.chatRooms;

        if (state is MessagesLoadingState) {
          return ListView.builder(
            itemCount: 6,
            padding: const EdgeInsets.all(16),
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: ShimmerChatCard(),
            ),
          );
        }

        if (chats.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.chat_bubble_outline,
            title: 'لا توجد محادثات بعد',
            subtitle: 'ابدأ محادثة من صفحة مقدم الخدمة',
          );
        }

        return Container(
          color: Colors.grey[100],
          child: RefreshIndicator(
            onRefresh: () async {
              await cubit.loadChatRooms();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم التحديث بنجاح', textAlign: TextAlign.right),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: chats.length + (cubit.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == chats.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: state is MessagesLoadingMoreState
                          ? const CircularProgressIndicator()
                          : TextButton(
                              onPressed: () => cubit.loadMoreChats(),
                              child: const Text('تحميل المزيد'),
                            ),
                    ),
                  );
                }

                final chat = chats[index];
                final otherName = chat.getOtherName(myUid);
                final otherImage = chat.getOtherImage(myUid);
                final isFav = cubit.isFavorite(chat.id);

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
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.grey,
                      ),
                      onPressed: () async {
                        if (isFav) {
                          bool? confirm = await _showConfirmDialog(
                            context,
                            otherName,
                          );
                          if (confirm == true) {
                            cubit.toggleFavorite(chat.id);
                          }
                        } else {
                          cubit.toggleFavorite(chat.id);
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
                          builder: (context) => ChatScreen(
                            chatRoomId: chat.id,
                            userName: otherName,
                          ),
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    trailing: GestureDetector(
                      onTap: () =>
                          _showLargeImage(context, index, otherName, otherImage),
                      child: Hero(
                        tag: 'avatar_all_$index',
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.purple[50],
                          backgroundImage: otherImage.isNotEmpty
                              ? CachedNetworkImageProvider(otherImage)
                              : null,
                          child: otherImage.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.deepPurple[400],
                                )
                              : null,
                        ),
                      ),
                    ),
                    title: Text(
                      otherName,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFF333333),
                      ),
                    ),
                    subtitle: Text(
                      chat.lastMessage,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
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

  void _showLargeImage(
      BuildContext context, int index, String name, String imageUrl) {
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
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  if (imageUrl.isEmpty)
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
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16),
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