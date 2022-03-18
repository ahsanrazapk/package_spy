import 'package:package_spy/src/model/package_info.dart';
import 'package:package_spy/src/services/interfaces/updates_service_interface.dart';
import 'package:pub_api_client/pub_api_client.dart';

class UpdatesService implements IUpdatesService {
  final client = PubClient();

  @override
  Future<List<PackageInfo>> checkPackagesUpdates(List<PackageInfo> packages) async {
    List<PackageInfo> packagesNeddingUpdates = [];

    for (final package in packages) {
      final name = package.name;
      final version = package.version;

      final packageInfo = await client.packageInfo(name.toString());
      final latestVersion = packageInfo.latest.version;

      if (version?.compareTo(latestVersion) == -1) {
        final newPackageDetail = PackageInfo(
          name: name,
          version: version,
          latestVersion: latestVersion,
        );
        packagesNeddingUpdates.add(newPackageDetail);
      }
    }

    return packagesNeddingUpdates;
  }
}
