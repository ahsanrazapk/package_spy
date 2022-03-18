class ProjectConfiguration {
  final String repository;
  final bool hasEnvFile;
  final String? envFile;
  final String? accessToken;
  final String? projectName;

  ProjectConfiguration({
    required this.projectName,
    required this.repository,
    this.hasEnvFile = false,
    this.envFile,
    this.accessToken,
  });

  factory ProjectConfiguration.fromMap(Map<String, dynamic> map) {
    return ProjectConfiguration(
      projectName: map['projectName'],
      repository: map['repository'],
      hasEnvFile: map['hasEnvFile'],
      envFile: map['envFile'],
    );
  }

  Map<String, dynamic> tokeyValue() {
    return {
      'projectName': projectName,
      'repository': repository,
      'hasEnvFile': hasEnvFile,
      'envFile': envFile,
    };
  }
}
