import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class FinishingWorkGest extends StatefulWidget {
  const FinishingWorkGest({super.key});

  @override
  State<FinishingWorkGest> createState() => _FinishingWorkGestState();
}

class _FinishingWorkGestState extends State<FinishingWorkGest> {
  // متغيرات لحفظ حالة التشيك بوكس
  bool isWorkFinished = false;
  bool isMoneyDelivered = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kSize(20)),
      ),
      child: Container(
        width: kWidth(340),
        height: kHeight(330),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kSize(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //  العنوان
            Container(
              padding: EdgeInsets.symmetric(
                vertical: kHeight(12),
                horizontal: kWidth(16),
              ),
              color: const Color(0xFFF39C12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'إنهاء العمل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: kSize(18),
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(width: kWidth(8)),
                  Image.asset(
                    'assets/icons/icon_cards.png',
                    width: kWidth(24),
                    height: kHeight(24),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(kSize(16)),
              child: Column(
                children: [
                  //  Checkbox 1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'هل تم انهاء العمل ؟',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: kSize(12),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Checkbox(
                        value: isWorkFinished,
                        activeColor: const Color(0xFFF39C12),
                        onChanged: (val) {
                          setState(() {
                            isWorkFinished = val!;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kSize(4)),
                        ),
                      ),
                    ],
                  ),

                  // --- Checkbox 2
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'هل تم تسليم العامل مستحقاته المالية ؟',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: kSize(12),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Checkbox(
                        value: isMoneyDelivered,
                        activeColor: const Color(0xFFF39C12),
                        onChanged: (val) {
                          setState(() {
                            isMoneyDelivered = val!;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kSize(4)),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: kHeight(15)),

                  //  حقل: كم المبلغ المسلّم
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          width: kWidth(130),
                          height: kHeight(35),
                          alignment: Alignment.center, // توسيط المحتوى عمودياً
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(kSize(10)),
                          ),
                          child: TextField(
                            textAlign: TextAlign.center, // توسيط النص أفقياً
                            style: TextStyle(
                              fontSize: kSize(12),
                              fontFamily: 'Cairo',
                            ),
                            decoration: InputDecoration(
                              hintText: 'اكتب اجمالي المبلغ',
                              hintStyle: TextStyle(
                                fontSize: kSize(10),
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                              border: InputBorder.none,
                              isCollapsed:
                                  true, // لإزالة الـ padding الداخلي الافتراضي
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: kWidth(10)),
                      SizedBox(
                        width: kWidth(100),
                        child: Text(
                          'كم المبلغ المسلّم',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: kSize(12),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: kHeight(10)),

                  //  حقل: ملاحظات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          width: kWidth(130),
                          height: kHeight(35),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(kSize(10)),
                          ),
                          child: TextField(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: kSize(12),
                              fontFamily: 'Cairo',
                            ),
                            decoration: InputDecoration(
                              hintText: 'اكتب ملاحظاتك',
                              hintStyle: TextStyle(
                                fontSize: kSize(12),
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: kWidth(10)),
                      SizedBox(
                        width: kWidth(100),
                        child: Text(
                          'ملاحظات',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: kSize(12),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: kHeight(25)),

                  // --- Buttons ---
                  Row(
                    children: [
                      // زر تقديم بلاغ
                      Container(
                        width: kWidth(110),
                        height: kHeight(35),
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.red,
                              width: kWidth(1.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(kSize(10)),
                            ),
                          ),
                          child: Text(
                            'تقديم بلاغ',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Cairo',
                              fontSize: kSize(12),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: kWidth(40)),
                      // زر تأكيد الإنهاء
                      Container(
                        width: kWidth(130),
                        height: kHeight(35),
                        child: ElevatedButton(
                          onPressed: () {
                            // منطق التأكيد هنا
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF39C12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(kSize(10)),
                            ),
                          ),
                          child: Text(
                            'تأكيد الإنهاء',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Cairo',
                              fontSize: kSize(12),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
