import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
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

  // ─── Send text message ──────────────────────────────────────────────────

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

  // ─── Chat lock logic ────────────────────────────────────────────────────

  /// Determines if the text input should be unlocked.
  ///
  /// Scans messages in reverse to find the latest request/modification.
  /// If its status is 'accepted', chat is unlocked. Otherwise locked.
  bool _isChatUnlocked(List<MessageModel> messages) {
    // No messages → unlocked (empty chat from direct navigation)
    if (messages.isEmpty) return true;

    // Find the latest request or modification message.
    for (int i = messages.length - 1; i >= 0; i--) {
      final msg = messages[i];
      if (msg.messageType == 'service_request' ||
          msg.messageType == 'modification') {
        return msg.requestStatus == 'accepted';
      }
    }

    // No request found → unlocked (pure text chat)
    return true;
  }

  // ─── Action handlers ────────────────────────────────────────────────────

  Future<void> _handleAccept(MessageModel msg) async {
    try {
      await _chatService.acceptServiceRequest(
        chatRoomId: widget.chatRoomId,
        requestMessageId: msg.id,
        acceptedByUid: _myUid,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }

  Future<void> _handleReject(MessageModel msg) async {
    try {
      await _chatService.rejectServiceRequest(
        chatRoomId: widget.chatRoomId,
        requestMessageId: msg.id,
        rejectedByUid: _myUid,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }

  void _handleModify(MessageModel msg) {
    _showModificationSheet(msg);
  }

  // ─── Modification bottom sheet ──────────────────────────────────────────

  void _showModificationSheet(MessageModel originalMsg) {
    final dateCtrl = TextEditingController(
      text: originalMsg.requestPayload?['date'] as String? ?? '',
    );
    final priceCtrl = TextEditingController(
      text: originalMsg.requestPayload?['price'] as String? ?? '',
    );
    final notesCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Header
                Center(
                  child: Text(
                    'طلب تعديل',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(18),
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SizedBox(height: kHeight(16)),

                // Date
                Text(
                  'التاريخ',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: kSize(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: kHeight(6)),
                TextField(
                  controller: dateCtrl,
                  textAlign: TextAlign.right,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'اختر التاريخ',
                    prefixIcon: const Icon(Icons.calendar_month_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      dateCtrl.text =
                          '${picked.year}-${picked.month}-${picked.day}';
                    }
                  },
                ),
                SizedBox(height: kHeight(12)),

                // Price
                Text(
                  'السعر',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: kSize(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: kHeight(6)),
                TextField(
                  controller: priceCtrl,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'ادخل السعر المقترح',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: kHeight(12)),

                // Notes
                Text(
                  'ملاحظات',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: kSize(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: kHeight(6)),
                TextField(
                  controller: notesCtrl,
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'اكتب ملاحظاتك',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: kHeight(20)),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          side: const BorderSide(
                            color: Color(0xFFE89A24),
                            width: 1.5,
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: kHeight(12)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: kWidth(12)),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(ctx);
                          try {
                            await _chatService.requestModification(
                              chatRoomId: widget.chatRoomId,
                              originalMessageId: originalMsg.id,
                              senderId: _myUid,
                              modifiedPayload: {
                                // Carry over original fields
                                ...?originalMsg.requestPayload,
                                // Override with new values
                                'date': dateCtrl.text.trim(),
                                'price': priceCtrl.text.trim(),
                                'notes': notesCtrl.text.trim(),
                              },
                            );
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('خطأ: $e')),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(vertical: kHeight(12)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'إرسال التعديل',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Scroll helper ──────────────────────────────────────────────────────

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

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: _buildAppBar(context),
      body: StreamBuilder<List<MessageModel>>(
        stream: _chatService.getMessagesStream(widget.chatRoomId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final messages = snapshot.data ?? [];
          final chatUnlocked = _isChatUnlocked(messages);

          // Auto-scroll when new messages arrive
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          return Column(
            children: [
              // ── Messages list ──
              Expanded(
                child: messages.isEmpty
                    ? Center(
                        child: Text(
                          'ابدأ المحادثة الآن!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageItem(messages[index]);
                        },
                      ),
              ),
              // ── Bottom input / lock bar ──
              chatUnlocked
                  ? _buildMessageInput()
                  : _buildLockedInput(),
            ],
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGE ITEM ROUTER
  // ═══════════════════════════════════════════════════════════════════════════

  /// Routes each message to the correct UI widget based on [messageType].
  Widget _buildMessageItem(MessageModel msg) {
    switch (msg.messageType) {
      case 'service_request':
        return _buildServiceRequestCard(msg);
      case 'modification':
        return _buildModificationCard(msg);
      case 'status_update':
        return _buildStatusUpdateBubble(msg);
      case 'text':
      default:
        return _buildTextBubble(msg);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 1. TEXT BUBBLE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTextBubble(MessageModel msg) {
    final isMe = msg.isMine(_myUid);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) _smallAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300, width: 0.5),
              ),
              child: Text(
                msg.text,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isMe) _smallAvatar(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. SERVICE REQUEST CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildServiceRequestCard(MessageModel msg) {
    final p = msg.requestPayload ?? {};
    final isMe = msg.isMine(_myUid);
    final isPending = msg.requestStatus == 'pending';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: kWidth(300),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header bar
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: kWidth(12),
                  vertical: kHeight(8),
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      isMe ? 'طلب خدمة' : 'طلب جديد',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: kSize(15),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(width: kWidth(6)),
                    Image.asset(
                      'assets/icons/service_of_request_icon.png',
                      width: kSize(20),
                      height: kSize(20),
                    ),
                  ],
                ),
              ),

              // Body
              Padding(
                padding: EdgeInsets.all(kSize(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _cardInfoRow('نوع الخدمة', p['serviceType'] ?? ''),
                    SizedBox(height: kHeight(6)),
                    _cardDescriptionRow(
                        'الوصف', p['description'] ?? ''),
                    SizedBox(height: kHeight(6)),
                    _cardInfoRow('التاريخ', p['date'] ?? ''),
                    if ((p['price'] as String?)?.isNotEmpty == true) ...[
                      SizedBox(height: kHeight(6)),
                      _cardInfoRow(
                          'السعر المبدئي', '${p['price']} ج ${p['pricingUnit'] ?? ''}'),
                    ],
                    SizedBox(height: kHeight(6)),
                    // Address
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            '${p['governorate'] ?? ''} - ${p['city'] ?? ''}',
                            style: TextStyle(
                              fontSize: kSize(13),
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                        SizedBox(width: kWidth(4)),
                        Icon(
                          Icons.location_on,
                          color: kPrimaryColor,
                          size: kSize(18),
                        ),
                      ],
                    ),
                    // Notes
                    if ((p['notes'] as String?)?.isNotEmpty == true) ...[
                      SizedBox(height: kHeight(6)),
                      _cardDescriptionRow('ملاحظات', p['notes']),
                    ],

                    // Status badge for non-pending
                    if (!isPending) ...[
                      SizedBox(height: kHeight(10)),
                      _statusBadge(msg.requestStatus),
                    ],

                    // Action buttons — only for PENDING requests
                    if (isPending) ...[
                      SizedBox(height: kHeight(14)),
                      _buildActionButtons(msg, isMe),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. MODIFICATION CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildModificationCard(MessageModel msg) {
    final p = msg.requestPayload ?? {};
    final isMe = msg.isMine(_myUid);
    final isPending = msg.requestStatus == 'pending';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: kWidth(300),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: kWidth(12),
                  vertical: kHeight(8),
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'طلب تعديل',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: kSize(15),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(width: kWidth(6)),
                    Image.asset(
                      'assets/icons/service_of_request_icon.png',
                      width: kSize(20),
                      height: kSize(20),
                    ),
                  ],
                ),
              ),

              // Body
              Padding(
                padding: EdgeInsets.all(kSize(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _cardInfoRow('التاريخ', p['date'] ?? ''),
                    SizedBox(height: kHeight(6)),
                    _cardInfoRow('السعر', '${p['price'] ?? ''} ج'),
                    if ((p['notes'] as String?)?.isNotEmpty == true) ...[
                      SizedBox(height: kHeight(6)),
                      _cardDescriptionRow('ملاحظات', p['notes']),
                    ],

                    if (!isPending) ...[
                      SizedBox(height: kHeight(10)),
                      _statusBadge(msg.requestStatus),
                    ],

                    if (isPending) ...[
                      SizedBox(height: kHeight(14)),
                      _buildActionButtons(msg, isMe),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 4. STATUS UPDATE BUBBLE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStatusUpdateBubble(MessageModel msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: kWidth(16),
            vertical: kHeight(8),
          ),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  msg.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: kSize(13),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              SizedBox(width: kWidth(6)),
              Icon(
                msg.text.contains('قبول') || msg.text.contains('بدء')
                    ? Icons.check_circle
                    : Icons.info_outline,
                color: Colors.white,
                size: kSize(18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACTION BUTTONS (Accept / Modify / Cancel)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Builds the appropriate action buttons based on who is viewing.
  ///
  /// - If the current user SENT the request → they can Modify or Cancel.
  /// - If the current user RECEIVED the request → they can Accept, Modify, or Cancel.
  Widget _buildActionButtons(MessageModel msg, bool isSender) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Cancel
        OutlinedButton(
          onPressed: () => _handleReject(msg),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF838383),
            side: const BorderSide(color: Color(0xFFE89A24), width: 1.5),
            padding: EdgeInsets.symmetric(horizontal: kWidth(20)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'الغاء',
            style: TextStyle(
              fontSize: kSize(13),
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
            ),
          ),
        ),

        // Modify
        GestureDetector(
          onTap: () => _handleModify(msg),
          child: Container(
            height: kHeight(36),
            padding: EdgeInsets.symmetric(horizontal: kWidth(20)),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'تعديل',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: kSize(13),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
        ),

        // Accept — only for the RECEIVER of the request
        if (!isSender)
          GestureDetector(
            onTap: () => _handleAccept(msg),
            child: Container(
              height: kHeight(36),
              padding: EdgeInsets.symmetric(horizontal: kWidth(20)),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(47, 188, 52, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'قبول',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: kSize(13),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SHARED HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _cardInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF838383),
            fontSize: kSize(13),
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          ' : $label',
          style: TextStyle(
            fontSize: kSize(13),
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Widget _cardDescriptionRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: const Color(0xFF838383),
              fontSize: kSize(13),
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
            ),
          ),
        ),
        Text(
          ' : $label',
          style: TextStyle(
            fontSize: kSize(13),
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    final Color bgColor;
    final String label;

    switch (status) {
      case 'accepted':
        bgColor = const Color.fromRGBO(47, 188, 52, 1);
        label = 'تم القبول ✅';
        break;
      case 'rejected':
        bgColor = Colors.red;
        label = 'تم الإلغاء ❌';
        break;
      case 'modified':
        bgColor = Colors.blueGrey;
        label = 'تم التعديل 📝';
        break;
      default:
        bgColor = Colors.grey;
        label = status;
    }

    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: kWidth(16),
          vertical: kHeight(4),
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontSize: kSize(12),
            fontWeight: FontWeight.bold,
          ),
        ),
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

  // ═══════════════════════════════════════════════════════════════════════════
  // APP BAR
  // ═══════════════════════════════════════════════════════════════════════════

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          Row(
            children: [
              Text(
                widget.userName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
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

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT INPUT (unlocked)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Security notice
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              'لحمايتك، يفضل إتمام الاتفاق داخل التطبيق',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 11,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
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
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    textAlign: TextAlign.right,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: '...ماذا تريد',
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOCKED INPUT (negotiation in progress)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLockedInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'في انتظار الاتفاق على الخدمة',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.lock_outline, color: Colors.grey[500], size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
