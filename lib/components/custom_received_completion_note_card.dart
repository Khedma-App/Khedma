import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomReceivedCompletionNoteCard extends StatefulWidget {
  final List<String> attachmentImages;

  const CustomReceivedCompletionNoteCard({
    super.key,
    this.attachmentImages = const [],
  });

  @override
  State<CustomReceivedCompletionNoteCard> createState() =>
      _ReceivedCompletionNoteCardState();
}

class _ReceivedCompletionNoteCardState
    extends State<CustomReceivedCompletionNoteCard> {
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    const Color kPrimaryGreen = Color(0xFF00B686);

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: kHeight(10)),
        width: kWidth(315),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kWidth(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: kWidth(15),
              offset: Offset(0, kHeight(5)),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: kHeight(6),
              decoration: BoxDecoration(
                color: kPrimaryGreen,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kWidth(20)),
                  topRight: Radius.circular(kWidth(20)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(kWidth(16)),
              child: Column(
                children: [
                  SizedBox(height: kHeight(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: kWidth(10),
                          vertical: kHeight(6),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F7F3),
                          borderRadius: BorderRadius.circular(kWidth(6)),
                        ),
                        child: Text(
                          "في انتظار ردك",
                          style: TextStyle(
                            color: kPrimaryGreen,
                            fontSize: kWidth(12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "نوتة إنهاء العمل",
                            style: TextStyle(
                              fontSize: kWidth(18),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          Text(
                            "أرسلها العميل لتوثيق الاستلام",
                            style: TextStyle(
                              fontSize: kWidth(12),
                              color: Color(0xff514534),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: kHeight(20)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: kWidth(16),
                      vertical: kHeight(12),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF3E7),
                      borderRadius: BorderRadius.circular(kWidth(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "طريقة الدفع",
                              style: TextStyle(
                                fontSize: kWidth(11),
                                fontWeight: FontWeight.bold,
                                color: Color(0xff514534),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "نقدي",
                                  style: TextStyle(
                                    fontSize: kWidth(15),
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                                SizedBox(width: kWidth(6)),
                                const Icon(
                                  Icons.payments_outlined,
                                  size: 18,
                                  color: Color(0xFF333333),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "المبلغ المستلم",
                              style: TextStyle(
                                fontSize: kWidth(11),
                                color: Color(0xff514534),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  "5,400",
                                  style: TextStyle(
                                    fontSize: kWidth(24),
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF8B6E30),
                                  ),
                                ),
                                SizedBox(width: kWidth(4)),
                                Text(
                                  "ج",
                                  style: TextStyle(
                                    fontSize: kWidth(16),
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF8B6E30),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: kHeight(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.attachmentImages.length > 1)
                        Container(
                          width: kWidth(60),
                          height: kWidth(60),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2EAE0),
                            borderRadius: BorderRadius.circular(kWidth(8)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "+${widget.attachmentImages.length - 1}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: kWidth(16),
                            ),
                          ),
                        ),
                      if (widget.attachmentImages.isNotEmpty) ...[
                        SizedBox(width: kWidth(10)),
                        Container(
                          width: kWidth(60),
                          height: kWidth(60),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2EAE0),
                            borderRadius: BorderRadius.circular(kWidth(8)),
                            image: DecorationImage(
                              image: NetworkImage(widget.attachmentImages[0]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ] else ...[
                        Container(
                          width: kWidth(60),
                          height: kWidth(60),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2EAE0),
                            borderRadius: BorderRadius.circular(kWidth(8)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "0",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: kWidth(16),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: kHeight(24)),
                  SizedBox(
                    width: double.infinity,
                    height: kHeight(50),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          isAccepted = true;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isAccepted
                            ? kPrimaryGreen
                            : Colors.transparent,
                        side: BorderSide(
                          color: kPrimaryGreen,
                          width: kWidth(1.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kWidth(12)),
                        ),
                      ),
                      child: Text(
                        isAccepted ? "تمت الموافقة" : "وافقت واستلمت",
                        style: TextStyle(
                          fontSize: kWidth(16),
                          fontWeight: FontWeight.bold,
                          color: isAccepted ? Colors.white : kPrimaryGreen,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: kHeight(16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "فتح نزاع",
                          style: TextStyle(
                            color: Color(0xFFC62828),
                            fontSize: kSize(16),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "تعديل المبلغ",
                          style: TextStyle(
                            color: Color(0xFF8B6E30),
                            fontSize: kSize(16),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
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
