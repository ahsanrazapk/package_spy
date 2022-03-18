import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_spy/src/model/project_configuration.model.dart';
import 'package:package_spy/src/model/user_info.dart';

class GithubRepository {
  final ProjectConfiguration _configuration;

  GithubRepository(this._configuration);

  Future<String?> createBranch(String branchName) async {
    // final link = 'https://api.github.com/repos/${_configuration.userName}/${_configuration.projectName}/git/refs';
    // final url = Uri.parse(link);

    // final basicAuth = 'Basic ' + base64Encode(utf8.encode('${_configuration.userName}:${_configuration.accessToken}'));

    // final response = await http.post(
    //   url,
    //   body: json.encode({
    //     "ref": "refs/heads/$branchName",
    //     "sha": _configuration.branchSha1,
    //   }),
    //   headers: {
    //     HttpHeaders.authorizationHeader: basicAuth,
    //   },
    // );

    // if (response.statusCode == HttpStatus.created) {
    //   return branchName;
    // }

    // print('Erro creating branch');
  }
}
