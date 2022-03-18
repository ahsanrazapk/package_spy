import 'package:package_spy/src/model/notification_model.dart';
import 'package:package_spy/src/model/package_info.dart';
import 'package:package_spy/src/model/user_info.dart';
import 'package:package_spy/src/services/file_service.dart';
import 'package:package_spy/src/services/interfaces/github_service_interface.dart';
import 'package:package_spy/src/services/interfaces/shell_service_interface.dart';
import 'package:package_spy/src/services/interfaces/updates_service_interface.dart';
import 'package:package_spy/src/services/notifiers/interface/notification_interface.dart';
import 'package:package_spy/src/utils/constants/default_values.dart';
import 'package:package_spy/src/utils/interfaces/pubspec_manager_interface.dart';

class PackageSpy {
  IShellService? _shellService;
  IGithubService? _githubService;
  FileService? _fileService;
  IPubspecManager? _pubspecManager;
  INotification? _notification;
  IUpdatesService? _updatesService;
  UserInfo? _userInfo;
  final List<PackageInfo> _packagesUpdated = [];
  final List<PackageInfo> _packagesUpdatesFailed = [];

  PackageSpy({
    IGithubService? githubService,
    IShellService? shellService,
    FileService? fileService,
    IPubspecManager? pubspecManager,
    IUpdatesService? updatesService,
    INotification? notification,
    UserInfo? userInfo,
  }) {
    _githubService = githubService;
    _shellService = shellService;
    _fileService = fileService;
    _pubspecManager = pubspecManager;
    _updatesService = updatesService;
    _notification = notification;
    _userInfo = userInfo;
  }

  Future<void> startUpdatingPackages() async {
    final packages = await _pubspecManager?.getProjectPackages();

    final packagesNeddingUpdates = await _updatesService?.checkPackagesUpdates(packages ?? []);

    if (packagesNeddingUpdates?.isNotEmpty == true) {
      await _notify("Packages ready to update: ${packagesNeddingUpdates?.length}\nUpdating...");
      await _updatePackages(packagesNeddingUpdates);

      await Future.delayed(delayTwoSeconds);

      if (_userInfo?.currentBranchName != null) {
        await _githubService?.push();

        await _notification?.sendReport(
          userInfo: _userInfo ?? UserInfo(),
          packagesUpdated: _packagesUpdated,
          updatesFailed: _packagesUpdatesFailed,
        );
      }
    } else {
      _notify("Project up to date");
    }
  }

  Future<void> _updatePackages(List<PackageInfo>? packages) async {
    if (packages != null) {
      for (final package in packages) {
        await _notify("updating ${package.name} from ${package.version} to ${package.latestVersion}...");

        try {
          final pubspecData = await _fileService?.readAsString();

          // update package version on pubspec.yaml
          final newPubspec = _pubspecManager?.updatePubspecWithNewPackageVersion(
            package: package,
            pubspecFile: pubspecData,
          );

          // save the pubspec file with new update
          await _fileService?.write(newPubspec);

          // run flutter pub get
          final updatedWithSucess = await _shellService?.runFlutterPubGet();

          if (updatedWithSucess == true) {
            // run test to know sucess
            final allTestsPassed = await _shellService?.runUnitTests(package);
            if (allTestsPassed == true) {
              _packagesUpdated.add(package);
              await _notify("${package.name} updated");
            } else {
              _packagesUpdatesFailed.add(package);
              await _notify("some tests failed after update ${package.name} to ${package.latestVersion}");
            }
          } else {
            await _notify("Flutter pub get failed after update ${package.name} to ${package.latestVersion}");
          }
        } catch (e) {
          _packagesUpdatesFailed.add(package);
        }
      }
    }
  }

  Future<void> _notify(String text) async {
    await _notification?.notify(NotificationModel(text));
  }
}
