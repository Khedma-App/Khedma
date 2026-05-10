import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khedma/components/custom_active_order_card.dart';
import 'package:khedma/components/custom_availability_card.dart';
import 'package:khedma/components/custom_pending_request_card.dart';
import 'package:khedma/components/custom_requests_factor_header.dart';
import 'package:khedma/components/custom_stat_card.dart';
import 'package:khedma/components/empty_state_widget.dart';
import 'package:khedma/components/shimmer_loading.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/screens/messages_screens/chat_screen.dart';
import 'package:khedma/services/chat_service.dart';

class RequestsFactorScreen extends StatefulWidget {
  static String id = 'RequestsFactorScreen';
  const RequestsFactorScreen({super.key});

  @override
  State<RequestsFactorScreen> createState() => _RequestsFactorScreenState();
}

class _RequestsFactorScreenState extends State<RequestsFactorScreen> {
  final ChatService _chatService = ChatService();
  StreamSubscription? _sub;

  List<Map<String, dynamic>> _pendingRequests = [];
  List<Map<String, dynamic>> _activeOrders = [];
  bool _isLoading = true;

  String get _myUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    _sub = _chatService
        .watchProviderRequests(_myUid)
        .listen(
          (requests) {
            if (!mounted) return;
            setState(() {
              _pendingRequests = requests
                  .where((r) => r['status'] == 'pending')
                  .toList();
              _activeOrders = requests
                  .where((r) => r['status'] == 'accepted')
                  .toList();
              _isLoading = false;
            });
          },
          onError: (e) {
            if (!mounted) return;
            setState(() => _isLoading = false);
            debugPrint('⛔ RequestsFactorScreen: $e');
          },
        );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _navigateToChat(String chatRoomId, String clientName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChatScreen(chatRoomId: chatRoomId, userName: clientName),
      ),
    );
  }

  void _rejectRequest(String chatRoomId, String messageId) {
    _chatService.rejectServiceRequest(
      chatRoomId: chatRoomId,
      requestMessageId: messageId,
      rejectedByUid: _myUid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: RefreshIndicator(
        onRefresh: () async {
          // Dummy refresh for UX since Stream is real-time
          await Future.delayed(const Duration(seconds: 1));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم التحديث بنجاح', textAlign: TextAlign.right),
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const CustomRequestsFactorHeader(),

              SizedBox(height: kHeight(20)),
              const CustomAvailabilityCard(),

              // ── Stat Cards ──
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: kSize(18),
                  vertical: kHeight(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomStatCard(
                        title: "الدخل الشهري",
                        value: "0 ج",
                        icon: Icons.account_balance_wallet,
                        iconColor: const Color(0xFF1DBF73),
                        iconBgColor: const Color(0xFFE8F9F1),
                      ),
                    ),
                    SizedBox(width: kSize(10)),
                    Expanded(
                      child: CustomStatCard(
                        title: "جارية الآن",
                        value: '${_activeOrders.length}',
                        icon: Icons.build,
                        iconColor: const Color(0xFF006699),
                        iconBgColor: const Color(0xFFE0F2F1),
                      ),
                    ),
                    SizedBox(width: kSize(10)),
                    Expanded(
                      child: CustomStatCard(
                        title: "طلبات واردة",
                        value: '${_pendingRequests.length}',
                        icon: Icons.move_to_inbox,
                        iconColor: const Color(0xFFE19113),
                        iconBgColor: const Color(0xFFFFF4E5),
                      ),
                    ),
                  ],
                ),
              ),

              if (!_isLoading &&
                  _activeOrders.isEmpty &&
                  _pendingRequests.isEmpty)
                const EmptyStateWidget(
                  icon: Icons.inbox_outlined,
                  title: 'لا توجد طلبات واردة',
                  subtitle: 'عندما يطلب أحد خدمتك، ستظهر هنا',
                )
              else ...[
                // ── Active Orders Section ──
                if (_isLoading || _activeOrders.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.only(right: kSize(25)),
                    child: Text(
                      "طلبات جارية",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: kSize(16),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF211B12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: kHeight(220),
                    child: _isLoading
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: kSize(10),
                            ),
                            itemCount: 2,
                            itemBuilder: (_, __) =>
                                const ShimmerHorizontalCard(),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: kSize(10),
                            ),
                            itemCount: _activeOrders.length,
                            itemBuilder: (context, index) {
                              final order = _activeOrders[index];
                              final payload =
                                  order['requestPayload']
                                      as Map<String, dynamic>;
                              return CustomActiveOrderCard(
                                jobTitle:
                                    payload['description'] ??
                                    payload['serviceType'] ??
                                    'طلب خدمة',
                                clientName: order['clientName'] ?? 'مستخدم',
                                location:
                                    payload['governorate'] ??
                                    payload['city'] ??
                                    '',
                                price: '${payload['price'] ?? '0'}',
                                suggestedTime: payload['suggestedTime'] ?? '',
                                onConfirmComplete: () => _navigateToChat(
                                  order['chatRoomId'],
                                  order['clientName'] ?? 'مستخدم',
                                ),
                                onViewDetails: () => _navigateToChat(
                                  order['chatRoomId'],
                                  order['clientName'] ?? 'مستخدم',
                                ),
                              );
                            },
                          ),
                  ),
                ],

                // ── Pending Requests Section ──
                if (_isLoading || _pendingRequests.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.only(
                      right: kSize(25),
                      top: kHeight(10),
                    ),
                    child: Text(
                      "طلبات تنتظر ردك",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: kSize(16),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF211B12),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: kHeight(210),
                    child: _isLoading
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: kSize(10),
                            ),
                            itemCount: 2,
                            itemBuilder: (_, __) =>
                                const ShimmerHorizontalCard(),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: kSize(10),
                            ),
                            itemCount: _pendingRequests.length,
                            itemBuilder: (context, index) {
                              final request = _pendingRequests[index];
                              final payload =
                                  request['requestPayload']
                                      as Map<String, dynamic>;
                              final ts = request['timestamp'] as Timestamp?;
                              return CustomPendingRequestCard(
                                clientName: request['clientName'] ?? 'مستخدم',
                                serviceDescription:
                                    payload['description'] ??
                                    payload['serviceType'] ??
                                    'طلب خدمة',
                                estimatedPrice: '${payload['price'] ?? '0'}',
                                suggestedTime: payload['suggestedTime'] ?? '',
                                timestamp: ts?.toDate(),
                                onAccept: () => _navigateToChat(
                                  request['chatRoomId'],
                                  request['clientName'] ?? 'مستخدم',
                                ),
                                onReject: () => _rejectRequest(
                                  request['chatRoomId'],
                                  request['messageId'],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ],

              SizedBox(height: kHeight(30)),
            ],
          ),
        ),
      ),
    );
  }
}
