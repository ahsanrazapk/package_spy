import 'package:fluent_ui/fluent_ui.dart';
import 'package:package_spy/src/presenter/project_configuration_page.dart';
import 'package:package_spy/src/utils/local_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final configuration = LocalPreferences().loadProjectConfigurations();

    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'Package spy',
      theme: ThemeData(
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProjectConfigurationPage(),
    );
  }
}
