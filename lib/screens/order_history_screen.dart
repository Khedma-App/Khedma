import 'package:flutter/material.dart';
import 'package:khedma/components/custom_build_oder_item.dart';
import 'package:khedma/components/custom_orders_summary_header.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/order_model.dart';

class OrderHistoryScreen extends StatefulWidget {
  OrderHistoryScreen({super.key});
  static String id = 'orderhistory';

  final List<OrderModel> orders = [
    OrderModel(
      title: "تشطيب ونقاشة - شقة 95 متر",
      price: "5600",
      status: "مكتملة",
      details: "محمود سمير - بور سعيد - 2026.05.06",
      statusColor: Colors.green,
      showStars: true,
    ),
    OrderModel(
      title: "دهان سور خارجي",
      price: "4300",
      status: "نزاع",
      details: "مصطفى ابراهيم - المنيا - 2026.07.02",
      statusColor: Colors.orange,
      bottomText: "جاري المراجعة من قبل فريق خدمة",
    ),
    OrderModel(
      title: "تعديل في كهرباء مخزن",
      price: "3200",
      status: "ملغية",
      details: "احمد محمد - الجيزة - 2026.05.15",
      statusColor: Colors.red,
      bottomText: "تم الالغاء من قبل العميل",
    ),
  ];

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomOrdersSummaryHeader(),
          SizedBox(height: kHeight(20)),
          Expanded(
            child: ListView.builder(
              itemCount: widget.orders.length,
              itemBuilder: (context, index) {
                return CustomBuildOderItem(order: widget.orders[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
