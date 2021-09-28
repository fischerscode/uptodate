library dependencies;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:version/version.dart';
import 'package:yaml/src/yaml_node.dart';
import 'package:yamltools/yamltools.dart';

import '../github_consts.dart';
import '../tools/substitute.dart';

part 'web_dependency.dart';
part 'webjson_dependency.dart';
part 'git_dependency.dart';

abstract class GenericDependency {
  GenericDependency({
    required String? issueTitle,
    required String? issueBody,
  })   : issueTitle = issueTitle ?? 'Update \$name to \$newestVersion',
        issueBody = issueBody ??
            'Update \$name from \$currentVersion to \$newestVersion';

  /// The version of the installed/used dependency.
  Version get currentVersion;

  /// Get the newest version available.
  Future<Version> newestVersion();

  final String issueTitle;

  final String issueBody;

  /// Format the version for printing
  String printVersion(Version version) {
    return version.toString();
  }

  /// The name of the dependency.
  String get name;

  String buildIssueTitle(Version newestVersion) =>
      substitute(issueTitle, newestVersion);

  String buildIssueBody(Version newestVersion) =>
      substitute(issueBody, newestVersion);

  String substitute(String text, Version newestVersion) => text
      .substitute('name', name)
      .substitute('newestVersion', printVersion(newestVersion))
      .substitute('currentVersion', printVersion(currentVersion));
}
