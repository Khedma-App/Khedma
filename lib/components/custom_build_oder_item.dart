import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/order_model.dart';

class CustomBuildOderItem extends StatelessWidget {
  const CustomBuildOderItem({super.key, required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kSize(15), vertical: kSize(8)),
      padding: EdgeInsets.all(kSize(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kSize(15)),
        border: Border.all(color: const Color(0xFFE19113), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${order.price} ج.م",
                style: TextStyle(
                  color: order.statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: kSize(20),
                ),
              ),

              SizedBox(width: kWidth(5)),

              Flexible(
                child: Text(
                  order.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kSize(12),
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: kHeight(8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, color: order.statusColor, size: kSize(10)),
                  SizedBox(width: kWidth(4)),
                  Text(
                    order.status,
                    style: TextStyle(
                      fontSize: kSize(12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                order.details,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: kSize(12),
                  color: Colors.black,
                ),
              ),
            ],
          ),

          Divider(
            height: kHeight(25),
            color: const Color(0xFFEF9B17),
            thickness: 2,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE19113),
                    borderRadius: BorderRadius.circular(kSize(12)),
                  ),
                  child: const Center(
                    child: Text(
                      "طلب مجدداً",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              order.showStars
                  ? Row(
                      children: [
                        const Text(
                          "5.0",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Row(
                          children: List.generate(
                            5,
                            (index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      order.bottomText ?? "",
                      style: TextStyle(
                        color: order.statusColor,
                        fontSize: kSize(12),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
