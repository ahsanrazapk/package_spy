abstract class IGithubService {
  Future<bool?> clone();
  Future<bool?> sync();
  Future<bool> pull();
  Future<bool> push();
  Future<String?> createBranch();
  Future<bool> checkOut(String branch);
  Future<bool> fetch();
}
