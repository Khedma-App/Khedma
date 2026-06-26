import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';

import 'package:pdf/widgets.dart' as pw;

class ServiceContractScreen extends StatefulWidget {
  const ServiceContractScreen({super.key});

  static const String id = 'service_contract_screen';

  @override
  State<ServiceContractScreen> createState() => _ServiceContractScreenState();
}

class _ServiceContractScreenState extends State<ServiceContractScreen> {
  Future<void> _exportToPdf() async {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        content: Text(
          '... جارٍ تصدير العقد',
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
        ),
        duration: Duration(seconds: 30),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // 1. Build the full contract widget (no Scaffold, no Expanded, no scroll)
    //    — just the Column of all sections with fixed width = A4 points width
    final contractWidget = Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 595, // A4 width in points
        color: const Color(0xFFF5F5F5),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeaderCard(),
            const SizedBox(height: 12),
            _PartyCard(
              icon: Icons.person_outline,
              title: 'الطرف الأول (العميل)',
              name: 'إبراهيم أحمد',
              detail: '01117699254',
              detailIcon: Icons.phone_outlined,
            ),
            SizedBox(height: 10),
            _PartyCard(
              icon: Icons.handyman_outlined,
              title: 'الطرف الثاني (العامل)',
              name: 'محمود سمير',
              detail: '01019974379',
              detailIcon: Icons.phone_outlined,
              badge: 'عامل',
            ),
            SizedBox(height: 10),
            _ServiceDetailsCard(),
            SizedBox(height: 10),
            _ContractClausesCard(),
            SizedBox(height: 10),
            _SignaturesSection(),
            SizedBox(height: 10),
            _DisclaimerNote(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );

    // 2. Capture the full widget as high-res image bytes (off-screen render)
    final controller = ScreenshotController();
    final Uint8List imageBytes = await controller.captureFromLongWidget(
      contractWidget,
      pixelRatio: 3.0,
      context: context, // needed for MediaQuery/Theme inheritance
      constraints: const BoxConstraints(maxWidth: 595),
    );

    // 3. Embed image into A4 PDF page
    final pdf = pw.Document();
    final pdfImage = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (_) => pw.Image(pdfImage, fit: pw.BoxFit.contain),
      ),
    );

    // 4. Share/save PDF
    messenger.hideCurrentSnackBar();
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'service_contract_KH.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    initScreenSize(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: kWidth(16),
                  vertical: kHeight(12),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // ── Header Card ──────────────────────────────────────
                      _HeaderCard(),
                      SizedBox(height: kHeight(12)),

                      // ── Party 1 (Client) ─────────────────────────────────
                      _PartyCard(
                        icon: Icons.person_outline,
                        title: 'الطرف الأول (العميل)',
                        name: 'إبراهيم أحمد',
                        detail: '01117699254',
                        detailIcon: Icons.phone_outlined,
                      ),
                      SizedBox(height: kHeight(10)),

                      // ── Party 2 (Worker) ─────────────────────────────────
                      _PartyCard(
                        icon: Icons.handyman_outlined,
                        title: 'الطرف الثاني (العامل)',
                        name: 'محمود سمير',
                        detail: '01019974379',
                        detailIcon: Icons.phone_outlined,
                        badge: 'عامل',
                      ),
                      SizedBox(height: kHeight(10)),

                      // ── Service Details Card ──────────────────────────────
                      _ServiceDetailsCard(),
                      SizedBox(height: kHeight(10)),

                      // ── Contract Clauses ──────────────────────────────────
                      _ContractClausesCard(),
                      SizedBox(height: kHeight(10)),

                      // ── Digital Signatures ────────────────────────────────
                      _SignaturesSection(),
                      SizedBox(height: kHeight(10)),

                      // ── Disclaimer note ───────────────────────────────────
                      _DisclaimerNote(),
                      SizedBox(height: kHeight(16)),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom Action Bar ─────────────────────────────────────────
            _BottomActionBar(onExportPdf: _exportToPdf),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header Card
// ─────────────────────────────────────────────────────────────────────────────
class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: kWidth(16),
        vertical: kHeight(16),
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF016290), Color(0xFF012235)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(kSize(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: kSize(10),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'خدمة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: kSize(20),
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: kWidth(8)),
              Container(
                padding: EdgeInsets.all(kSize(2)),
                child: Image.asset(
                  'assets/icons/contract_icon.png',
                  height: kHeight(22),
                  width: kWidth(22),
                ),
              ),
              Spacer(),
              Container(
                width: kWidth(128.5),
                height: kHeight(26),
                decoration: BoxDecoration(
                  color: Color(0xFF347595),
                  borderRadius: BorderRadius.circular(kSize(20)),
                  border: Border.all(
                    color: const Color.fromRGBO(255, 255, 255, 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: kWidth(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(16, 185, 129, 1),
                      ),
                    ),
                    Text(
                      'توقيع رقمي معتمد',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: kSize(12),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: kHeight(4)),
          Text(
            'عقد اتفاق خدمة',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: kSize(14),
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: kHeight(8)),
          // Contract number chip
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: kWidth(10),
              vertical: kHeight(4),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(kSize(20)),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 0.8,
              ),
            ),
            child: Text(
              'رقم العقد: KH-2026-00847',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: kSize(11),
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Party Card
// ─────────────────────────────────────────────────────────────────────────────
class _PartyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String name;
  final String detail;
  final IconData detailIcon;
  final String? badge;

  const _PartyCard({
    required this.icon,
    required this.title,
    required this.name,
    required this.detail,
    required this.detailIcon,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(kSize(14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kSize(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: kSize(8),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: kSize(18), color: kPrimaryColor),
              SizedBox(width: kWidth(6)),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: kSize(13),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D2D2D),
                ),
              ),
            ],
          ),
          SizedBox(height: kHeight(10)),
          // Name row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (badge != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: kWidth(8),
                    vertical: kHeight(2),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF016290).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(kSize(20)),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(12),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF016290),
                    ),
                  ),
                ),
                SizedBox(width: kWidth(8)),
              ],
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'الاسم : ',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: kSize(16),
                          fontWeight: FontWeight.w700,
                          color: const Color.fromRGBO(33, 27, 18, 1),
                        ),
                      ),
                      SizedBox(width: kWidth(4)),
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: kSize(14),
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: kHeight(4)),
                  Row(
                    children: [
                      Text(
                        '${detail.substring(0, 3)} *** *** ${detail.substring(9, 11)}',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          letterSpacing: 1,
                          fontFamily: 'Cairo',
                          fontSize: kSize(14),
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(width: kWidth(4)),
                      Icon(detailIcon, size: kSize(13), color: Colors.black),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Service Details Card
// ─────────────────────────────────────────────────────────────────────────────
class _ServiceDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kSize(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: kSize(8),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Section title
          Padding(
            padding: EdgeInsets.fromLTRB(
              kWidth(14),
              kHeight(14),
              kWidth(14),
              kHeight(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: kSize(18),
                  color: kPrimaryColor,
                ),
                SizedBox(width: kWidth(6)),
                Text(
                  'تفاصيل الخدمة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: kSize(13),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D2D2D),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Padding(
            padding: EdgeInsets.all(kSize(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'نوع الخدمة', value: 'دهانات'),
                SizedBox(height: kHeight(10)),
                _DetailRow(
                  label: 'الموقع',
                  value: 'حي الزهور',
                  icon: Icons.location_on,
                ),
                SizedBox(height: kHeight(10)),
                _DetailRow(
                  label: 'الوصف',
                  value:
                      'أعمال دهانات داخلية لمبنى سكني، تشمل تجهيز الجدران و تطبيق طبقات المعجون و الدهانات التشطيبية',
                  isMultiline: true,
                ),
                SizedBox(height: kHeight(10)),
                _DetailRow(label: 'تاريخ البدء', value: '14/06/2026'),
                SizedBox(height: kHeight(10)),
                _DetailRow(label: 'المدة المتوقعة ', value: '14 يوم'),
                SizedBox(height: kHeight(16)),
                // Total cost
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: kWidth(14),
                    vertical: kHeight(12),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8EC),
                    borderRadius: BorderRadius.circular(kSize(10)),
                    border: Border.all(
                      color: kPrimaryColor.withOpacity(0.25),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'إجمالي التكلفة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: kSize(14),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D2D2D),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '5,400 ',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: kSize(22),
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF10B981),
                              ),
                            ),
                            TextSpan(
                              text: 'ج.م',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: kSize(14),
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool isMultiline;

  const _DetailRow({
    required this.label,
    required this.value,
    this.icon,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label : ',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: kSize(14),
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        SizedBox(width: kWidth(10)),

        Flexible(
          child: isMultiline
              ? Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: kSize(14),
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.6,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: kSize(14),
                        color: const Color(0xFF016290),
                      ),
                      SizedBox(width: kWidth(3)),
                    ],
                    Text(
                      value,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: kSize(13),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Contract Clauses Card
// ─────────────────────────────────────────────────────────────────────────────
class _ContractClausesCard extends StatelessWidget {
  static const List<String> _clauses = [
    'يلتزم الطرف الثاني بإنجاز الأعمال المتفق عليها وفقاً للمواصفات وفي الموعد المحدد.',
    'يلتزم الطرف الأول بدفع المبلغ المتفق عليه على دفعات يتم تحديدها وفقاً لتقدم سير العمل.',
    'أي تعديلات على نطاق العمل يجب أن تكون بموافقة خطية من كلا الطرفين وقد يترتب عليها تعديل في التكلفة والمدة.',
    'يتحمل الطرف الثاني مسؤولية توفير الأدوات والمعدات اللازمة لإنجاز العمل، ما لم يُتفق على خلاف ذلك.',
    'لا يجوز للعامل مغادرة العمل أو التوقف دون إخطار العميل والحصول على موافقته عبر التطبيق.',
    'تستقطع منصة خِدمة عمولة من إجمالي المبلغ تُطبق عند اكتمال النوتة, ',
    'يُعد هذا العقد ملزماً رقمياً فور ضغط الطرفين على "تأكيد الاتفاق" داخل التطبيق.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF0),
        borderRadius: BorderRadius.circular(kSize(12)),
        border: Border.all(color: kPrimaryColor.withOpacity(0.2), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: kSize(6),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Title
          Padding(
            padding: EdgeInsets.fromLTRB(
              kWidth(14),
              kHeight(14),
              kWidth(14),
              kHeight(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.gavel_rounded,
                  size: kSize(18),
                  color: kPrimaryColor,
                ),
                SizedBox(width: kWidth(6)),
                Text(
                  'بنود العقد',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: kSize(14),
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2D2D2D),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEFDEB0)),
          Padding(
            padding: EdgeInsets.all(kSize(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_clauses.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(bottom: kHeight(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: kSize(22),
                        height: kSize(22),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: kSize(11),
                            fontWeight: FontWeight.w800,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: kWidth(8)),
                      Expanded(
                        child: RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: kSize(13.5),
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF3D3D3D),
                              height: 1.7,
                            ),
                            children: [
                              TextSpan(text: _clauses[i]),
                              if (i == _clauses.length - 2)
                                const TextSpan(
                                  text: " وذلك بعد إنهاء الفترة المجانية.",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Digital Signatures Section
// ─────────────────────────────────────────────────────────────────────────────
class _SignaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(kSize(14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kSize(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: kSize(8),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.draw_outlined, size: kSize(18), color: kPrimaryColor),
              SizedBox(width: kWidth(6)),
              Text(
                'التوقيعات الرقمية',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: kSize(13),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D2D2D),
                ),
              ),
            ],
          ),
          SizedBox(height: kHeight(14)),

          // Sign button (Party 1 - Client hasn't signed yet)
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: kHeight(100),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF059669), Color(0xFF047857)],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                borderRadius: BorderRadius.circular(kSize(12)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF059669).withOpacity(0.3),
                    blurRadius: kSize(8),
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'توقيع الطرف الأول',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(12),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: kHeight(15)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                        size: kSize(24),
                      ),
                      SizedBox(width: kWidth(3)),
                      Text(
                        'تم التوقيع',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: kSize(17),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: kHeight(18)),

          // Party 2 signature (already signed)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(kSize(12)),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(kSize(10)),
              border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'توقيع الطرف الثاني (العامل)',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: kSize(11),
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: kHeight(8)),
                Text(
                  'محمود سمير',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: kSize(16),
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF2D2D2D),
                  ),
                ),
                SizedBox(height: kHeight(8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF059669),
                      size: 16,
                    ),
                    SizedBox(width: kWidth(4)),
                    Text(
                      'تم التوقيع',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: kSize(11),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Disclaimer Note
// ─────────────────────────────────────────────────────────────────────────────
class _DisclaimerNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(kSize(12)),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(kSize(10)),
      ),
      child: Text(
        'هذا العقد محفوظ رقمياً على منصة خِدمة، ويعتبر ملزماً للطرفين.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: kSize(16),
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade600,
          height: 1.7,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Action Bar
// ─────────────────────────────────────────────────────────────────────────────
class _BottomActionBar extends StatelessWidget {
  final VoidCallback onExportPdf;

  const _BottomActionBar({required this.onExportPdf});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: kWidth(16),
        vertical: kHeight(12),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: kSize(10),
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            // Close button
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: kHeight(46),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(kSize(12)),
                  ),
                  child: Center(
                    child: Text(
                      'إغلاق',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: kSize(13),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: kWidth(8)),

            // Share button
            _ActionIconButton(
              icon: Icons.share_outlined,
              label: 'مشاركة',
              onTap: onExportPdf,
            ),
            SizedBox(width: kWidth(8)),

            // Download PDF button
            _ActionIconButton(
              icon: Icons.download_outlined,
              label: 'PDF تنزيل',
              color: kPrimaryColor,
              textColor: kPrimaryColor,
              onTap: onExportPdf,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final Color? textColor;
  final VoidCallback onTap;

  const _ActionIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(0xFF555555);
    final tc = textColor ?? const Color(0xFF555555);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: kHeight(46),
        padding: EdgeInsets.symmetric(horizontal: kWidth(12)),
        decoration: BoxDecoration(
          color: c.withOpacity(0.08),
          borderRadius: BorderRadius.circular(kSize(12)),
          border: Border.all(color: c.withOpacity(0.25), width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: kSize(12),
                fontWeight: FontWeight.w700,
                color: tc,
              ),
            ),
            SizedBox(width: kWidth(4)),
            Icon(icon, size: kSize(18), color: c),
          ],
        ),
      ),
    );
  }
}
