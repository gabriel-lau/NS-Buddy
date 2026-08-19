class UserInfoEntity {
  // User information fields
  DateTime dob;
  String? gender;
  bool isShiongVoc;
  DateTime? ordDate;
  DateTime? enlistmentDate;
  bool hasCompletedOnboarding;

  UserInfoEntity({
    required this.dob,
    this.gender,
    this.isShiongVoc = false,
    this.ordDate,
    this.enlistmentDate,
    this.hasCompletedOnboarding = false,
  });
}
