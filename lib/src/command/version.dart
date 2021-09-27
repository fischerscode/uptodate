import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:version/version.dart';

class VersionCommand extends Command<int> {
  @override
  final name = 'version';
  @override
  final description = 'Print UpToDate version.';

  static final Version version = Version(0, 0, 1);

  @override
  Future<int> run() async {
    print('UpToDate $version');
    return 0;
  }
}
