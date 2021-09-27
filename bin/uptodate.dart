import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:uptodate/config.dart';
import 'package:uptodate/issue_controller.dart';
import 'package:uptodate/version_checker.dart';

void main(List<String> arguments) async {
  var parser = CommandRunner(
    'uptodate',
    'A tool that helps you to keep your repository up to date.',
  )
    ..addCommand(CheckCommand())
    ..addCommand(GitHubCommand());
  parser.argParser.addOption(
    'file',
    abbr: 'f',
    help: 'The config file.',
    mandatory: true,
  );
  try {
    await parser.run(arguments);
  } on UsageException catch (e) {
    print(e);
    exit(-1);
  }
}

class CheckCommand extends Command {
  @override
  final name = 'check';
  @override
  final description = 'Check the dependencies in the config file for updates.';

  CheckCommand() {
    argParser.addOption(
      'output',
      abbr: 'o',
      allowed: ['json', 'name'],
      allowedHelp: {
        'json': 'Output as json.',
        'name': 'Output just the dependency names.',
      },
      help: 'Output format.',
    );
  }

  @override
  Future<void> run() async {
    String file = globalResults?['file'];
    String? output = argResults?['output'];

    var config = await Config.file(File(file));
    var states = await VersionChecker(config).checkVersions();
    switch (output) {
      case 'json':
        print(
          jsonEncode(
            states
                .where((state) => state.hasUpdate)
                .map((state) => {
                      'name': state.name,
                      'currentVersion':
                          state.printVersion(state.currentVersion),
                      'newestVersion': state.printVersion(state.newestVersion),
                    })
                .toList(),
          ),
        );
        break;
      case 'name':
        print(
          states
              .where((state) => state.hasUpdate)
              .map((state) => state.name)
              .join('\n'),
        );
        break;
      default:
        VersionChecker.printUpdates(states);
    }
  }
}

class GitHubCommand extends Command {
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
      valueHelp: 'fischerscode/UpToDate',
    );
    argParser.addOption(
      'token',
      abbr: 't',
      help:
          'The token used for authentication. If missing, the environment variable \$GITHUB_TOKEN will be used',
    );
  }

  @override
  Future<void> run() async {
    var envs = Platform.environment;
    String? repository = argResults?['repository'] ?? envs['GITHUB_REPOSITORY'];
    if (repository == null) {
      print(
          'No token is specified.\nPlease either use --repository or set GITHUB_REPOSITORY is set as an environment variable.');
      exit(-1);
    }
    String? token = argResults?['token'] ?? envs['GITHUB_TOKEN'];
    if (token == null) {
      print(
          'No token is specified.\nPlease either use --token or set GITHUB_TOKEN is set as an environment variable.');
      exit(-1);
    }

    String file = globalResults?['file'];

    var config = await Config.file(File(file));
    var states = await VersionChecker(config).checkVersions();
    await IssueController(repo: repository, token: token)
        .handleDependencies(states);
  }
}
