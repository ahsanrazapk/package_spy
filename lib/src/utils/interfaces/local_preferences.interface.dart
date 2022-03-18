import 'package:package_spy/src/model/project_configuration.model.dart';

abstract class ILocalPreferences {
  Future<void> saveProjectConfiguration(ProjectConfiguration configuration);
  Future<ProjectConfiguration?> loadProjectConfigurations();
}
