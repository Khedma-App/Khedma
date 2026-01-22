import 'package:flutter/material.dart';
import 'package:khedma/components/section_item.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/screens/welcome_screen.dart';

class Sections extends StatefulWidget {
  Sections({super.key});

  static String id = 'Sections';

  @override
  State<Sections> createState() => _SectionsState();
}

class _SectionsState extends State<Sections> {
  final List<String> egyptGovernorates = [
    "القاهرة",
    "الجيزة",
    "الإسكندرية",
    "الدقهلية",
    "البحر الأحمر",
    "البحيرة",
    "الفيوم",
    "الغربية",
    "الإسماعيلية",
    "المنوفية",
    "المنيا",
    "القليوبية",
    "الوادي الجديد",
    "السويس",
    "اسوان",
    "اسيوط",
    "سوهاج",
    "بني سويف",
    "بورسعيد",
    "دمياط",
    "الشرقية",
    "جنوب سيناء",
    "كفر الشيخ",
    "مطروح",
    "الأقصر",
    "قنا",
    "شمال سيناء",
  ];

  String? selectedGovernorate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE19113),
        toolbarHeight: 100,
        centerTitle: true,
        leading: const SizedBox(),
        title: SizedBox(
          width: kWidth(103),
          height: kHeight(45),
          child: Image.asset("assets/images/logo.png", fit: BoxFit.contain),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: kHeight(20)),
            Center(
              child: Container(
                height: kHeight(50),
                width: kWidth(347),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 0),
                      blurRadius: 5,
                      spreadRadius: 0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: DropdownButton<String>(
                      hint: Text(
                        'اختر المحافظة او المنطقة الأقرب لك',
                        style: TextStyle(
                          color: const Color(0xFF838383).withOpacity(0.5),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      value: selectedGovernorate,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                        size: 50,
                      ),
                      items: egyptGovernorates.map<DropdownMenuItem<String>>((
                        String governorate,
                      ) {
                        return DropdownMenuItem<String>(
                          value: governorate,
                          alignment: Alignment.centerRight,
                          child: Text(
                            governorate,
                            style: const TextStyle(fontFamily: 'Laila'),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedGovernorate = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: kHeight(30)),

            GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              mainAxisSpacing: kHeight(20),
              crossAxisSpacing: kWidth(10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SectionItem(
                  title: 'مـقاولات',
                  imagePath: 'assets/images/مقاولات.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    );
                  },
                ),
                SectionItem(
                  title: 'حــــــرف',
                  imagePath: 'assets/images/حرف.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    );
                  },
                ),
                SectionItem(
                  title: 'عيــادات بيطرية',
                  imagePath: 'assets/images/عيادات بيطاريه.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    );
                  },
                ),
                SectionItem(
                  title: 'عيــادات',
                  imagePath: 'assets/images/عيادات.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: kHeight(30)),
          ],
        ),
      ),
    );
  }
}
