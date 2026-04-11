import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:intl/intl.dart';

class EditRequestSenderCard extends StatefulWidget {
  const EditRequestSenderCard({super.key});

  @override
  State<EditRequestSenderCard> createState() => _EditRequestSenderCardState();
}

class _EditRequestSenderCardState extends State<EditRequestSenderCard> {
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController? noteController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  VoidCallback? onCancel;
  GestureTapCallback? onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kWidth(304),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: kWidth(304),
            height: kHeight(34),
            padding: EdgeInsets.symmetric(horizontal: kWidth(12)),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: kPrimaryColor,
              shape: BoxShape.rectangle,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'تعديل الطلب',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: kSize(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: kWidth(7)),
                Image.asset(
                  'assets/icons/service_of_request_icon.png',
                  width: kSize(20),
                  height: kSize(20),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: kWidth(12),
              vertical: kHeight(12),
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: kHeight(8)),

                  // init history of service
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: kWidth(150),
                        height: kHeight(24),

                        color: Color(0xFFF5F5F5),
                        child: TextFormField(
                          controller: dateController,
                          textAlign: TextAlign.right,
                          readOnly: true,
                          decoration: InputDecoration(
                            hint: Text(
                              DateFormat('yyyy-MM-dd').format(DateTime.now()),
                              style: TextStyle(
                                fontSize: kSize(14),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF838383),
                              ),
                            ),
                            // hintText: 'اختر التاريخ',
                            prefixIcon: Icon(
                              Icons.calendar_month_rounded,
                              size: kSize(26),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onTap: () async {
                            // 3. دالة إظهار التقويم
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.now(), // التاريخ الافتراضي عند الفتح
                              firstDate: DateTime.now(), // أقل تاريخ مسموح به
                              lastDate: DateTime(2101), // أقصى تاريخ مسموح به
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                              setState(() {
                                dateController.text = formattedDate;
                              });
                            }
                          },
                        ),
                      ),
                      Text(
                        ' : التاريخ',
                        style: TextStyle(
                          fontSize: kSize(14),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: kHeight(8)),

                  // duration of service
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: Color(0xFFF5F5F5),
                        width: kWidth(150),
                        height: kHeight(34),
                        child: TextFormField(
                          controller: durationController,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'عدل مدة التنفيذ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        ' : المدة',
                        style: TextStyle(
                          fontSize: kSize(14),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: kHeight(8)),

                  // recommended price of service
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: Color(0xFFF5F5F5),
                        width: kWidth(150),
                        height: kHeight(34),
                        child: TextFormField(
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'عدل السعر',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        ' : السعر',
                        style: TextStyle(
                          fontSize: kSize(14),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: kHeight(12)),

                  // notes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          color: Color(0xFFF5F5F5),
                          height: kHeight(90),
                          child: TextFormField(
                            controller: noteController,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'ادخل الملاحظات',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        ' : ملاحظات',
                        style: TextStyle(
                          fontSize: kSize(14),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: kHeight(20)),

                  // buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // cancel button
                      OutlinedButton(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF838383),
                          side: const BorderSide(
                            color: Color(0xFFE89A24),
                            width: 1.5,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: kWidth(27)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'الغاء',
                          style: TextStyle(
                            fontSize: kSize(14),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      // edit button
                      GestureDetector(
                        onTap: onSend,
                        child: Container(
                          height: kHeight(36),
                          width: kWidth(88),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'إرسال',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: kSize(14),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
