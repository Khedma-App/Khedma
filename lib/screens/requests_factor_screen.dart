import 'package:flutter/material.dart';
import 'package:khedma/components/custom_active_order_card.dart';
import 'package:khedma/components/custom_availability_card.dart';
import 'package:khedma/components/custom_completion_bottom_sheet.dart';
import 'package:khedma/components/custom_confirmed_work_card.dart';
import 'package:khedma/components/custom_pending_request_card.dart';
import 'package:khedma/components/custom_price_adjustment_card.dart';
import 'package:khedma/components/custom_requests_factor_header.dart';
import 'package:khedma/components/custom_stat_card.dart';
import 'package:khedma/components/custom_received_completion_note_card.dart';
import 'package:khedma/components/custom_work_completion_card.dart';
import 'package:khedma/core/constants.dart';

class RequestsFactorScreen extends StatelessWidget {
  static String id = 'RequestsFactorScreen';
  const RequestsFactorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const CustomRequestsFactorHeader(),

            SizedBox(height: kHeight(20)),
            const CustomAvailabilityCard(),

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
                      value: "1,800 ج",
                      icon: Icons.account_balance_wallet,
                      iconColor: const Color(0xFF1DBF73),
                      iconBgColor: const Color(0xFFE8F9F1),
                    ),
                  ),
                  SizedBox(width: kSize(10)),
                  const Expanded(
                    child: CustomStatCard(
                      title: "جارية الآن",
                      value: "2",
                      icon: Icons.build,
                      iconColor: Color(0xFF006699),
                      iconBgColor: Color(0xFFE0F2F1),
                    ),
                  ),
                  SizedBox(width: kSize(10)),
                  const Expanded(
                    child: CustomStatCard(
                      title: "طلبات واردة",
                      value: "3",
                      icon: Icons.move_to_inbox,
                      iconColor: Color(0xFFE19113),
                      iconBgColor: Color(0xFFFFF4E5),
                    ),
                  ),
                ],
              ),
            ),

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

            const CustomActiveOrderCard(),

            Padding(
              padding: EdgeInsets.only(right: kSize(25)),
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

            CustomPendingRequestCard(),

            CustomReceivedCompletionNoteCard(),
            SizedBox(height: kHeight(100)),
            Center(child: CustomWorkCompletionCard()),
            SizedBox(height: kHeight(100)),
            Center(child: CustomPriceAdjustmentCard()),
            SizedBox(height: kHeight(100)),
            Center(child: CustomConfirmedWorkCard()),
            SizedBox(height: kHeight(100)),
            CustomCompletionBottomSheet(),
            SizedBox(height: kHeight(100)),
          ],
        ),
      ),
    );
  }
}
