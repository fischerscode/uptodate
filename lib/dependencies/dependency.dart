library dependencies;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uptodate/github_consts.dart';
import 'package:version/version.dart';
import 'package:yaml/src/yaml_node.dart';
import 'package:yamltools/yamltools.dart';

part 'web_dependency.dart';
part 'webjson_dependency.dart';
part 'git_dependency.dart';

abstract class GenericDependency {
  /// The version of the installed/used dependency.
  Version get currentVersion;

  /// Get the newest version available.
  Future<Version> newestVersion();

  /// Format the version for printing
  String printVersion(Version version) {
    return version.toString();
  }

  /// The name of the dependency.
  String get name;
}
