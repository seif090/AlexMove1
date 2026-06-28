import 'package:alexandria_mobility/core/network/api_response.dart';
import '../../domain/entities/group.dart';

class GroupResponse {
  final bool isSuccess;
  final PaginatedResponse<Group>? data;
  final String? message;
  final List<String> errors;

  GroupResponse({
    required this.isSuccess,
    this.data,
    this.message,
    this.errors = const [],
  });

  factory GroupResponse.fromJson(Map<String, dynamic> json) {
    return GroupResponse(
      isSuccess: json['isSuccess'] as bool? ?? false,
      data: json['data'] != null
          ? PaginatedResponse.fromJson(
              json['data'] as Map<String, dynamic>,
              (item) => Group.fromJson(item as Map<String, dynamic>),
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

class SubscribeGroupRequest {
  final int groupId;

  SubscribeGroupRequest({required this.groupId});

  Map<String, dynamic> toJson() => {'groupId': groupId};
}
