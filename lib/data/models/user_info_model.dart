import 'package:ns_buddy/domain/entities/user_info_entity.dart';

class UserInfoModel extends UserInfoEntity {
  UserInfoModel({
    required super.dob,
    super.gender,
    super.isShiongVoc,
    super.ordDate,
    super.enlistmentDate,
    super.hasCompletedOnboarding,
  });

  // FOR converting stored JSON to MODEL
  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      dob: DateTime.parse(json['dob']).toUtc(),
      gender: json['gender'],
      isShiongVoc: json['isShiongVoc'] ?? false,
      ordDate: json['ordDate'] != null
          ? DateTime.parse(json['ordDate']).toUtc()
          : null,
      enlistmentDate: json['enlistmentDate'] != null
          ? DateTime.parse(json['enlistmentDate']).toUtc()
          : null,
      hasCompletedOnboarding: json['hasCompletedOnboarding'] ?? false,
    );
  }

  // FOR converting MODEL to storable JSON
  Map<String, dynamic> toJson() {
    return {
      'dob': dob.toUtc().toIso8601String(),
      'gender': gender,
      'isShiongVoc': isShiongVoc,
      'ordDate': ordDate?.toUtc().toIso8601String(),
      'enlistmentDate': enlistmentDate?.toUtc().toIso8601String(),
      'hasCompletedOnboarding': hasCompletedOnboarding,
    };
  }

  // FOR converting ENTITY to MODEL
  // MODEL should always store dates in UTC time
  factory UserInfoModel.fromEntity(UserInfoEntity entity) {
    return UserInfoModel(
      dob: entity.dob.toUtc(),
      gender: entity.gender,
      isShiongVoc: entity.isShiongVoc,
      ordDate: entity.ordDate?.toUtc(),
      enlistmentDate: entity.enlistmentDate?.toUtc(),
      hasCompletedOnboarding: entity.hasCompletedOnboarding,
    );
  }

  // FOR converting MODEL to ENTITY
  // ENTITY should always store dates in LOCAL time
  UserInfoEntity toEntity() => UserInfoEntity(
    dob: dob.toLocal(),
    gender: gender,
    isShiongVoc: isShiongVoc,
    ordDate: ordDate?.toLocal(),
    enlistmentDate: enlistmentDate?.toLocal(),
    hasCompletedOnboarding: hasCompletedOnboarding,
  );
}
