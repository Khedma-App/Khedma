import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

/// The top hero section of the Home Screen.
///
/// Contains the background image, logo, tagline,
/// current location display, and the search bar.
class HomeHeader extends StatelessWidget {
  final String currentLocation;

  const HomeHeader({super.key, required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kHeight(247),
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        image: DecorationImage(
          image: AssetImage('assets/images/home_background2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: kHeight(47)),

          // ── Logo ──
          Row(
            children: [
              const Spacer(),
              Image.asset('assets/images/logo.png', width: kWidth(115)),
              SizedBox(width: kWidth(20)),
            ],
          ),

          // ── Tagline ──
          Row(
            children: [
              const Spacer(),
              Text(
                '! كل الخدمات في جيبك',
                style: TextStyle(
                  shadows: const [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                  ],
                  fontSize: kSize(20),
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: kWidth(20)),
            ],
          ),
          SizedBox(height: kHeight(25)),

          // ── Location label ──
          Row(
            children: [
              SizedBox(width: kWidth(37)),
              Text(
                'المنطقة الحالية',
                style: TextStyle(
                  fontSize: kSize(16),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
            ],
          ),

          // ── Location bar + Search ──
          Container(
            margin: EdgeInsets.symmetric(horizontal: kWidth(15)),
            height: kHeight(56),
            decoration: BoxDecoration(
              color: const Color(0xFFEF9B17),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                SizedBox(width: kWidth(15)),
                // Current location text
                Expanded(
                  child: Text(
                    currentLocation,
                    style: TextStyle(
                      fontSize: kSize(14),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: kWidth(5)),
                Image.asset(
                  'assets/images/location.png',
                  width: kWidth(24),
                ),
                SizedBox(width: kWidth(10)),
                // Search field
                Container(
                  width: kWidth(220),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(
                          right: kWidth(12),
                          left: kWidth(12),
                        ),
                        child: Image.asset(
                          'assets/images/search.png',
                          width: kWidth(10),
                        ),
                      ),
                      hintText: 'ابحث عن الخدمات الي انت محتاجها',
                      hintStyle: TextStyle(
                        fontSize: kSize(11),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFBDBDBD),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        left: kWidth(15),
                        top: kHeight(18),
                        bottom: kHeight(18),
                      ),
                    ),
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
