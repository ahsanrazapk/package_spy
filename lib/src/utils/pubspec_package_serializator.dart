import 'package:package_spy/src/model/package_info.dart';

class PubspecPackageSerializator {
  List<PackageInfo> extractDependecesPackages(List<String> pubspec) {
    final packages = <PackageInfo>[];
    pubspec = _removeEmptySpace(pubspec);
    pubspec = _removeComment(pubspec);

    final startIndex = pubspec.indexOf("dependencies:");
    final endIndex = pubspec.indexOf("dev_dependencies:");

    final slice = pubspec.sublist(startIndex, endIndex);

    slice.removeRange(0, 3);

    packages.addAll(_getPackageModelFromPubspec(slice));

    return packages;
  }

  List<PackageInfo> _getPackageModelFromPubspec(List<String> fileLines) {
    final packages = <PackageInfo>[];

    for (final line in fileLines) {
      final split = line.split(":");
      final name = split.first.trim();
      final version = split.last.trim().replaceFirst("^", "");

      packages.add(PackageInfo(name: name, version: version));
    }
    return packages;
  }

  List<String> _removeComment(List<String> pubspec) {
    pubspec.removeWhere((item) => item.trim().contains("#"));
    return pubspec;
  }

  List<String> _removeEmptySpace(List<String> pubspec) {
    pubspec.removeWhere((item) => item.trim().isEmpty);
    return pubspec;
  }
}
