import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/l10n/app_localizations.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  bool _isArabic = true;

  @override
  Widget build(BuildContext context) {
    // Get translations manually for this specific page
    final l10n = lookupAppLocalizations(Locale(_isArabic ? 'ar' : 'en'));

    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            'خدمة',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: kPrimaryColor,
              fontWeight: FontWeight.w900,
              fontSize: kSize(22),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _isArabic = !_isArabic;
                });
              },
              child: Text(
                _isArabic ? 'EN' : 'عربي',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: kSize(14),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: kWidth(16),
            vertical: kHeight(10),
          ),
          child: Column(
            children: [
              // Top Section (Main Intro)
              _buildMainIntroCard(l10n),
              SizedBox(height: kHeight(16)),

              // Mission and Vision
              Row(
                children: [
                  Expanded(
                    child: _buildMissionVisionCard(
                      icon: Icons.handshake_rounded,
                      title: l10n.ourMission,
                      desc: l10n.missionDesc,
                    ),
                  ),
                  SizedBox(width: kWidth(12)),
                  Expanded(
                    child: _buildMissionVisionCard(
                      icon: Icons.rocket_launch_rounded,
                      title: l10n.ourVision,
                      desc: l10n.visionDesc,
                    ),
                  ),
                ],
              ),
              SizedBox(height: kHeight(30)),

              // Team Section Header
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: kPrimaryColor.withValues(alpha: 0.5),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kWidth(12)),
                    child: Text(
                      l10n.ourTeam,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontSize: kSize(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: kPrimaryColor.withValues(alpha: 0.5),
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: kHeight(20)),

              // Team Members Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: kHeight(12),
                crossAxisSpacing: kWidth(12),
                childAspectRatio: 0.9,
                children: [
                  _buildTeamMemberCard(
                    'شريف',
                    'Flutter Developer',
                    'assets/images/sherif.jpeg',
                  ),
                  _buildTeamMemberCard(
                    'ياسين',
                    'Backend Developer',
                    'assets/images/yasin.jpg',
                  ),
                  _buildTeamMemberCard(
                    'Mohamed Sayed',
                    'UI/UX Designer',
                    'assets/images/naqash.jpg',
                  ),
                  _buildTeamMemberCard(
                    'عبدالعليم',
                    'Project Manager',
                    'assets/images/naqash.jpg',
                  ), // The 4th member
                ],
              ),
              SizedBox(height: kHeight(20)),

              // Stats Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(Icons.group_rounded, '+10K', l10n.usersCount),
                  _buildStatCard(
                    Icons.engineering_rounded,
                    '+3K',
                    l10n.providersCount,
                  ),
                  _buildStatCard(
                    Icons.star_rounded,
                    '98%',
                    l10n.customerSatisfaction,
                  ),
                  _buildStatCard(
                    Icons.headset_mic_rounded,
                    '24/7',
                    l10n.support247,
                  ),
                ],
              ),
              SizedBox(height: kHeight(30)),

              // Footer
              Text(
                l10n.footerText,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.grey[400],
                  fontSize: kSize(12),
                ),
              ),
              SizedBox(height: kHeight(30)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainIntroCard(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(kSize(20)),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kPrimaryColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            l10n.aboutKhedma,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.white,
              fontSize: kSize(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: kHeight(4)),
          Text(
            l10n.aboutSubtitle,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.grey[400],
              fontSize: kSize(12),
            ),
          ),
          SizedBox(height: kHeight(20)),
          Text(
            l10n.aboutHeadline1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.white,
              fontSize: kSize(16),
              fontWeight: FontWeight.w800,
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: kSize(16),
                fontWeight: FontWeight.w800,
              ),
              children: [
                TextSpan(
                  text: 'دي منصة بتوصل ',
                  style: const TextStyle(color: Colors.white),
                ),
                TextSpan(
                  text: 'الثقة ',
                  style: TextStyle(color: kPrimaryColor),
                ),
                TextSpan(
                  text: 'لحد باب بيتك',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: kHeight(16)),
          Text(
            l10n.aboutDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.grey[400],
              fontSize: kSize(12),
              height: 1.6,
            ),
          ),
          SizedBox(height: kHeight(24)),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: kWidth(40),
                vertical: kHeight(12),
              ),
            ),
            child: Text(
              l10n.startNow,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Colors.white,
                fontSize: kSize(14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVisionCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: EdgeInsets.all(kSize(16)),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        children: [
          Icon(icon, color: kPrimaryColor, size: kSize(32)),
          SizedBox(height: kHeight(12)),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.white,
              fontSize: kSize(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: kHeight(8)),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.grey[400],
              fontSize: kSize(11),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard(String name, String role, String imagePath) {
    return Container(
      padding: EdgeInsets.all(kSize(12)),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: kSize(30),
            backgroundColor: const Color(0xFF2A2A2A),
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(height: kHeight(12)),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.white,
              fontSize: kSize(14),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: kHeight(4)),
          Text(
            role,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: kPrimaryColor,
              fontSize: kSize(11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      width: kWidth(80),
      padding: EdgeInsets.symmetric(
        vertical: kHeight(12),
        horizontal: kWidth(4),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        children: [
          Icon(icon, color: kPrimaryColor, size: kSize(24)),
          SizedBox(height: kHeight(8)),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: kPrimaryColor,
              fontSize: kSize(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: kHeight(4)),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.grey[400],
              fontSize: kSize(10),
            ),
          ),
        ],
      ),
    );
  }
}
