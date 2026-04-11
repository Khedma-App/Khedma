import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/service_provider_model.dart';
import 'package:khedma/screens/service_provider_info_screen.dart';

class ServiceProviderCard extends StatelessWidget {
  const ServiceProviderCard({
    super.key,
    required this.worker,
    this.isClient = true,
    this.onFavoriteTapped,
  });

  final ServiceProviderModel worker;

  /// Whether the current user is a Client (true) or a Provider (false).
  /// Controls visibility of the 'اطلب خدمة' button.
  final bool isClient;

  /// Optional callback for the favorite button.
  /// If null, the heart icon is still displayed but does nothing.
  final VoidCallback? onFavoriteTapped;

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToInfo(context),
      child: Container(
        width: kWidth(354),
        height: kHeight(185),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kSize(16)),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.12),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(kSize(8)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kSize(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── LEFT: Profile image + Availability + Rating ──
                _buildImageSection(),
                // ── RIGHT: Info rows + Action buttons ──
                Expanded(child: _buildInfoSection(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Left Column ────────────────────────────────────────────────────────────

  Widget _buildImageSection() {
    return SizedBox(
      width: kWidth(147),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kSize(24)),
        ),
        child: Column(
          children: [
            // Profile image — fills remaining vertical space
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: worker.profileImageUrl.startsWith('http')
                    ? ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(kSize(16)),
                        ),
                        child: Image.network(
                          worker.profileImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/images/naqash.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Image.asset(
                        'assets/images/naqash.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            // Availability banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: kHeight(4)),
              color: worker.isAvailable
                  ? const Color(0xFFF2991D)
                  : Colors.grey[600],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    worker.isAvailable ? 'متاح للعمل' : 'غير متاح',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(10),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: kWidth(4)),
                  Container(
                    width: kSize(8),
                    height: kSize(8),
                    decoration: BoxDecoration(
                      color: worker.isAvailable ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),

            // Rating row
            Padding(
              padding: EdgeInsets.symmetric(vertical: kHeight(6)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '( ${worker.completedOrders} )',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(11),
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(width: kWidth(3)),
                  Text(
                    worker.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(13),
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: kWidth(2)),
                  Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                    size: kSize(18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Right Column ───────────────────────────────────────────────────────────

  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: kWidth(10),
        vertical: kHeight(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Name
          Text(
            worker.fullName,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: kSize(18),
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: kHeight(3)),

          // Profession
          _buildInfoRow(icon: Icons.handyman_outlined, text: worker.profession),
          SizedBox(height: kHeight(2)),

          // Governorate
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            text: worker.governorate,
          ),
          SizedBox(height: kHeight(2)),

          // Completed orders
          _buildInfoRow(
            icon: Icons.check_circle_outline,
            text: '${worker.completedOrders} مكتمل',
          ),
          SizedBox(height: kHeight(2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                worker.pricingType.isNotEmpty ? worker.pricingType : 'بالإتفاق',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: kSize(13),
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: kWidth(3)),
              Icon(
                Icons.monetization_on_outlined,
                color: const Color.fromARGB(255, 59, 183, 145),
                size: kSize(18),
              ),
            ],
          ),

          // Pricing type
          // _buildInfoRow(
          //   icon: Icons.monetization_on_outlined,
          //   text: worker.pricingType.isNotEmpty
          //       ? worker.pricingType
          //       : 'بالإتفاق',
          // ),
          // ── Bottom action row (only shown for Clients) ──
          if (isClient) ...[
            const Spacer(),
            Row(
              children: [
                // Favorite button
                GestureDetector(
                  onTap: onFavoriteTapped,
                  child: Icon(
                    worker.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: worker.isFavorite ? Colors.red : Colors.grey[400],
                    size: kSize(24),
                  ),
                ),
                const Spacer(),
                // Request service button
                GestureDetector(
                  onTap: () => _navigateToInfo(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: kWidth(16),
                      vertical: kHeight(5),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2991D),
                      borderRadius: BorderRadius.circular(kSize(20)),
                    ),
                    child: Text(
                      'اطلب خدمة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: kSize(13),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  /// Builds a single info row: [text ‹gap› icon] — right-aligned.
  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: kSize(12),
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
          ),
        ),
        SizedBox(width: kWidth(4)),
        Icon(icon, size: kSize(16), color: Colors.grey[500]),
      ],
    );
  }

  /// Navigate to the provider's full info screen.
  void _navigateToInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceProviderInfoScreen(worker: worker),
      ),
    );
  }
}
