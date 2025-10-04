import 'package:ns_buddy/domain/entities/user_info_entity.dart';

class UserInfoModel extends UserInfoEntity {
  UserInfoModel({
    DateTime? dob,
    String? gender,
    bool isShiongVoc = false,
    DateTime? ordDate,
    DateTime? enlistmentDate,
    bool hasCompletedOnboarding = false,
  }) : super(
         dob: dob,
         gender: gender,
         isShiongVoc: isShiongVoc,
         ordDate: ordDate,
         enlistmentDate: enlistmentDate,
         hasCompletedOnboarding: hasCompletedOnboarding,
       );

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      gender: json['gender'],
      isShiongVoc: json['isShiongVoc'] ?? false,
      ordDate: json['ordDate'] != null ? DateTime.parse(json['ordDate']) : null,
      enlistmentDate: json['enlistmentDate'] != null
          ? DateTime.parse(json['enlistmentDate'])
          : null,
      hasCompletedOnboarding: json['hasCompletedOnboarding'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dob': dob?.toIso8601String(),
      'gender': gender,
      'isShiongVoc': isShiongVoc,
      'ordDate': ordDate?.toIso8601String(),
      'enlistmentDate': enlistmentDate?.toIso8601String(),
      'hasCompletedOnboarding': hasCompletedOnboarding,
    };
  }

  factory UserInfoModel.fromEntity(UserInfoEntity entity) {
    return UserInfoModel(
      dob: entity.dob,
      gender: entity.gender,
      isShiongVoc: entity.isShiongVoc,
      ordDate: entity.ordDate,
      enlistmentDate: entity.enlistmentDate,
      hasCompletedOnboarding: entity.hasCompletedOnboarding,
    );
  }
  UserInfoEntity toEntity() => UserInfoEntity(
    dob: dob,
    gender: gender,
    isShiongVoc: isShiongVoc,
    ordDate: ordDate,
    enlistmentDate: enlistmentDate,
    hasCompletedOnboarding: hasCompletedOnboarding,
  );
}
