import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomOrdersSummaryHeader extends StatelessWidget {
  final int totalCount;
  final int completedCount;
  final int activeCount;
  final int disputeCount;

  const CustomOrdersSummaryHeader({
    super.key,
    this.totalCount = 0,
    this.completedCount = 0,
    this.activeCount = 0,
    this.disputeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: kHeight(186),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kHeight(5),
            bottom: kHeight(15),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFE19113),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kWidth(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    Image.asset(
                      "assets/images/logo.png",
                      height: kHeight(45),
                      fit: BoxFit.contain,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: kWidth(22),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -60,
          left: 15,
          right: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('$disputeCount', "نزاع\nملغية", Colors.orange),
              _buildStatCard('$activeCount', "جارية", Colors.red),
              _buildStatCard('$completedCount', "مكتملة", Colors.green),
              _buildStatCard('$totalCount', "الإجمالي", Colors.black),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String count, String title, Color color) {
    return Container(
      width: kWidth(80),
      height: kHeight(120),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kSize(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: kSize(10),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: kSize(24),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: kHeight(8)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: kSize(14),
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: kHeight(1.2),
            ),
          ),
        ],
      ),
    );
  }
}
