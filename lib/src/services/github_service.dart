import 'dart:developer';
import 'dart:io';
import 'package:package_spy/src/model/project_configuration.model.dart';
import 'package:package_spy/src/model/user_info.dart';
import 'package:package_spy/src/repository/github_repository.dart';
import 'package:package_spy/src/services/interfaces/github_service_interface.dart';
import 'package:package_spy/src/services/interfaces/shell_service_interface.dart';
import 'package:package_spy/src/utils/constants/default_values.dart';
import 'package:package_spy/src/utils/constants/git_commands.dart';
import 'package:package_spy/src/utils/constants/names.dart';
import 'package:path/path.dart' as path;
import 'package:process_run/utils/process_result_extension.dart';

class GithubService implements IGithubService {
  String? repositoryUrl;
  IShellService? _shellService;
  GithubRepository? _githubRepository;
  ProjectConfiguration? _configuration;

  GithubService({
    IShellService? shellService,
    GithubRepository? githubRepository,
    required ProjectConfiguration configuration,
  }) {
    _shellService = shellService;
    _githubRepository = githubRepository;
    _configuration = configuration;
    repositoryUrl = 'https://${_configuration?.accessToken != null ? '@${_configuration?.accessToken}' : ''}${_configuration?.repository}';
  }

  @override
  Future<bool?> clone() async {
    final response = await _shellService?.run('$gitClone $repositoryUrl');

    if (response?.first.exitCode == 0) {
      return true;
    }

    print(response?.first.errText);
    return false;
  }

  @override
  Future<bool> pull() async {
    final response = await _shellService?.run(gitPull);

    if (response?.first.exitCode == 0) {
      return true;
    }

    return false;
  }

  @override
  Future<bool> push() async {
    // try {
    //   print("push command");
    //   await _shellService?.run(gitAddAll);
    //   await _shellService?.run(gitCommit);
    //   await _shellService?.run('$gitPush${_configuration?.currentBranchName}');
    //   print('pusing changes');
    //   return true;
    // } catch (e) {
    //   print(e.toString());
    // }
    return false;
  }

  @override
  Future<bool?> sync() async {
    try {
      if (await _repositoryAlreadyCloned()) {
        await _shellService?.cd(folders: '${_configuration?.projectName}');
        await pull();
        await Future.delayed(delayTwoSeconds);
      } else {
        await clone();
        await Future.delayed(delayTwoSeconds);
        await _shellService?.run('cd ${_configuration?.projectName}');
      }
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }

    // final branch = await createBranch();
    // await fetch();
    // await checkOut(branch ?? '');
    // return branch;
  }

  Future<bool> _repositoryAlreadyCloned() async {
    final slash = Platform.pathSeparator;
    final directory = Directory(path.join(Directory.current.path, '$repo$slash${_configuration?.projectName}'));

    if (await directory.exists()) {
      return true;
    }
    return false;
  }

  @override
  Future<String?> createBranch() async {
    try {
      final prData = DateTime.now().millisecond;
      final branchName = 'postnatal-packages-update-$prData';
      final response = await _githubRepository?.createBranch(branchName);

      if (response != null) {
        print(response);
        return response;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<bool> checkOut(String branch) async {
    final response = await _shellService?.run('$gitCheckout $branch');

    if (response?.first.exitCode == 0) {
      return true;
    }

    print("error checkout: ${response?.first.errText}");
    return false;
  }

  @override
  Future<bool> fetch() async {
    final response = await _shellService?.run(gitFetch);

    if (response?.first.exitCode == 0) {
      return true;
    }

    print("error fetch: ${response?.first.errText}");
    return false;
  }
}
