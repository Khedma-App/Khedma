import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class ClientFinishWorkDialog extends StatefulWidget {
  const ClientFinishWorkDialog({super.key});

  @override
  State<ClientFinishWorkDialog> createState() => _ClientFinishWorkDialogState();
}

class _ClientFinishWorkDialogState extends State<ClientFinishWorkDialog> {
  bool isWorkDone = false;
  bool isMoneyTaken = false;
  late TextEditingController amountController;
  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    notesController = TextEditingController();
  }

  @override
  void dispose() {
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }

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
            // --- Header ---
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
                  //  هل تم انهاء العمل ؟
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
                        value: isWorkDone,
                        activeColor: const Color(0xFFF39C12),
                        onChanged: (val) => setState(() => isWorkDone = val!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kSize(4)),
                        ),
                      ),
                    ],
                  ),

                  //  هل تم اخذ جميع مستحقاتك المالية ؟
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'هل تم اخذ جميع مستحقاتك المالية ؟',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: kSize(12),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Checkbox(
                        value: isMoneyTaken,
                        activeColor: const Color(0xFFF39C12),
                        onChanged: (val) => setState(() => isMoneyTaken = val!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kSize(4)),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: kHeight(15)),

                  //  حقل: كم المبلغ المستلم
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
                            controller: amountController,
                            textAlign: TextAlign.center,
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
                              isCollapsed: true,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: kWidth(10)),
                      SizedBox(
                        width: kWidth(100),
                        child: Text(
                          'كم المبلغ المستلم',
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

                  // --- حقل: ملاحظات ---
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
                            controller: notesController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: kSize(12),
                              fontFamily: 'Cairo',
                            ),
                            decoration: InputDecoration(
                              hintText: 'اكتب ملاحظاتك',
                              hintStyle: TextStyle(
                                fontSize: kSize(10),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // زر إلغاء
                      SizedBox(
                        width: kWidth(110),
                        height: kHeight(35),
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: const Color(0xFFF39C12),
                              width: kWidth(1.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(kSize(10)),
                            ),
                          ),
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                              color: const Color(0xFFF39C12),
                              fontFamily: 'Cairo',
                              fontSize: kSize(12),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: kWidth(130),
                        height: kHeight(35),
                        child: ElevatedButton(
                          onPressed: () {
                            // Logic الإرسال
                            //  Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF39C12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(kSize(10)),
                            ),
                          ),
                          child: Text(
                            'إرسال',
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
