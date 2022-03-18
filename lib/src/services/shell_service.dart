import 'dart:io';
import 'package:package_spy/src/model/package_info.dart';
import 'package:package_spy/src/services/interfaces/shell_service_interface.dart';
import 'package:package_spy/src/utils/constants/names.dart';
import 'package:process_run/shell.dart';

class ShellService implements IShellService {
  late Shell _shell;

  ShellService() {
    _shell = Shell().cd(repo);
  }

  @override
  Future<List<ProcessResult>> run(String script) async {
    return await _shell.run(script);
  }

  @override
  Future<bool> runFlutterPubGet() async {
    print("running flutter pub get...");

    final response = await run("flutter pub get");

    if (response.first.exitCode == 0) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> runUnitTests(PackageInfo package) async {
    final response = await run("flutter test");

    if (response.outText.contains("All tests passed")) {
      return true;
    }
    return false;
  }

  @override
  Future<void> cd({required String folders}) async {
    _shell = _shell.cd(folders);
  }
}
