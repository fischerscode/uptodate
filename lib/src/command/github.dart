import 'dart:io';

import 'package:args/command_runner.dart';

import '../config.dart';
import '../issue_controller.dart';
import '../version_checker.dart';

class GitHubCommand extends Command<int> {
  @override
  final name = 'github';
  @override
  final description =
      'Check for updates and create issues in your GitHub repository.';

  GitHubCommand() {
    argParser.addOption(
      'repository',
      abbr: 'r',
      help:
          'The repository. If missing, the environment variable \$GITHUB_REPOSITORY will be used',
      valueHelp: 'fischerscode/uptodate',
    );
    argParser.addOption(
      'token',
      abbr: 't',
      help:
          'The token used for authentication. If missing, the environment variable \$GITHUB_TOKEN will be used',
    );
  }

  @override
  Future<int> run() async {
    var envs = Platform.environment;
    String? repository = argResults?['repository'] ?? envs['GITHUB_REPOSITORY'];
    if (repository == null) {
      print(
          'No token is specified.\nPlease either use --repository or set GITHUB_REPOSITORY is set as an environment variable.');
      return 1;
    }
    String? token = argResults?['token'] ?? envs['GITHUB_TOKEN'];
    if (token == null) {
      print(
          'No token is specified.\nPlease either use --token or set GITHUB_TOKEN is set as an environment variable.');
      return 1;
    }

    String file = globalResults?['file'];

    var config = await Config.file(File(file));
    var states = await VersionChecker(config).checkVersions();
    await IssueController(repo: repository, token: token)
        .handleDependencies(states);
    return 0;
  }
}
