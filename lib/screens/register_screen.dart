import 'dart:io';

import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/screens/service_provider_register_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  static String id = 'register-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bac.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: kHeight(290)),
              Expanded(
                child: Container(
                  width: kScreenWidth,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x00E19113), Color(0xbbEF9B17)],
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: kHeight(130)),
                      Expanded(
                        child: Container(
                          width: kScreenWidth,
                          // height: kScreenHeight * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: kHeight(29)),
                              //login and register buttons
                              Container(
                                width: kWidth(330),
                                height: kHeight(50),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.25),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // login button
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: SizedBox(
                                        width: kScreenWidth * 0.39,
                                        child: Center(
                                          child: Text(
                                            'تسجيل الدخول',
                                            style: TextStyle(
                                              color: Color(0xFF838383),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // register button
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: kScreenHeight * 0.05,
                                        width: kScreenWidth * 0.39,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color: Colors.orange,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'إنشاء حساب',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: kHeight(81)),
                              // Service provider
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    ServiceProviderRegisterScreen.id,
                                  );
                                },
                                child: Container(
                                  width: kWidth(250),
                                  height: kHeight(50),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.25),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.orange,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'مقدم خِدمه',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: kHeight(17)),
                              // Service applicant
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: kWidth(250),
                                  height: kHeight(50),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.25),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.orange,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'طالب خِدمه',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: kHeight(59)),
                              // Continue button
                              GestureDetector(
                                onTap: () {
                                  // Handle login action
                                },
                                child: Container(
                                  height: kHeight(60),
                                  width: kWidth(300),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  child: Center(
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
                              // SizedBox(height: kHeight(51),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
