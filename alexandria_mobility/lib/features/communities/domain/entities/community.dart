import 'package:freezed_annotation/freezed_annotation.dart';

part 'community.freezed.dart';
part 'community.g.dart';

@freezed
class Community with _$Community {
  const factory Community({
    required int id,
    required String name,
    required String type,
    required String city,
    required String area,
    required String address,
    required String adminName,
    @Default(0) int memberCount,
    @Default(true) bool isActive,
    String? description,
    DateTime? createdAt,
  }) = _Community;

  factory Community.fromJson(Map<String, dynamic> json) =>
      _$CommunityFromJson(json);
}
