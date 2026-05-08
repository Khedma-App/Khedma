import 'package:flutter/material.dart';
import 'package:khedma/components/custom_payment_card.dart'; // تأكد أن اسمها PaymentCardWidget أو قم بتغيير الاستدعاء
import 'package:khedma/core/constants.dart';

enum PaymentMethod { cash, transfer }

class CustomPaymentMethodSection extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final Function(PaymentMethod) onMethodChanged;

  const CustomPaymentMethodSection({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kSize(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'طريقة الدفع',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: kSize(16),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF211B12),
            ),
          ),
          SizedBox(height: kHeight(12)),
          Row(
            children: [
              Expanded(
                child: PaymentCardWidget(
                  title: 'تحويل بنكي /\nمحفظة',
                  icon: Icons.smartphone_outlined,
                  isSelected: selectedMethod == PaymentMethod.transfer,
                  onTap: () => onMethodChanged(PaymentMethod.transfer),
                ),
              ),
              SizedBox(width: kWidth(12)),
              Expanded(
                child: PaymentCardWidget(
                  title: 'نقدي',
                  icon: Icons.payments_outlined,
                  isSelected: selectedMethod == PaymentMethod.cash,
                  onTap: () => onMethodChanged(PaymentMethod.cash),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
