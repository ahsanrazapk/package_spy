import 'dart:io';
import 'package:package_spy/src/services/interfaces/file_service_interface.dart';
import 'package:package_spy/src/utils/constants/names.dart';

class FileService implements IFileService {
  late File file;

  FileService(String projectName) {
    final currentDirectory = Directory.current;
    final path = "${currentDirectory.path}/$repo/$projectName";

    file = File("$path/pubspec.yaml");
  }

  @override
  Future<List<String>> readAsList() async {
    return await file.readAsLines();
  }

  @override
  Future<String> readAsString() async {
    return await file.readAsString();
  }

  @override
  Future<void> write(String? data) async {
    await file.writeAsString(data ?? '');
  }
}
