import 'dart:io';

import 'package:uptodate/config.dart';
import 'package:uptodate/issue_controller.dart';
import 'package:uptodate/version_checker.dart';

main(List<String> args) async {
  var configString = '''
dependencies:
  - name: test
    type: webjson
    path: args.version
    currentVersion: v1.2.3
    prefix: v
    url: 'https://postman-echo.com/get?version=v1.2.4'
  - name: traefik
    type: git
    repo: traefik/traefik
    currentVersion: v2.5.2
    prefix: v
''';

  var config = Config.string(configString);
  print(config.dependencies);
  var versionChecker = VersionChecker(config);
  var envVars = Platform.environment;
  IssueController(
          token: envVars['GITHUB_TOKEN']!, repo: envVars['GITHUB_REPOSITORY']!)
      .handleDependencies(await versionChecker.checkVersions());
}
