abstract class IFileService {
  Future<List<String>> readAsList();

  Future<String> readAsString();

  Future<void> write(String? data);
}
