import 'package:version/version.dart';

import 'config.dart';

class VersionChecker {
  final Config config;

  VersionChecker(this.config);

  Future<List<DependencyState>> checkVersions({bool? verbose}) async {
    var states = <DependencyState>[];
    for (var dependency in config.dependencies(verbose: verbose)) {
      if (verbose ?? false) {
        print('Checking ${dependency.name}');
      }
      var latestVersion = await dependency.latestVersion();
      states.add(DependencyState(
        name: dependency.name,
        currentVersion: dependency.currentVersion,
        latestVersion: latestVersion,
        versionPrinter: (version) => dependency.printVersion(version),
        issueTitle: dependency.buildIssueTitle(latestVersion),
        issueBody: dependency.buildIssueBody(latestVersion),
        issueLabels: dependency.issueLabels,
      ));
    }
    return states;
  }

  static void printUpdates(List<DependencyState> states) {
    for (var state in states) {
      if (state.hasUpdate) {
        print(
            '${state.name}: ${state.printVersion(state.currentVersion)} -> ${state.printVersion(state.latestVersion)}');
      }
    }
  }
}

class DependencyState {
  final String name;
  final Version currentVersion;
  final Version latestVersion;
  final String Function(Version version) _versionPrinter;

  final String issueTitle;
  final String issueBody;

  final List<String> issueLabels;

  DependencyState({
    required this.name,
    required this.currentVersion,
    required this.latestVersion,
    required String Function(Version version) versionPrinter,
    required this.issueTitle,
    required this.issueBody,
    required this.issueLabels,
  }) : _versionPrinter = versionPrinter;

  bool get hasUpdate => latestVersion > currentVersion;

  String printVersion(Version version) {
    return _versionPrinter(version);
  }
}
