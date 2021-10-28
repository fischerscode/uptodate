import 'package:args/command_runner.dart';
import 'package:version/version.dart';

class VersionCommand extends Command<int> {
  @override
  final name = 'version';
  @override
  final description = 'Print uptodate version.';

  static final Version version = Version(0, 5, 0, preRelease: ["rc1"]);

  @override
  Future<int> run() async {
    print('Uptodate $version');
    return 0;
  }
}
