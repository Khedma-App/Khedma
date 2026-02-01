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

enum RecoveryStep { enterEmail, enterCode, confirmPassword }

class _RecoveryFlowState extends State<RecoveryFlow> {
  RecoveryStep step = RecoveryStep.enterEmail;

  @override
  Widget build(BuildContext context) {
    initScreenSize(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    const CustumBackgrondImage(),
                    const CustumBackgrondColor(),

                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: kHeight(279)),
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

                    Column(
                      children: [
                        SizedBox(height: kHeight(516)),
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

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

  Widget _buildEnterEmail() {
    return Column(
      children: [
        SizedBox(height: kHeight(10)),
        _title(),
        SizedBox(height: kHeight(39)),
        CustomLoginTextFormField(
          keyboardType: TextInputType.number,

          hint: 'ادخل رقم الهاتف',
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
    SizedBox(height: kHeight(40));
  }
}
