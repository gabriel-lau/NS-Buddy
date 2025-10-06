import 'package:flutter_test/flutter_test.dart';
import 'package:ns_buddy/data/models/user_info_model.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';

void main() {
  group('UserInfoModel', () {
    final testDob = DateTime(2000, 1, 1).toUtc();
    final testOrdDate = DateTime(2023, 12, 31).toUtc();
    final testEnlistmentDate = DateTime(2022, 1, 1).toUtc();

    group('Constructor', () {
      test('should create UserInfoModel with default values', () {
        // Act
        final model = UserInfoModel(dob: testDob);

        // Assert
        expect(model.dob, testDob);
        expect(model.gender, isNull);
        expect(model.isShiongVoc, false);
        expect(model.ordDate, isNull);
        expect(model.enlistmentDate, isNull);
        expect(model.hasCompletedOnboarding, false);
      });

      test('should create UserInfoModel with custom values', () {
        // Act
        final model = UserInfoModel(
          dob: testDob,
          gender: 'Male',
          isShiongVoc: true,
          ordDate: testOrdDate,
          enlistmentDate: testEnlistmentDate,
          hasCompletedOnboarding: true,
        );

        // Assert
        expect(model.dob, testDob);
        expect(model.gender, 'Male');
        expect(model.isShiongVoc, true);
        expect(model.ordDate, testOrdDate);
        expect(model.enlistmentDate, testEnlistmentDate);
        expect(model.hasCompletedOnboarding, true);
      });
    });

    group('fromJson', () {
      test('should create UserInfoModel from complete JSON', () {
        // Arrange
        final json = {
          'dob': testDob.toIso8601String(),
          'gender': 'Female',
          'isShiongVoc': true,
          'ordDate': testOrdDate.toIso8601String(),
          'enlistmentDate': testEnlistmentDate.toIso8601String(),
          'hasCompletedOnboarding': true,
        };

        // Act
        final model = UserInfoModel.fromJson(json);

        // Assert
        expect(model.dob, testDob);
        expect(model.gender, 'Female');
        expect(model.isShiongVoc, true);
        expect(model.ordDate, testOrdDate);
        expect(model.enlistmentDate, testEnlistmentDate);
        expect(model.hasCompletedOnboarding, true);
      });

      test('should create UserInfoModel from minimal JSON', () {
        // Arrange
        final json = <String, dynamic>{"dob": testDob.toIso8601String()};

        // Act
        final model = UserInfoModel.fromJson(json);

        // Assert
        expect(model.dob, testDob);
        expect(model.gender, isNull);
        expect(model.isShiongVoc, false);
        expect(model.ordDate, isNull);
        expect(model.enlistmentDate, isNull);
        expect(model.hasCompletedOnboarding, false);
      });

      test('should handle null date strings in JSON', () {
        // Arrange
        final json = {
          'dob': testDob.toIso8601String(),
          'gender': 'Male',
          'isShiongVoc': false,
          'ordDate': null,
          'enlistmentDate': null,
          'hasCompletedOnboarding': false,
        };

        // Act
        final model = UserInfoModel.fromJson(json);

        // Assert
        expect(model.dob, testDob);
        expect(model.gender, 'Male');
        expect(model.isShiongVoc, false);
        expect(model.ordDate, isNull);
        expect(model.enlistmentDate, isNull);
        expect(model.hasCompletedOnboarding, false);
      });

      test('should handle partial JSON with missing fields', () {
        // Arrange
        final json = {
          'dob': testDob.toIso8601String(),
          'gender': 'Other',
          'ordDate': testOrdDate.toIso8601String(),
        };

        // Act
        final model = UserInfoModel.fromJson(json);

        // Assert
        expect(model.dob, testDob);
        expect(model.gender, 'Other');
        expect(model.isShiongVoc, false);
        expect(model.ordDate, testOrdDate);
        expect(model.enlistmentDate, isNull);
        expect(model.hasCompletedOnboarding, false);
      });
    });

    group('toJson', () {
      test('should convert UserInfoModel to complete JSON', () {
        // Arrange
        final model = UserInfoModel(
          dob: testDob,
          gender: 'Male',
          isShiongVoc: true,
          ordDate: testOrdDate,
          enlistmentDate: testEnlistmentDate,
          hasCompletedOnboarding: true,
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['dob'], testDob.toUtc().toIso8601String());
        expect(json['gender'], 'Male');
        expect(json['isShiongVoc'], true);
        expect(json['ordDate'], testOrdDate.toUtc().toIso8601String());
        expect(
          json['enlistmentDate'],
          testEnlistmentDate.toUtc().toIso8601String(),
        );
        expect(json['hasCompletedOnboarding'], true);
      });

      test('should convert UserInfoModel with null values to JSON', () {
        // Arrange
        final model = UserInfoModel(dob: DateTime(2000, 1, 1));

        // Act
        final json = model.toJson();

        // Assert
        expect(json['dob'], isNotNull);
        expect(json['gender'], isNull);
        expect(json['isShiongVoc'], false);
        expect(json['ordDate'], isNull);
        expect(json['enlistmentDate'], isNull);
        expect(json['hasCompletedOnboarding'], false);
      });
    });

    group('fromEntity', () {
      test('should create UserInfoModel from UserInfoEntity', () {
        // Arrange
        final entity = UserInfoEntity(
          dob: testDob.toLocal(),
          gender: 'Female',
          isShiongVoc: true,
          ordDate: testOrdDate.toLocal(),
          enlistmentDate: testEnlistmentDate.toLocal(),
          hasCompletedOnboarding: true,
        );

        // Act
        final model = UserInfoModel.fromEntity(entity);

        // Assert
        expect(model.dob, entity.dob.toUtc());
        expect(model.gender, entity.gender);
        expect(model.isShiongVoc, entity.isShiongVoc);
        expect(model.ordDate, entity.ordDate?.toUtc());
        expect(model.enlistmentDate, entity.enlistmentDate?.toUtc());
        expect(model.hasCompletedOnboarding, entity.hasCompletedOnboarding);
      });

      test('should create UserInfoModel from empty UserInfoEntity', () {
        // Arrange
        final entity = UserInfoEntity(dob: testDob.toLocal());

        // Act
        final model = UserInfoModel.fromEntity(entity);

        // Assert
        expect(model.dob, testDob.toUtc());
        expect(model.gender, isNull);
        expect(model.isShiongVoc, false);
        expect(model.ordDate, isNull);
        expect(model.enlistmentDate, isNull);
        expect(model.hasCompletedOnboarding, false);
      });
    });

    group('toEntity', () {
      test('should convert UserInfoModel to UserInfoEntity', () {
        // Arrange
        final model = UserInfoModel(
          dob: testDob,
          gender: 'Male',
          isShiongVoc: true,
          ordDate: testOrdDate,
          enlistmentDate: testEnlistmentDate,
          hasCompletedOnboarding: true,
        );

        // Act
        final entity = model.toEntity();

        // Assert
        expect(entity.dob, model.dob.toLocal());
        expect(entity.gender, model.gender);
        expect(entity.isShiongVoc, model.isShiongVoc);
        expect(entity.ordDate, model.ordDate?.toLocal());
        expect(entity.enlistmentDate, model.enlistmentDate?.toLocal());
        expect(entity.hasCompletedOnboarding, model.hasCompletedOnboarding);
        expect(entity, isA<UserInfoEntity>());
        expect(entity, isNot(isA<UserInfoModel>()));
      });
    });

    group('JSON round-trip', () {
      test('should maintain data integrity through JSON round-trip', () {
        // Arrange
        final original = UserInfoModel(
          dob: testDob,
          gender: 'Non-binary',
          isShiongVoc: true,
          ordDate: testOrdDate,
          enlistmentDate: testEnlistmentDate,
          hasCompletedOnboarding: true,
        );

        // Act
        final json = original.toJson();
        final recreated = UserInfoModel.fromJson(json);

        // Assert
        expect(recreated.dob, original.dob);
        expect(recreated.gender, original.gender);
        expect(recreated.isShiongVoc, original.isShiongVoc);
        expect(recreated.ordDate, original.ordDate);
        expect(recreated.enlistmentDate, original.enlistmentDate);
        expect(
          recreated.hasCompletedOnboarding,
          original.hasCompletedOnboarding,
        );
      });
    });
  });
}
