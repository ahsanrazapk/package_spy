import 'package:package_spy/src/model/package_info.dart';
import 'package:package_spy/src/services/file_service.dart';
import 'package:package_spy/src/utils/interfaces/pubspec_manager_interface.dart';
import 'package:package_spy/src/utils/pubspec_package_serializator.dart';

class PubspecManager implements IPubspecManager {
  FileService? _fileService;
  late PubspecPackageSerializator _pubspecPackageSerializator;

  PubspecManager({FileService? fileService}) {
    _fileService = fileService;
    _pubspecPackageSerializator = PubspecPackageSerializator();
  }

  @override
  Future<List<PackageInfo>> getProjectPackages() async {
    final packages = <PackageInfo>[];

    try {
      final response = await _fileService?.readAsList();

      final devDependeces = _pubspecPackageSerializator.extractDependecesPackages(response ?? []);
      if (devDependeces.isNotEmpty) packages.addAll(devDependeces);
    } catch (e) {
      print(e);
    }

    return packages;
  }

  @override
  String? updatePubspecWithNewPackageVersion({
    required PackageInfo package,
    required String? pubspecFile,
  }) {
    final regex = RegExp(
      "${package.name}:\\s\\^${package.version}",
      multiLine: true,
    );

    final newPubspec = pubspecFile?.replaceFirst(
      regex,
      "${package.name}: ^${package.latestVersion}",
    );

    return newPubspec;
  }
}
