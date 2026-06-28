import 'package:alexandria_mobility/core/network/api_response.dart';
import '../../domain/entities/community.dart';

class CommunityResponse {
  final bool isSuccess;
  final PaginatedResponse<Community>? data;
  final String? message;
  final List<String> errors;

  CommunityResponse({
    required this.isSuccess,
    this.data,
    this.message,
    this.errors = const [],
  });

  factory CommunityResponse.fromJson(Map<String, dynamic> json) {
    return CommunityResponse(
      isSuccess: json['isSuccess'] as bool? ?? false,
      data: json['data'] != null
          ? PaginatedResponse.fromJson(
              json['data'] as Map<String, dynamic>,
              (item) => Community.fromJson(item as Map<String, dynamic>),
            )
          : null,
      message: json['message'] as String?,
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class JoinCommunityRequest {
  final int communityId;

  JoinCommunityRequest({required this.communityId});

  Map<String, dynamic> toJson() => {'communityId': communityId};
}
