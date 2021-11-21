part of dependencies;

class WebYamlDependency extends WebDependency {
  static const String identifier = 'webyaml';

  final String path;

  WebYamlDependency({
    required final String name,
    required final String currentVersion,
    required final Uri url,
    required this.path,
    required String prefix,
    required String? issueTitle,
    required String? issueBody,
    Version Function(http.Response)? versionExtractor,
    required List<String> issueLabels,
  }) : super(
          name: name,
          currentVersion: currentVersion,
          url: url,
          prefix: prefix,
          issueTitle: issueTitle,
          issueBody: issueBody,
          versionExtractor: versionExtractor ??
              (response) {
                var yaml = loadYaml(response.body);

                var version = yamlPathResolver(yaml, path);
                if (version.startsWith(prefix)) {
                  version = version.substring(prefix.length);
                }
                return Version.parse(version);
              },
          issueLabels: issueLabels,
        );

  static String yamlPathResolver(dynamic yaml, String path) {
    for (final key in path.split('.')) {
      if (yaml is YamlMap && yaml.containsKey(key)) {
        yaml = yaml[key];
      } else if (yaml is YamlList &&
          int.tryParse(key) != null &&
          yaml.length > int.parse(key)) {
        yaml = yaml[int.parse(key)];
      } else {
        throw 'No version found!';
      }
    }
    if (yaml is String) {
      return yaml;
    } else {
      throw 'No version found!';
    }
  }

  static GenericDependency? parse({
    required String name,
    required YamlNode yaml,
    required String currentVersion,
    required String? issueTitle,
    required String? issueBody,
    required List<String> issueLabels,
  }) {
    var url = yaml.getMapValue('url')?.asString();
    var path = yaml.getMapValue('path')?.asString() ?? '';
    var prefix = yaml.getMapValue('prefix')?.asString();
    if (url != null && Uri.tryParse(url) != null) {
      return WebYamlDependency(
        name: name,
        currentVersion: currentVersion,
        url: Uri.parse(url),
        path: path,
        prefix: prefix ?? '',
        issueTitle: issueTitle,
        issueBody: issueBody,
        issueLabels: issueLabels,
      );
    }
  }
}
