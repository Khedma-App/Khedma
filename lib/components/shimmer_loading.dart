import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:khedma/core/constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shimmer base colors
// ─────────────────────────────────────────────────────────────────────────────

const _baseColor = Color(0xFFE8E8E8);
const _highlightColor = Color(0xFFF5F5F5);

// ─────────────────────────────────────────────────────────────────────────────
// Chat Card Shimmer
// ─────────────────────────────────────────────────────────────────────────────

class ShimmerChatCard extends StatelessWidget {
  const ShimmerChatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kSize(16), vertical: kHeight(8)),
        child: Row(
          children: [
            CircleAvatar(radius: kSize(28), backgroundColor: Colors.white),
            SizedBox(width: kSize(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: kHeight(14), width: kWidth(120), color: Colors.white),
                  SizedBox(height: kHeight(8)),
                  Container(height: kHeight(10), width: kWidth(200), color: Colors.white),
                ],
              ),
            ),
            Container(height: kHeight(10), width: kWidth(40), color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider Card Shimmer
// ─────────────────────────────────────────────────────────────────────────────

class ShimmerProviderCard extends StatelessWidget {
  const ShimmerProviderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: kSize(16), vertical: kHeight(6)),
        padding: EdgeInsets.all(kSize(12)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: kSize(32), backgroundColor: Colors.white),
            SizedBox(width: kSize(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: kHeight(16), width: kWidth(140), color: Colors.white),
                  SizedBox(height: kHeight(8)),
                  Container(height: kHeight(12), width: kWidth(100), color: Colors.white),
                  SizedBox(height: kHeight(6)),
                  Container(height: kHeight(12), width: kWidth(80), color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Order Card Shimmer
// ─────────────────────────────────────────────────────────────────────────────

class ShimmerOrderCard extends StatelessWidget {
  const ShimmerOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: kSize(16), vertical: kHeight(6)),
        padding: EdgeInsets.all(kSize(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: kHeight(16), width: kWidth(160), color: Colors.white),
            SizedBox(height: kHeight(10)),
            Container(height: kHeight(12), color: Colors.white),
            SizedBox(height: kHeight(6)),
            Container(height: kHeight(12), width: kWidth(200), color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Horizontal Request Card Shimmer (for RequestsFactorScreen)
// ─────────────────────────────────────────────────────────────────────────────

class ShimmerHorizontalCard extends StatelessWidget {
  const ShimmerHorizontalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      child: Container(
        width: kWidth(280),
        margin: EdgeInsets.symmetric(horizontal: kSize(10)),
        padding: EdgeInsets.all(kSize(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: kHeight(14), width: kWidth(100), color: Colors.white),
            SizedBox(height: kHeight(10)),
            Container(height: kHeight(12), width: kWidth(180), color: Colors.white),
            SizedBox(height: kHeight(8)),
            Container(height: kHeight(12), width: kWidth(120), color: Colors.white),
            const Spacer(),
            Row(
              children: [
                Expanded(child: Container(height: kHeight(36), color: Colors.white)),
                SizedBox(width: kSize(8)),
                Expanded(child: Container(height: kHeight(36), color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
