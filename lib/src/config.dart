import 'dart:io';

import 'package:version/version.dart';
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

  List<GenericDependency> get dependencies {
    return config
            .getMapValue('dependencies')
            ?.asList()
            ?.nodes
            .map<GenericDependency?>((dependency) {
              var type = dependency.getMapValue('type')?.asString();
              var name = dependency.getMapValue('name')?.asString();
              var currentVersion =
                  dependency.getMapValue('currentVersion')?.asString();
              if (type != null && name != null && currentVersion != null) {
                switch (type) {
                  case WebDependency.identifier:
                    return WebDependency.parse(
                        name: name,
                        yaml: dependency,
                        currentVersion: currentVersion);

                  case WebJsonDependency.identifier:
                    return WebJsonDependency.parse(
                        name: name,
                        yaml: dependency,
                        currentVersion: currentVersion);

                  case GitDependency.identifier:
                    return GitDependency.parse(
                        name: name,
                        yaml: dependency,
                        currentVersion: currentVersion);
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
