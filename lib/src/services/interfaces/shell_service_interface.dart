import 'dart:io';

import 'package:package_spy/src/model/package_info.dart';

abstract class IShellService {
  Future<List<ProcessResult>> run(String script);

  Future<void> cd({required String folders});

  Future<bool> runFlutterPubGet();

  Future<bool> runUnitTests(PackageInfo package);
}
