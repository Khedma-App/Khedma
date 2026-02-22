import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String userName;

  const ChatScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5), // الخلفية الرمادية الفاتحة
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // منطقة الرسائل
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMessageBubble(
                  isMe: true,
                  text:
                      "هنا نص الرسالة المرسلة من المستخدم الحالي وتكون في جهة اليمين مع حواف دائرية كبيرة",
                ),
                _buildMessageBubble(isMe: false, text: "رد الطرف الآخر"),
              ],
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
          // زر الملف الشخصي
          ElevatedButton(
            onPressed: () {
              //////
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE6911F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "الملف الشخصي",
              style: TextStyle(color: Colors.white),
            ),
          ),
          // اسم المستخدم والصورة
          Row(
            children: [
              Text(
                userName,
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
                  onPressed: () {},
                ),
              ),
            ),
            // مكان الكتابة
            const Expanded(
              child: TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
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
