import 'package:mockito/annotations.dart';
import 'package:ns_buddy/domain/interfaces/user_info_repository.dart';
import 'package:ns_buddy/domain/interfaces/settings_repository.dart';

// This generates mock classes for our repositories
@GenerateMocks([UserInfoRepository, SettingsRepository])
void main() {}
