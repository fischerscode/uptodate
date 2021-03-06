import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:yamltools/yamltools.dart';

import 'dependencies/dependency.dart';

class Config {
  final YamlNode config;

  Config(this.config);

  factory Config.string(String config) {
    return Config(loadYaml(config));
  }

  static Future<Config> file(File file) async {
    return Config.string(await file.readAsString());
  }

  List<GenericDependency> dependencies({bool? verbose}) {
    var defaultIssueTitle = config.getMapValue('defaultIssueTitle')?.asString();
    var defaultIssueBody = config.getMapValue('defaultIssueBody')?.asString();
    return config
            .getMapValue('dependencies')
            ?.asList()
            ?.nodes
            .map<GenericDependency?>((dependency) {
              var type = dependency.getMapValue('type')?.asString();
              var name = dependency.getMapValue('name')?.asString();
              var currentVersion =
                  dependency.getMapValue('currentVersion')?.asString();
              var issueTitle = dependency.getMapValue('issueTitle')?.asString();
              var issueBody = dependency.getMapValue('issueBody')?.asString();
              var issueLabels = dependency
                      .getMapValue('issueLabels')
                      ?.asList()
                      ?.nodes
                      .map((e) => e.asString())
                      .where((element) => element != null)
                      .map((e) => e!)
                      .toList() ??
                  [];
              if (type != null && name != null && currentVersion != null) {
                print('read dependency $name');
                switch (type) {
                  case WebDependency.identifier:
                    return WebDependency.parse(
                      name: name,
                      yaml: dependency,
                      currentVersion: currentVersion,
                      issueTitle: issueTitle ?? defaultIssueTitle,
                      issueBody: issueBody ?? defaultIssueBody,
                      issueLabels: issueLabels,
                    );

                  case WebJsonDependency.identifier:
                    return WebJsonDependency.parse(
                      name: name,
                      yaml: dependency,
                      currentVersion: currentVersion,
                      issueTitle: issueTitle ?? defaultIssueTitle,
                      issueBody: issueBody ?? defaultIssueBody,
                      issueLabels: issueLabels,
                    );

                  case WebYamlDependency.identifier:
                    return WebYamlDependency.parse(
                      name: name,
                      yaml: dependency,
                      currentVersion: currentVersion,
                      issueTitle: issueTitle ?? defaultIssueTitle,
                      issueBody: issueBody ?? defaultIssueBody,
                      issueLabels: issueLabels,
                    );

                  case GitHubDependency.identifier:
                    return GitHubDependency.parse(
                      name: name,
                      yaml: dependency,
                      currentVersion: currentVersion,
                      issueTitle: issueTitle ?? defaultIssueTitle,
                      issueBody: issueBody ?? defaultIssueBody,
                      issueLabels: issueLabels,
                    );

                  case HelmDependency.identifier:
                    return HelmDependency.parse(
                      name: name,
                      yaml: dependency,
                      currentVersion: currentVersion,
                      issueTitle: issueTitle ?? defaultIssueTitle,
                      issueBody: issueBody ?? defaultIssueBody,
                      issueLabels: issueLabels,
                    );
                }
              }
              return null;
            })
            .where((element) => element != null)
            .map((e) => e!)
            .toList() ??
        [];
  }
}
