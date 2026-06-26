import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/cubits/providers_cubit/providers_cubit.dart';
import 'package:khedma/models/service_provider_model.dart';
import 'package:khedma/screens/booking_details_screen.dart';
import 'package:khedma/services/user_service.dart';
import 'package:khedma/models/review_model.dart';

class ServiceProviderInfoScreen extends StatefulWidget {
  const ServiceProviderInfoScreen({super.key, required this.worker});

  final ServiceProviderModel worker;

  static String id = 'service_provider_info_screen';

  @override
  State<ServiceProviderInfoScreen> createState() =>
      _ServiceProviderInfoScreenState();
}

class _ServiceProviderInfoScreenState extends State<ServiceProviderInfoScreen> {
  final PageController _imagesController = PageController();
  int _currentImageIndex = 0;

  /// Real images from the worker's profile; falls back to a placeholder.
  List<String> get _workImages {
    final images = widget.worker.imagesOfPreviousWorks;
    if (images.isEmpty) {
      return ['assets/images/naqash.jpg'];
    }
    return images;
  }

  /// Build service chips from profession + optional service description.
  List<String> get _serviceLabels {
    final labels = <String>[];
    if (widget.worker.profession.isNotEmpty) {
      labels.add(widget.worker.profession);
    }
    final desc = widget.worker.serviceDescription ?? '';
    if (desc.isNotEmpty) {
      labels.add(desc);
    }
    return labels.isEmpty ? ['غير محدد'] : labels;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var imageUrl in _workImages) {
      if (imageUrl.startsWith('http')) {
        precacheImage(NetworkImage(imageUrl), context).catchError((_) {
          // Silently handle network errors (offline / DNS failure)
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: kHeight(60)),

            //  العنوان العلوي
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kWidth(20)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'طلب خدمة',
                    style: TextStyle(
                      fontSize: kSize(20),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: Colors.black,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: kSize(22),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: kHeight(25)),

            //   سكشن عرض الصور
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: kHeight(256),
                  width: double.infinity,
                  child: PageView.builder(
                    controller: _imagesController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemCount: _workImages.length,
                    itemBuilder: (context, index) {
                      final img = _workImages[index];
                      final isNetwork = img.startsWith('http');
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          // 1. Blurred Background
                          isNetwork
                              ? CachedNetworkImage(imageUrl: img, fit: BoxFit.cover)
                              : Image.asset(img, fit: BoxFit.cover),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                            child: Container(color: Colors.black.withValues(alpha: 0.2)),
                          ),
                          // 2. Foreground Contained Image
                          isNetwork
                              ? CachedNetworkImage(
                                  imageUrl: img,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (_, __, ___) => Image.asset(
                                    'assets/images/naqash.jpg',
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Image.asset(img, fit: BoxFit.contain),
                        ],
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: kHeight(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _workImages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentImageIndex == index
                            ? kWidth(20)
                            : kWidth(8),
                        height: kHeight(8),
                        decoration: BoxDecoration(
                          color: _currentImageIndex == index
                              ? Colors.amber
                              : Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: kHeight(20)),

            //  3. كارت معلومات مقدم الخدمة
            Container(
              width: kWidth(354),
              height: kHeight(75),
              margin: EdgeInsets.symmetric(
                horizontal: kWidth(20),
                vertical: kHeight(10),
              ),
              padding: EdgeInsets.all(kSize(12)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kSize(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: kSize(12),
                    offset: Offset(0, kHeight(4)),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.worker.fullName,
                        style: TextStyle(
                          fontSize: kSize(18),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: kHeight(4)),
                      Text(
                        widget.worker.profession,
                        style: TextStyle(
                          fontSize: kSize(14),
                          fontFamily: 'Cairo',
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: kWidth(15)),
                  Container(
                    width: kSize(60),
                    height: kSize(60),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipOval(
                      child: widget.worker.profileImageUrl.startsWith('http')
                          ? CachedNetworkImage(
                              imageUrl: widget.worker.profileImageUrl,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (_, __, ___) => Image.asset(
                                'assets/images/profile.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              widget.worker.profileImageUrl.startsWith('assets')
                                  ? widget.worker.profileImageUrl
                                  : 'assets/images/profile.png',
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                    ),
                  ),
                ],
              ),
            ),

            //  شريط الحالة والموقع
            Container(
              width: kWidth(354),
              height: kHeight(45),
              margin: EdgeInsets.symmetric(
                horizontal: kWidth(20),
                vertical: kHeight(5),
              ),
              padding: EdgeInsets.symmetric(horizontal: kWidth(15)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kSize(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: kSize(8),
                    offset: Offset(0, kHeight(2)),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // الحالة
                  Row(
                    children: [
                      Text(
                        widget.worker.isAvailable
                            ? 'متاح الآن'
                            : 'غير متاح',
                        style: TextStyle(
                          fontSize: kSize(13),
                          fontFamily: 'Cairo',
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: kWidth(6)),
                      CircleAvatar(
                        radius: kSize(5),
                        backgroundColor: widget.worker.isAvailable
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ),
                  // التقييم
                  Row(
                    children: [
                      Text(
                        '0 تقييم',
                        style: TextStyle(
                          fontSize: kSize(13),
                          fontFamily: 'Cairo',
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: kWidth(4)),
                      Icon(
                        Icons.star_border_rounded,
                        color: Colors.grey[500],
                        size: kSize(20),
                      ),
                    ],
                  ),
                  // الموقع
                  Row(
                    children: [
                      Text(
                        widget.worker.governorate,
                        style: TextStyle(
                          fontSize: kSize(13),
                          fontFamily: 'Cairo',
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: kWidth(4)),
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey[500],
                        size: kSize(20),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //  كروت الإحصائيات
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: kWidth(20),
                vertical: kHeight(15),
              ),
              child: Row(
                children: [
                  _buildStatCard(
                    title: 'سنين الخبرة',
                    value: '${widget.worker.yearsOfExperience ?? 0}',
                  ),
                  SizedBox(width: kWidth(10)),
                  _buildStatCard(
                    title: 'خدمة مكتملة',
                    value: '0',
                  ),
                  SizedBox(width: kWidth(10)),
                  _buildStatCard(
                    title: widget.worker.pricingType.isNotEmpty
                        ? widget.worker.pricingType
                        : 'حسب المعاينة',
                    value: 'السعر',
                  ),
                ],
              ),
            ),
            //  سكشن الخدمات
            Container(
              width: kWidth(354),
              margin: EdgeInsets.symmetric(
                horizontal: kWidth(20),
                vertical: kHeight(10),
              ),
              padding: EdgeInsets.all(kSize(16)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kSize(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: kSize(10),
                    offset: Offset(0, kHeight(4)),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'الخدمات',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: kHeight(12)),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Wrap(
                      spacing: kWidth(8),
                      runSpacing: kHeight(8),
                      children: [
                        ..._serviceLabels.map(
                          (label) => _buildServiceChip(label),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ////////////////////// عن العامل
            Container(
              width: kWidth(354),
              height: kHeight(300),
              padding: EdgeInsets.all(kSize(20)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'عن العامل',
                    style: TextStyle(
                      fontSize: kSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: kHeight(5)),
                  Text(
                    widget.worker.overviewOfExperience?.isNotEmpty == true
                        ? widget.worker.overviewOfExperience!
                        : 'لا توجد نبذة',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: kSize(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(thickness: 1),
                  ),
                  const Text(
                    'الآراء',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Dynamic Reviews
                  if (widget.worker.id != null)
                    FutureBuilder<List<ReviewModel>>(
                      future: UserService().getProviderReviews(widget.worker.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        final reviews = snapshot.data ?? [];
                        if (reviews.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('لا توجد آراء حتى الآن', style: TextStyle(fontFamily: 'Cairo', color: Colors.grey)),
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final r = reviews[index];
                            final avgRating = ((r.negotiationRating ?? 0) + (r.serviceRating ?? 0)) / 
                                ((r.negotiationRating != null ? 1 : 0) + (r.serviceRating != null ? 1 : 0)).clamp(1, 2);
                            final comment = r.serviceComment ?? r.negotiationComment ?? '';
                            
                            return Container(
                              padding: EdgeInsets.all(kSize(12)),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(kSize(15)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.star, color: Colors.amber, size: kSize(20)),
                                          Text(
                                            ' ${avgRating.toStringAsFixed(1)}',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        r.clientName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: kSize(13),
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (comment.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      '“$comment”',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: kSize(12),
                                        fontFamily: 'Cairo',
                                      ),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ]
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
            SizedBox(height: kSize(15)),

            //  زر التأكيد النهائي (طلب خدمة) — للعملاء فقط
            if (context.read<ProvidersCubit>().isClient)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          BookingDetailsScreen(worker: widget.worker),
                    ),
                  );
                },
                child: Container(
                  height: kHeight(60),
                  width: kWidth(300),
                  margin: const EdgeInsets.only(bottom: 28),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    color: const Color(0xFFF2991D),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: const Center(
                    child: Text(
                      'طلب خدمة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _imagesController.dispose();
    super.dispose();
  }

  Widget _buildStatCard({required String title, required String value}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(kSize(12)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kSize(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: kSize(10),
              offset: Offset(0, kHeight(4)),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: kSize(16),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: kHeight(5)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: kSize(12),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildServiceChip(String label) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: kWidth(12), vertical: kHeight(6)),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F5F5),
      borderRadius: BorderRadius.circular(kSize(10)),
      border: Border.all(color: const Color(0xFFD1D1D1), width: 0.8),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: kSize(12),
        color: const Color(0xFF838383),
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
