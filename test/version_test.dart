import 'dart:io';

import 'package:uptodate/src/command/version.dart';
import 'package:yamltools/yamltools.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('Test version', () async {
    var pubspec = await File('pubspec.yaml').readAsString();
    var version = loadYamlNode(pubspec).getMapValue('version')?.asString();
    // expect(version, TypeMatcher<String>());
    // expect(VersionCommand.version, TypeMatcher<String>());
    expect(VersionCommand.version.toString(), version);
  });
}
