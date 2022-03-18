import 'package:package_spy/src/model/package_info.dart';

abstract class IPubspecManager {
  Future<List<PackageInfo>> getProjectPackages();

  String? updatePubspecWithNewPackageVersion({
    required PackageInfo package,
    required String? pubspecFile,
  });
}
