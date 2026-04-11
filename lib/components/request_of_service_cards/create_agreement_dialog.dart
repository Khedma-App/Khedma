import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CreateAgreementDialog extends StatefulWidget {
  const CreateAgreementDialog({super.key});

  @override
  State<CreateAgreementDialog> createState() => _CreateAgreementDialogState();
}

class _CreateAgreementDialogState extends State<CreateAgreementDialog> {
  late TextEditingController priceController;
  late TextEditingController depositController;
  late TextEditingController durationController;
  late TextEditingController detailsController;

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    priceController = TextEditingController();
    depositController = TextEditingController();
    durationController = TextEditingController();
    detailsController = TextEditingController();
  }

  @override
  void dispose() {
    priceController.dispose();
    depositController.dispose();
    durationController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFFF39C12)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kSize(20)),
      ),
      child: Container(
        width: kWidth(340),
        height: kHeight(370),
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
                    'إنشاء اتفاق',
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
                  // --- السعر المتفق عليه
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          height: kHeight(35),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(kSize(15)),
                          ),
                          child: TextField(
                            controller: priceController,
                            textAlign:
                                TextAlign.right, // الكتابة تبدأ من اليمين
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: kSize(12),
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'السعر',
                              hintStyle: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                              border: InputBorder.none,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: kWidth(10)),
                      SizedBox(
                        width: kWidth(115),
                        child: Text(
                          'السعر المتفق عليه',
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

                  // --- العربون ان وجد ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          height: kHeight(35),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(kSize(15)),
                          ),
                          child: TextField(
                            controller: depositController,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: kSize(12),
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'السعر',
                              hintStyle: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                              border: InputBorder.none,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: kWidth(10)),
                      SizedBox(
                        width: kWidth(115),
                        child: Text(
                          'العربون ان وجد',
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

                  // --- تاريخ بدء التنفيذ ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            height: kHeight(35),
                            padding: EdgeInsets.symmetric(
                              horizontal: kWidth(10),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(kSize(15)),
                              border: Border.all(
                                color: Colors.black,
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: kSize(20),
                                  color: Colors.black,
                                ),
                                const Spacer(),
                                Text(
                                  selectedDate == null
                                      ? 'التاريخ'
                                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                  style: TextStyle(
                                    fontSize: kSize(10),
                                    color: selectedDate == null
                                        ? Colors.grey
                                        : Colors.black,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: kWidth(10)),
                      SizedBox(
                        width: kWidth(115),
                        child: Text(
                          'تاريخ بدء التنفيذ',
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

                  // --- مدة التنفيذ التقريبية ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          height: kHeight(35),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(kSize(15)),
                          ),
                          child: TextField(
                            controller: durationController,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: kSize(12),
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'الزمن المتفق عليه',
                              hintStyle: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                              border: InputBorder.none,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: kWidth(10)),
                      SizedBox(
                        width: kWidth(115),
                        child: Text(
                          'مدة التنفيذ التقريبية',
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

                  // --- بنود الاتفاق ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          height: kHeight(35),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(kSize(15)),
                          ),
                          child: TextField(
                            controller: detailsController,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: kSize(12),
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'اكتب تفاصيل الشغل',
                              hintStyle: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                              border: InputBorder.none,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: kWidth(10)),
                      SizedBox(
                        width: kWidth(115),
                        child: Text(
                          'بنود الاتفاق',
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
                          onPressed: () => Navigator.pop(context),
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
