import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';

import '../config.dart';
import '../version_checker.dart';

class CheckCommand extends Command<int> {
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
  Future<int> run() async {
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

    return 0;
  }
}
