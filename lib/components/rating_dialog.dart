import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/review_model.dart';
import 'package:khedma/services/user_service.dart';

class RatingDialog extends StatefulWidget {
  final String providerId;
  final String clientId;
  final String clientName;
  final String chatRoomId;

  const RatingDialog({
    Key? key,
    required this.providerId,
    required this.clientId,
    required this.clientName,
    required this.chatRoomId,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required String providerId,
    required String clientId,
    required String clientName,
    required String chatRoomId,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RatingDialog(
        providerId: providerId,
        clientId: clientId,
        clientName: clientName,
        chatRoomId: chatRoomId,
      ),
    );
  }

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  final UserService _userService = UserService();
  bool _isLoading = true;
  ReviewModel? _existingReview;

  // Negotiation state
  double _negotiationRating = 0.0;
  final TextEditingController _negotiationCommentController =
      TextEditingController();

  // Service state
  double _serviceRating = 0.0;
  final TextEditingController _serviceCommentController =
      TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchReview();
  }

  Future<void> _fetchReview() async {
    try {
      final review = await _userService.getReviewByChatRoomId(
        widget.providerId,
        widget.chatRoomId,
      );
      if (review != null) {
        setState(() {
          _existingReview = review;
          _negotiationRating = review.negotiationRating ?? 0.0;
          _negotiationCommentController.text = review.negotiationComment ?? '';

          _serviceRating = review.serviceRating ?? 0.0;
          _serviceCommentController.text = review.serviceComment ?? '';
        });
      }
    } catch (e) {
      // ignore
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _submit() async {
    if (_negotiationRating == 0.0 && _serviceRating == 0.0) return;

    setState(() => _isSubmitting = true);

    try {
      final review = ReviewModel(
        id: _existingReview?.id ?? '',
        providerId: widget.providerId,
        clientId: widget.clientId,
        clientName: widget.clientName,
        chatRoomId: widget.chatRoomId,
        negotiationRating: _negotiationRating > 0 ? _negotiationRating : null,
        negotiationComment: _negotiationCommentController.text.trim().isNotEmpty
            ? _negotiationCommentController.text.trim()
            : null,
        serviceRating: _serviceRating > 0 ? _serviceRating : null,
        serviceComment: _serviceCommentController.text.trim().isNotEmpty
            ? _serviceCommentController.text.trim()
            : null,
        createdAt: _existingReview?.createdAt ?? DateTime.now(),
      );

      await _userService.submitReview(review);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم حفظ التقييم بنجاح',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e', style: TextStyle(fontFamily: 'Cairo')),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _buildStarRating(double rating, ValueChanged<double> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 32,
          ),
          onPressed: () => onChanged(index + 1.0),
        );
      }).reversed.toList(), // RTL layout
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'تقييم العامل',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Negotiation Rating Section
                  const Text(
                    'تقييم التفاوض',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildStarRating(
                    _negotiationRating,
                    (val) => setState(() => _negotiationRating = val),
                  ),
                  TextField(
                    controller: _negotiationCommentController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'اكتب تعليقك حول التفاوض (اختياري)',
                      hintStyle: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),

                  // Service Rating Section (only show if negotiation was rated previously)
                  if (_existingReview?.negotiationRating != null) ...[
                    const Divider(),
                    const SizedBox(height: 12),
                    const Text(
                      'تقييم الخدمة المقدمة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '(يمكنك إضافته بعد الانتهاء من الخدمة)',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    _buildStarRating(
                      _serviceRating,
                      (val) => setState(() => _serviceRating = val),
                    ),
                    TextField(
                      controller: _serviceCommentController,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'اكتب تعليقك حول الخدمة (اختياري)',
                        hintStyle: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'حفظ التقييم',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
