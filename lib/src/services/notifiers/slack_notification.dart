import 'dart:convert';
import 'package:package_spy/src/model/notification_model.dart';
import 'package:package_spy/src/model/package_info.dart';
import 'package:package_spy/src/model/user_info.dart';
import 'package:package_spy/src/services/notifiers/interface/notification_interface.dart';
import 'package:http/http.dart' as http;

class SlackNotification implements INotification {
  @override
  Future<void> notify(NotificationModel notification) async {
    final webHookUrl = 'https://hooks.slack.com/services/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';

    await http.post(
      Uri.parse(webHookUrl),
      body: json.encode(notification.toJson()),
    );
  }

  @override
  Future<void> sendReport({
    required UserInfo userInfo,
    required List<PackageInfo> packagesUpdated,
    required List<PackageInfo> updatesFailed,
  }) async {
    final _currentDate = DateTime.now();
    String notificationText = "$_currentDate REPORT - PACKAGES UPDATE\n\n";

    if (packagesUpdated.isNotEmpty) {
      notificationText += "Packages Updated:\n";

      for (final package in packagesUpdated) {
        notificationText += '\t${package.name} to ${package.latestVersion}\n';
      }
    }
    if (updatesFailed.isNotEmpty) {
      notificationText += "\nUpdates Failed:\n";

      for (final package in updatesFailed) {
        notificationText += '\t${package.name} to ${package.latestVersion}';
      }
    }

    notificationText += '\nRepository # https://${userInfo.projectName}/tree/${userInfo.currentBranchName}';
    await notify(NotificationModel(notificationText));
  }
}
