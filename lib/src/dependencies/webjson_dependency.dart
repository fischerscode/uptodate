part of dependencies;

class WebJsonDependency extends WebDependency {
  static const String identifier = 'webjson';

  final String path;

  WebJsonDependency({
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
          versionExtractor:
              versionExtractor ?? jsonVersionExtractor(path, prefix),
          issueTitle: issueTitle,
          issueBody: issueBody,
          prefix: prefix,
          issueLabels: issueLabels,
        );
  static Version Function(http.Response response) jsonVersionExtractor(
      String path, String prefix) {
    return (http.Response response) {
      var json = jsonDecode(response.body);

      var version = jsonPathResolver(json, path);
      if (version.startsWith(prefix)) {
        version = version.substring(prefix.length);
      }
      return Version.parse(version);
    };
  }

  static String jsonPathResolver(dynamic json, String path) {
    for (final key in path.split('.')) {
      if (json is Map<String, dynamic> && json.containsKey(key)) {
        json = json[key];
      } else if (json is List &&
          int.tryParse(key) != null &&
          json.length > int.parse(key)) {
        json = json[int.parse(key)];
      } else {
        throw 'No version found!';
      }
    }
    if (json is String) {
      return json;
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
      return WebJsonDependency(
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
