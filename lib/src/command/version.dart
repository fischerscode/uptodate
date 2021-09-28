import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:version/version.dart';

class VersionCommand extends Command<int> {
  @override
  final name = 'version';
  @override
  final description = 'Print uptodate version.';

  static final Version version = Version(0, 0, 2);

  @override
  Future<int> run() async {
    print('uptodate $version');
    return 0;
  }
}
