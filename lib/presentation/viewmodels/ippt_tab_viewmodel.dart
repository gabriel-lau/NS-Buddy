import 'package:flutter/material.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';

class IpptTabViewModel extends ChangeNotifier {
  IpptTabViewModel({required this.userInfoUsecases});

  final UserInfoUsecases userInfoUsecases;

  UserInfoEntity get userInfoEntity => userInfoUsecases.userInfoEntity;
}
