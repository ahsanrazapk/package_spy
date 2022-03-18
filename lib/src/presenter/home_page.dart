import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_spy/package_spy.dart';
import 'package:package_spy/src/envirement/_env.dart';
import 'package:package_spy/src/model/notification_model.dart';
import 'package:package_spy/src/model/user_info.dart';
import 'package:package_spy/src/repository/github_repository.dart';
import 'package:package_spy/src/services/file_service.dart';
import 'package:package_spy/src/services/github_service.dart';
import 'package:package_spy/src/services/notifiers/slack_notification.dart';
import 'package:package_spy/src/services/shell_service.dart';
import 'package:package_spy/src/services/updates_service.dart';
import 'package:package_spy/src/utils/constants/messages.dart';
import 'package:package_spy/src/utils/local_preferences.dart';
import 'package:package_spy/src/utils/pubspec_manager.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.blue.dark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'PACKAGES SPY',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Button(
            child: const Text(
              'Check for packages update',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              await _checkForUpdates();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _checkForUpdates() async {}

  void load(List<String> arguments) async {
    final configuration = await LocalPreferences().loadProjectConfigurations();

    final shellService = ShellService();

    if (configuration?.projectName != null) {
      final githubService = GithubService(
        shellService: shellService,
        githubRepository: GithubRepository(configuration!),
        configuration: configuration,
      );

      // userInfo.currentBranchName = await githubService.sync();

      await shellService.cd(folders: configuration.projectName.toString());

      final fileService = FileService(configuration.projectName ?? '');

      final packageSpy = PackageSpy(
        shellService: shellService,
        fileService: fileService,
        githubService: githubService,
        pubspecManager: PubspecManager(fileService: fileService),
        updatesService: UpdatesService(),
        notification: SlackNotification(),
        // userInfo: configuration,
      );

      await packageSpy.startUpdatingPackages();
    } else {
      await SlackNotification().notify(NotificationModel(errorEnvFileNotFound));
    }
  }
}
