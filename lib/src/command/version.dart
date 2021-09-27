import 'dart:io';

import 'package:args/command_runner.dart';

class VersionCommand extends Command<int> {
  @override
  final name = 'version';
  @override
  final description = 'Get the version of this tool.';

  @override
  Future<int> run() async {
    print(Platform.version);
    return 0;
  }
}
