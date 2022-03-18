import 'package:package_spy/src/model/notification_model.dart';
import 'package:package_spy/src/model/package_info.dart';
import 'package:package_spy/src/model/user_info.dart';

abstract class INotification {
  Future<void> notify(NotificationModel notification);

  Future<void> sendReport({
    required UserInfo userInfo,
    required List<PackageInfo> packagesUpdated,
    required List<PackageInfo> updatesFailed,
  });
}
