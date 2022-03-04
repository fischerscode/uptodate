library dependencies;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:version/version.dart';
import 'package:yaml/src/yaml_node.dart';
import 'package:yaml/yaml.dart';
import 'package:yamltools/yamltools.dart';

import '../github_consts.dart';
import '../tools/substitute.dart';
import '../tools/utf8response.dart';

part 'web_dependency.dart';
part 'webjson_dependency.dart';
part 'webyaml_dependency.dart';
part 'github_dependency.dart';
part 'helm_dependency.dart';

abstract class GenericDependency {
  GenericDependency({
    required String? issueTitle,
    required String? issueBody,
    final String? prefix,
    required final String currentVersion,
    required this.issueLabels,
  })  : issueTitle = issueTitle ?? 'Update \$name to \$latestVersion',
        issueBody = issueBody ??
            'Update \$name from \$currentVersion to \$latestVersion',
        prefix = prefix ?? '',
        _currentVersion = Version.parse(currentVersion.startsWith(prefix ?? '')
            ? currentVersion.substring((prefix ?? '').length)
            : currentVersion);

  /// The version of the installed/used dependency.
  Version get currentVersion => _currentVersion;

  /// Get the latest version available.
  Future<Version> latestVersion();

  final String issueTitle;

  final String issueBody;

  final String prefix;

  final List<String> issueLabels;

  Version _currentVersion;

  /// Format the version for printing
  @override
  String printVersion(Version version) {
    return '$prefix${version.toString()}';
  }

  /// The name of the dependency.
  String get name;

  String buildIssueTitle(Version latestVersion) =>
      substitute(issueTitle, latestVersion);

  String buildIssueBody(Version latestVersion) =>
      substitute(issueBody, latestVersion);

  String substitute(String text, Version latestVersion) => text
      .substitute('name', name)
      .substitute('latestVersion', printVersion(latestVersion))
      .substitute('currentVersion', printVersion(currentVersion));
}
