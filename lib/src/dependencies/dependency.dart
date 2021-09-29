library dependencies;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:version/version.dart';
import 'package:yaml/src/yaml_node.dart';
import 'package:yaml/yaml.dart';
import 'package:yamltools/yamltools.dart';

import '../github_consts.dart';
import '../tools/substitute.dart';

part 'web_dependency.dart';
part 'webjson_dependency.dart';
part 'webyaml_dependency.dart';
part 'github_dependency.dart';
part 'helm_dependency.dart';

abstract class GenericDependency {
  GenericDependency({
    required String? issueTitle,
    required String? issueBody,
  })   : issueTitle = issueTitle ?? 'Update \$name to \$latestVersion',
        issueBody = issueBody ??
            'Update \$name from \$currentVersion to \$latestVersion';

  /// The version of the installed/used dependency.
  Version get currentVersion;

  /// Get the latest version available.
  Future<Version> latestVersion();

  final String issueTitle;

  final String issueBody;

  /// Format the version for printing
  String printVersion(Version version) {
    return version.toString();
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
