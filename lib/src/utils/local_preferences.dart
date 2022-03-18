import 'dart:convert';
import 'package:package_spy/src/model/project_configuration.model.dart';
import 'package:package_spy/src/utils/interfaces/local_preferences.interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences implements ILocalPreferences {
  final String _key = 'project_configuration';

  @override
  Future<ProjectConfiguration?> loadProjectConfigurations() async {
    final shared = await SharedPreferences.getInstance();
    if (shared.containsKey(_key)) {
      final response = json.decode(shared.getString(_key) ?? '');
      return ProjectConfiguration.fromMap(response as Map<String, dynamic>);
    }
  }

  @override
  Future<void> saveProjectConfiguration(ProjectConfiguration configuration) async {
    final shared = await SharedPreferences.getInstance();
    shared.setString(_key, json.encode(configuration.tokeyValue()));
  }
}
