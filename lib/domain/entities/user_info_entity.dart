class UserInfoEntity {
  // User information fields
  DateTime? dob;
  String? gender;
  bool isShiongVoc = false;
  DateTime? ordDate;
  DateTime? enlistmentDate;
  bool hasCompletedOnboarding = false;

  UserInfoEntity({
    this.dob,
    this.gender,
    this.isShiongVoc = false,
    this.ordDate,
    this.enlistmentDate,
    this.hasCompletedOnboarding = false,
  });
}
