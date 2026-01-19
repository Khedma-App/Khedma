import 'package:flutter/material.dart';
import 'package:khedma/components/service_options_boutton.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/screens/service_provider_register_screen.dart';
import 'package:khedma/screens/service_requester_register_screen.dart';

class RegisterOptions extends StatefulWidget {
  const RegisterOptions({super.key});

  @override
  State<RegisterOptions> createState() => _RegisterOptionsState();
}

class _RegisterOptionsState extends State<RegisterOptions> {
  int selectedRole = 0; // 0: None, 1: Provider, 2: Requester

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: kHeight(14)),
        ServiceOptionsBoutton(
          text: 'مقدم خدمة',
          isSelected: selectedRole == 1,
          onTap: () => setState(() => selectedRole = 1),
        ),

        SizedBox(height: kHeight(20)),

        ServiceOptionsBoutton(
          text: 'طالب خدمة',
          isSelected: selectedRole == 2,
          onTap: () => setState(() => selectedRole = 2),
        ),

        SizedBox(height: kHeight(55)),

        // Continue Button
        GestureDetector(
          onTap: () {
            switch (selectedRole) {
              case 0:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "الرجاء اختيار نوع الحساب",
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                break;
              case 1:
                Navigator.pushNamed(context, ServiceProviderRegisterScreen.id);
                break;
              case 2:
                Navigator.pushNamed(context, ServiceRequesterRegisterScreen.id);
                break;
            }
          },
          child: Container(
            height: kHeight(60),
            width: kWidth(300),
            margin: const EdgeInsets.only(right: 20, left: 20, bottom: 16),
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
              color: Colors.orange,
              borderRadius: BorderRadius.all(Radius.circular(30)),
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
        ),
      ],
    );
  }
}
