import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class PublishButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const PublishButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: Container(
          height: kHeight(60),
          width: kWidth(300),
          margin: EdgeInsets.only(bottom: kSize(28)),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: kSize(10),
                offset: Offset(0, 4),
              ),
            ],
            color: Colors.orange,
            borderRadius: BorderRadius.all(Radius.circular(kSize(30))),
          ),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    'نشر الخدمة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: kSize(20),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
