import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_spy/src/model/project_configuration.model.dart';
import 'package:package_spy/src/model/user_info.dart';
import 'package:package_spy/src/repository/github_repository.dart';
import 'package:package_spy/src/services/github_service.dart';
import 'package:package_spy/src/services/shell_service.dart';
import 'package:package_spy/src/utils/local_preferences.dart';

class ProjectConfigurationPage extends HookConsumerWidget {
  const ProjectConfigurationPage({Key? key}) : super(key: key);
  static final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repositoryEditingController = useTextEditingController();
    final projectNameEditingController = useTextEditingController();
    final envFileEditingController = useTextEditingController();
    final hasEnvFile = useState<bool>(false);

    return Container(
      color: Colors.teal,
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormBox(
              controller: projectNameEditingController,
              header: 'Project name',
              placeholder: 'Enter your project name',
              validator: (value) {
                if (value?.isEmpty == true) return 'The project name cannot be empty';
              },
            ),
            const SizedBox(height: 15),
            TextFormBox(
              controller: repositoryEditingController,
              header: 'Repository Link',
              placeholder: 'Place your repository link',
              validator: (value) {
                if (value?.isEmpty == true) return 'Please add a repository link';
              },
            ),
            const SizedBox(height: 15),
            Checkbox(
              checked: hasEnvFile.value,
              content: const Text(
                'Has Env file ?',
                style: TextStyle(color: Colors.white),
              ),
              onChanged: (newValue) => hasEnvFile.value = newValue ?? false,
            ),
            if (hasEnvFile.value)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  TextBox(
                    controller: envFileEditingController,
                    header: 'Env File',
                    placeholder: 'Place here your env file',
                    maxLines: 399,
                    minLines: 15,
                  ),
                ],
              ),
            const SizedBox(height: 15),
            Button(
              child: const Text(
                'Save project configuration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                padding: ButtonState.all<EdgeInsets>(const EdgeInsets.all(15)),
                backgroundColor: ButtonState.all<Color>(Colors.black),
                shadowColor: ButtonState.all<Color>(Colors.white),
              ),
              onPressed: () async {
                if (_formKey.currentState?.validate() == true) {
                  final configuration = ProjectConfiguration(
                    projectName: projectNameEditingController.text.trim(),
                    repository: repositoryEditingController.text.trim().replaceFirst('https://', ''),
                    hasEnvFile: hasEnvFile.value,
                    envFile: envFileEditingController.text.trim(),
                  );
                  await _saveProjectConfiguration(configuration);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProjectConfiguration(ProjectConfiguration configuration) async {
    await LocalPreferences().saveProjectConfiguration(configuration);

    final githubService = GithubService(
      configuration: configuration,
      shellService: ShellService(),
      githubRepository: GithubRepository(configuration),
    );

    await githubService.sync();
  }
}
