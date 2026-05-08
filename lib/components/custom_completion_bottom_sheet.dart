import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomCompletionBottomSheet extends StatefulWidget {
  const CustomCompletionBottomSheet({super.key});

  @override
  State<CustomCompletionBottomSheet> createState() =>
      _CustomCompletionBottomSheetState();
}

class _CustomCompletionBottomSheetState
    extends State<CustomCompletionBottomSheet> {
  // متغيرات لمتابعة حالة الضغط لكل زر
  bool isConfirmPressed = false;
  bool isEditPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: kWidth(20),
        vertical: kHeight(15),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6F0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kHeight(30)),
          topRight: Radius.circular(kHeight(30)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle العلوي
          Container(
            width: kWidth(45),
            height: kHeight(4),
            decoration: BoxDecoration(
              color: const Color(0xFFDCC8B0),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: kHeight(25)),

          // صندوق التنبيه (Alert Box)
          Container(
            padding: EdgeInsets.all(kHeight(12)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFEDD5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    'العميل طلب إنهاء العمل وينتظر تأكيدك',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: kHeight(14),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF92400E),
                    ),
                  ),
                ),
                SizedBox(width: kWidth(12)),
                Icon(
                  Icons.info,
                  color: const Color(0xFFF59E0B),
                  size: kHeight(22),
                ),
              ],
            ),
          ),
          SizedBox(height: kHeight(25)),

          // العنوان والكود
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'تأكيد إنهاء العمل',
                  style: TextStyle(
                    fontSize: kHeight(17),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF211B12),
                  ),
                ),
                SizedBox(height: kHeight(6)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: kWidth(10),
                    vertical: kHeight(4),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFE6D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'CN-2026-00847',
                    style: TextStyle(
                      fontSize: kHeight(12),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF514534),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kHeight(20)),

          // بيانات العميل
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'أحمد محمود',
                    style: TextStyle(
                      fontSize: kHeight(15),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF211B12),
                    ),
                  ),
                  Text(
                    'عميل مسجل',
                    style: TextStyle(
                      fontSize: kHeight(13),
                      color: const Color(0xFF8B7E6B),
                    ),
                  ),
                ],
              ),
              SizedBox(width: kWidth(12)),
              CircleAvatar(
                radius: kHeight(24),
                backgroundImage: const AssetImage('assets/images/user.png'),
              ),
            ],
          ),
          SizedBox(height: kHeight(20)),

          // الصندوق التفصيلي
          Container(
            padding: EdgeInsets.all(kHeight(16)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEFE6D9)),
              color: Colors.white.withOpacity(0.3),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'ما كتبه العميل',
                    style: TextStyle(
                      fontSize: kHeight(14),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF514534),
                    ),
                  ),
                ),
                const Divider(color: Color(0xFFEFE6D9), height: 25),
                // تفاصيل الخدمة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تأسيس سباكة كامل',
                      style: TextStyle(
                        fontSize: kHeight(14),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF211B12),
                      ),
                    ),
                    Text(
                      'الخدمة',
                      style: TextStyle(
                        fontSize: kHeight(14),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF514534),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFFEFE6D9), height: 15),
                // المبلغ الإجمالي
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '5,400 ج',
                      style: TextStyle(
                        fontSize: kHeight(14),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2ECC71),
                      ),
                    ),
                    Text(
                      'المبلغ الإجمالي',
                      style: TextStyle(
                        fontSize: kHeight(14),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF514534),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFFEFE6D9), height: 15),
                // طريقة الدفع
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.payments_outlined,
                          size: kHeight(16),
                          color: const Color(0xFF514534),
                        ),
                        SizedBox(width: kWidth(4)),
                        Text(
                          'نقدي (كاش)',
                          style: TextStyle(
                            fontSize: kHeight(14),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF514534),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'طريقة الدفع  ',
                      style: TextStyle(
                        fontSize: kHeight(14),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF514534),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFFEFE6D9), height: 15),
                // التاريخ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '12 أكتوبر 2023',
                      style: TextStyle(
                        fontSize: kHeight(14),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF514534),
                      ),
                    ),
                    Text(
                      'التاريخ',
                      style: TextStyle(
                        fontSize: kHeight(14),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF514534),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: kHeight(30)),

          // زر تأكيد الاستلام
          GestureDetector(
            onTap: () {
              setState(() {
                isConfirmPressed = !isConfirmPressed;
                isEditPressed = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: kHeight(52),
              decoration: BoxDecoration(
                color: isConfirmPressed
                    ? const Color(0xFF2ECC71)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isConfirmPressed
                      ? const Color(0xFF2ECC71)
                      : const Color(0xFFDCC8B0),
                  width: 1.2,
                ),
                boxShadow: isConfirmPressed
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: isConfirmPressed
                        ? Colors.white
                        : const Color(0xFF2ECC71),
                    size: kHeight(20),
                  ),
                  SizedBox(width: kWidth(8)),
                  Text(
                    isConfirmPressed ? 'تم التأكيد' : 'تأكيد الاستلام',
                    style: TextStyle(
                      color: isConfirmPressed
                          ? Colors.white
                          : const Color(0xFF2ECC71),
                      fontWeight: FontWeight.bold,
                      fontSize: kHeight(16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: kHeight(12)),

          // زر تعديل المبلغ
          GestureDetector(
            onTap: () {
              setState(() {
                isEditPressed = !isEditPressed;
                isConfirmPressed = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: kHeight(52),
              decoration: BoxDecoration(
                color: isEditPressed ? const Color(0xFF514534) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isEditPressed
                      ? const Color(0xFF514534)
                      : const Color(0xFFDCC8B0),
                  width: 1.2,
                ),
                boxShadow: isEditPressed
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: Text(
                  'المبلغ مختلف — تعديل',
                  style: TextStyle(
                    color: isEditPressed
                        ? Colors.white
                        : const Color(0xFF514534),
                    fontWeight: FontWeight.bold,
                    fontSize: kHeight(16),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: kHeight(15)),

          TextButton(
            onPressed: () {},
            child: Text(
              'فتح نزاع',
              style: TextStyle(
                color: const Color(0xFFE74C3C),
                fontSize: kHeight(15),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: kHeight(10)),
        ],
      ),
    );
  }
}
