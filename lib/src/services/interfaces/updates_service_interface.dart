import 'package:package_spy/src/model/package_info.dart';

abstract class IUpdatesService {
  Future<List<PackageInfo>> checkPackagesUpdates(List<PackageInfo> packages);
}
