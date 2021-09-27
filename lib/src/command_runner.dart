import 'package:args/command_runner.dart';
import 'package:uptodate/src/command/version.dart';

import 'command/check.dart';
import 'command/github.dart';

class UpToDateCommandRunner extends CommandRunner<int> {
  UpToDateCommandRunner()
      : super(
          'uptodate',
          'A tool that helps you to keep your repository up to date.',
        ) {
    addCommand(CheckCommand());
    addCommand(GitHubCommand());
    addCommand(VersionCommand());
    argParser.addOption(
      'file',
      abbr: 'f',
      help: 'The config file.',
      mandatory: true,
    );
  }

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      return await super.run(args) ?? 0;
    } on UsageException catch (e) {
      print(e);
      return 1;
    }
  }
}
