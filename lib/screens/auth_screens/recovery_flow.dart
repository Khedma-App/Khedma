import 'package:flutter/material.dart';
import 'package:khedma/components/customt_login_text_form_field.dart';
import 'package:khedma/components/custum_backgrond_color.dart';
import 'package:khedma/components/custum_backgrond_image.dart';
import 'package:khedma/core/constants.dart';

class RecoveryFlow extends StatefulWidget {
  const RecoveryFlow({super.key});

  @override
  State<RecoveryFlow> createState() => _RecoveryFlowState();
  static String id = 'RecoveryFlow';
}

// الخطوات
enum RecoveryStep { enterEmail, enterCode, confirmPassword }

class _RecoveryFlowState extends State<RecoveryFlow> {
  RecoveryStep step = RecoveryStep.enterEmail;

  @override
  Widget build(BuildContext context) {
    initScreenSize(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [
          const CustumBackgrondImage(),
          const CustumBackgrondColor(),
          Positioned(
            top: kHeight(279),
            left: kWidth(106),
            child: Container(
              width: kWidth(178),
              height: kHeight(77),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/khedma.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: kHeight(516)),
                // المحتوى المتغير حسب المرحلة
                Container(
                  width: kScreenWidth,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // محتوى كل خطوة
  Widget _buildContent() {
    switch (step) {
      case RecoveryStep.enterEmail:
        return _buildEnterEmail();

      case RecoveryStep.enterCode:
        return _buildEnterCode();

      case RecoveryStep.confirmPassword:
        return _buildConfirmPassword();
    }
  }

  // أول مرحلة: إدخال الإيميل
  Widget _buildEnterEmail() {
    return Column(
      children: [
        SizedBox(height: kHeight(10)),
        _title(),
        SizedBox(height: kHeight(39)),
        CustomLoginTextFormField(
          keyboardType: TextInputType.text,

          hint: 'البريد الالكتروني او رقم الهاتف',
          width: kWidth(329),
        ),
        SizedBox(height: kHeight(50)),
        _button(
          onTap: () {
            setState(() {
              step = RecoveryStep.enterCode;
            });
          },
        ),
        SizedBox(height: kHeight(60)),
      ],
    );
  }

  // ثاني مرحلة: إدخال الكود

  Widget _buildEnterCode() {
    return Column(
      children: [
        SizedBox(height: kHeight(10)),
        _title(),

        SizedBox(height: kHeight(39)),

        CustomLoginTextFormField(
          keyboardType: TextInputType.number,

          hint: 'ادخل الكود المرسل',
          width: kWidth(329),
        ),

        SizedBox(height: kHeight(30)),

        TextButton(
          onPressed: () {
            print("إعادة إرسال الكود");
          },
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'إعادة ارسال الكود',
                  style: TextStyle(
                    color: Color(0xFFE67E22),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.refresh, color: Color(0xFFE67E22)),
              ],
            ),
          ),
        ),

        SizedBox(height: kHeight(30)),

        _button(
          onTap: () {
            setState(() {
              step = RecoveryStep.confirmPassword;
            });
          },
        ),

        SizedBox(height: kHeight(60)),
      ],
    );
  }

  // -------------------------
  // ثالث مرحلة: كلمة سر جديدة
  // -------------------------
  Widget _buildConfirmPassword() {
    return Column(
      children: [
        SizedBox(height: kHeight(10)),
        _title(),

        SizedBox(height: kHeight(39)),

        CustomLoginTextFormField(
          keyboardType: TextInputType.visiblePassword,
          hint: 'كلمة السر الجديدة',
          width: kWidth(329),
        ),

        SizedBox(height: kHeight(30)),

        CustomLoginTextFormField(
          keyboardType: TextInputType.visiblePassword,
          hint: 'تأكيد كلمة السر الجديدة',
          width: kWidth(329),
        ),

        SizedBox(height: kHeight(40)),

        _button(
          onTap: () {
            print("تم تغيير كلمة السر بنجاح");
          },
        ),

        SizedBox(height: kHeight(60)),
      ],
    );
  }

  // العنوان
  Widget _title() {
    return Container(
      width: kWidth(187),
      height: kHeight(39),
      alignment: Alignment.center,
      child: const Text(
        'إسترجاع الحساب',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Laila',
          fontWeight: FontWeight.w700,
          fontSize: 25,
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }

  // زر المتابعة
  Widget _button({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: kHeight(60),
        width: kWidth(300),
        margin: EdgeInsets.only(bottom: kHeight(40)),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(
          child: Text(
            'متابعة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
