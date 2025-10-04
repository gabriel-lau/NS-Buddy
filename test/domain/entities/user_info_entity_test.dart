import 'package:flutter_test/flutter_test.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';

void main() {
  group('UserInfoEntity', () {
    test('should create UserInfoEntity with default values', () {
      // Arrange & Act
      final userInfo = UserInfoEntity();

      // Assert
      expect(userInfo.dob, isNull);
      expect(userInfo.gender, isNull);
      expect(userInfo.isShiongVoc, false);
      expect(userInfo.ordDate, isNull);
      expect(userInfo.enlistmentDate, isNull);
      expect(userInfo.hasCompletedOnboarding, false);
    });

    test('should create UserInfoEntity with custom values', () {
      // Arrange
      final dob = DateTime(2000, 1, 1);
      final ordDate = DateTime(2023, 12, 31);
      final enlistmentDate = DateTime(2022, 1, 1);

      // Act
      final userInfo = UserInfoEntity(
        dob: dob,
        gender: 'Male',
        isShiongVoc: true,
        ordDate: ordDate,
        enlistmentDate: enlistmentDate,
        hasCompletedOnboarding: true,
      );

      // Assert
      expect(userInfo.dob, dob);
      expect(userInfo.gender, 'Male');
      expect(userInfo.isShiongVoc, true);
      expect(userInfo.ordDate, ordDate);
      expect(userInfo.enlistmentDate, enlistmentDate);
      expect(userInfo.hasCompletedOnboarding, true);
    });

    test('should handle null date values', () {
      // Act
      final userInfo = UserInfoEntity(
        dob: null,
        ordDate: null,
        enlistmentDate: null,
      );

      // Assert
      expect(userInfo.dob, isNull);
      expect(userInfo.ordDate, isNull);
      expect(userInfo.enlistmentDate, isNull);
    });

    test('should handle gender variations', () {
      // Test different gender values
      final userInfoMale = UserInfoEntity(gender: 'Male');
      final userInfoFemale = UserInfoEntity(gender: 'Female');
      final userInfoOther = UserInfoEntity(gender: 'Other');

      expect(userInfoMale.gender, 'Male');
      expect(userInfoFemale.gender, 'Female');
      expect(userInfoOther.gender, 'Other');
    });

    test('should handle boolean flags correctly', () {
      // Test various combinations of boolean flags
      final userInfo1 = UserInfoEntity(
        isShiongVoc: true,
        hasCompletedOnboarding: false,
      );

      final userInfo2 = UserInfoEntity(
        isShiongVoc: false,
        hasCompletedOnboarding: true,
      );

      expect(userInfo1.isShiongVoc, true);
      expect(userInfo1.hasCompletedOnboarding, false);
      expect(userInfo2.isShiongVoc, false);
      expect(userInfo2.hasCompletedOnboarding, true);
    });
  });
}
