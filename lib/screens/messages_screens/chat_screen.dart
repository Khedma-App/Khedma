import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khedma/models/message_model.dart';
import 'package:khedma/services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String userName;

  const ChatScreen({
    super.key,
    required this.chatRoomId,
    required this.userName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();

  String get _myUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    // Mark messages as read when entering the chat
    _chatService.markMessagesAsRead(
      chatRoomId: widget.chatRoomId,
      myUid: _myUid,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _chatService.sendMessage(
      chatRoomId: widget.chatRoomId,
      senderId: _myUid,
      text: text,
    );

    _messageController.clear();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5), // الخلفية الرمادية الفاتحة
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // منطقة الرسائل — Real-time stream
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _chatService.getMessagesStream(widget.chatRoomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'ابدأ المحادثة الآن!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  );
                }

                // Auto-scroll when new messages arrive
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return _buildMessageBubble(
                      isMe: msg.isMine(_myUid),
                      text: msg.text,
                    );
                  },
                );
              },
            ),
          ),
          //  حقل إدخال الرسالة
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading:
          false, // لإزالة سهم العودة الافتراضي وتصميمه يدوياً
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر الرجوع
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          // اسم المستخدم والصورة
          Row(
            children: [
              Text(
                widget.userName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: Colors.purple[50],
                child: const Icon(Icons.person, color: Colors.deepPurple),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // دالة بناء فقاعة الرسالة
  Widget _buildMessageBubble({required bool isMe, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) _smallAvatar(), // صورة الطرف الآخر على اليسار
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade300, width: 0.5),
              ),
              child: Text(
                text,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isMe) _smallAvatar(), // صورتي على اليمين
        ],
      ),
    );
  }

  Widget _smallAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: const CircleAvatar(
        radius: 15,
        backgroundColor: Colors.white,
        child: Icon(Icons.person, size: 20, color: Colors.orange),
      ),
    );
  }

  // دالة بناء حقل الإدخال
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            // زر الإرسال
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircleAvatar(
                backgroundColor: const Color(0xFFE6911F),
                radius: 25,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                ),
              ),
            ),
            // مكان الكتابة
            Expanded(
              child: TextField(
                controller: _messageController,
                textAlign: TextAlign.right,
                onSubmitted: (_) => _sendMessage,
                decoration: const InputDecoration(
                  hintText: "...ماذا تريد",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
