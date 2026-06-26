import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String providerId;
  final String clientId;
  final String clientName;
  final String chatRoomId;

  final double? negotiationRating;
  final String? negotiationComment;

  final double? serviceRating;
  final String? serviceComment;

  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.providerId,
    required this.clientId,
    required this.clientName,
    required this.chatRoomId,
    this.negotiationRating,
    this.negotiationComment,
    this.serviceRating,
    this.serviceComment,
    required this.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return ReviewModel(
      id: id,
      providerId: map['providerId'] as String? ?? '',
      clientId: map['clientId'] as String? ?? '',
      clientName: map['clientName'] as String? ?? '',
      chatRoomId: map['chatRoomId'] as String? ?? '',
      negotiationRating: (map['negotiationRating'] as num?)?.toDouble(),
      negotiationComment: map['negotiationComment'] as String?,
      serviceRating: (map['serviceRating'] as num?)?.toDouble(),
      serviceComment: map['serviceComment'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      'clientId': clientId,
      'clientName': clientName,
      'chatRoomId': chatRoomId,
      if (negotiationRating != null) 'negotiationRating': negotiationRating,
      if (negotiationComment != null) 'negotiationComment': negotiationComment,
      if (serviceRating != null) 'serviceRating': serviceRating,
      if (serviceComment != null) 'serviceComment': serviceComment,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
