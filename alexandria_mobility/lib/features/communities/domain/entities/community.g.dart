// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommunityImpl _$$CommunityImplFromJson(Map<String, dynamic> json) =>
    _$CommunityImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      type: json['type'] as String,
      city: json['city'] as String,
      area: json['area'] as String,
      address: json['address'] as String,
      adminName: json['adminName'] as String,
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      description: json['description'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CommunityImplToJson(_$CommunityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'city': instance.city,
      'area': instance.area,
      'address': instance.address,
      'adminName': instance.adminName,
      'memberCount': instance.memberCount,
      'isActive': instance.isActive,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
