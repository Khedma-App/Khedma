import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khedma/components/custom_build_oder_item.dart';
import 'package:khedma/components/custom_orders_summary_header.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/order_model.dart';
import 'package:khedma/services/chat_service.dart';

class OrderHistoryScreen extends StatefulWidget {
  OrderHistoryScreen({super.key});
  static String id = 'orderhistory';

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final ChatService _chatService = ChatService();
  StreamSubscription? _sub;

  List<OrderModel> _orders = [];
  bool _isLoading = true;

  // Stats
  int _totalCount = 0;
  int _completedCount = 0;
  int _activeCount = 0;
  int _disputeCount = 0;

  String get _myUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    _sub = _chatService.watchClientOrders(_myUid).listen(
      (ordersData) {
        if (!mounted) return;

        final List<OrderModel> orders = [];
        int completed = 0, active = 0, dispute = 0;

        for (final data in ordersData) {
          final payload = data['requestPayload'] as Map<String, dynamic>;
          final status = data['status'] as String;
          final providerName = data['providerName'] as String? ?? 'مقدم خدمة';
          final ts = data['timestamp'] as Timestamp?;
          final date = ts?.toDate();
          final dateStr = date != null
              ? '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}'
              : '';

          // Map Firestore status to Arabic display status
          String displayStatus;
          Color statusColor;
          bool showStars = false;
          String? bottomText;

          switch (status) {
            case 'accepted':
              displayStatus = 'جارية';
              statusColor = Colors.blue;
              active++;
              bottomText = 'العمل جاري حالياً';
              break;
            case 'pending':
              displayStatus = 'في الانتظار';
              statusColor = Colors.orange;
              active++;
              bottomText = 'في انتظار رد مقدم الخدمة';
              break;
            case 'rejected':
              displayStatus = 'ملغية';
              statusColor = Colors.red;
              dispute++;
              bottomText = 'تم الإلغاء';
              break;
            case 'modified':
              displayStatus = 'تعديل';
              statusColor = Colors.orange;
              active++;
              bottomText = 'تم طلب تعديل';
              break;
            default:
              displayStatus = 'مكتملة';
              statusColor = Colors.green;
              completed++;
              showStars = true;
          }

          orders.add(OrderModel(
            title: payload['description'] ?? payload['serviceType'] ?? 'طلب خدمة',
            price: '${payload['price'] ?? '0'}',
            status: displayStatus,
            details: '$providerName - ${payload['governorate'] ?? ''} - $dateStr',
            statusColor: statusColor,
            showStars: showStars,
            bottomText: bottomText,
          ));
        }

        setState(() {
          _orders = orders;
          _totalCount = orders.length;
          _completedCount = completed;
          _activeCount = active;
          _disputeCount = dispute;
          _isLoading = false;
        });
      },
      onError: (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        debugPrint('⛔ OrderHistoryScreen: $e');
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomOrdersSummaryHeader(
            totalCount: _totalCount,
            completedCount: _completedCount,
            activeCount: _activeCount,
            disputeCount: _disputeCount,
          ),
          SizedBox(height: kHeight(20)),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFE19113)),
                  )
                : _orders.isEmpty
                    ? Center(
                        child: Text(
                          'لا توجد طلبات حالياً',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: kSize(16),
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          return CustomBuildOderItem(order: _orders[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
