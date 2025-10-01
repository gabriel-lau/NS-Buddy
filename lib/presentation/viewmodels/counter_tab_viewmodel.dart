import 'package:flutter/material.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';

class CounterTabViewModel extends ChangeNotifier {
  UserInfoUsecases userInfoUsecases;

  CounterTabViewModel(this.userInfoUsecases);

  UserInfoEntity get userInfoEntity => userInfoUsecases.userInfoEntity;
}
