import 'package:version/version.dart';

import 'config.dart';

class VersionChecker {
  final Config config;

  VersionChecker(this.config);

  Future<List<DependencyState>> checkVersions() async {
    var states = <DependencyState>[];
    for (var dependency in config.dependencies) {
      var newestVersion = await dependency.newestVersion();
      states.add(DependencyState(
        name: dependency.name,
        currentVersion: dependency.currentVersion,
        newestVersion: newestVersion,
        versionPrinter: (version) => dependency.printVersion(version),
      ));
    }
    return states;
  }

  static void printUpdates(List<DependencyState> states) {
    for (var state in states) {
      if (state.hasUpdate) {
        print(
            '${state.name}: ${state.printVersion(state.currentVersion)} -> ${state.printVersion(state.newestVersion)}');
      }
    }
  }
}

class DependencyState {
  final String name;
  final Version currentVersion;
  final Version newestVersion;
  final String Function(Version version) _versionPrinter;

  DependencyState({
    required this.name,
    required this.currentVersion,
    required this.newestVersion,
    required String Function(Version version) versionPrinter,
  }) : _versionPrinter = versionPrinter;

  bool get hasUpdate => newestVersion > currentVersion;

  String printVersion(Version version) {
    return _versionPrinter(version);
  }
}
