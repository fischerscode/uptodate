import 'package:uptodate/config.dart';
import 'package:version/version.dart';

class VersionChecker {
  final Config config;

  VersionChecker(this.config);

  void checkVersions() async {
    for (var dependency in config.dependencies) {
      var newestVersion = await dependency.newestVersion();
      if (newestVersion > dependency.currentVersion) {
        print(
            '${dependency.name}: ${dependency.printVersion(dependency.currentVersion)} -> ${dependency.printVersion(newestVersion)}');
      }
    }
  }
}
