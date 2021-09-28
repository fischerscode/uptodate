part of dependencies;

class WebJsonDependency extends WebDependency {
  static const String identifier = 'webjson';

  final String path;
  final String prefix;

  WebJsonDependency({
    required final String name,
    required final String currentVersion,
    required final Uri url,
    required this.path,
    required String prefix,
    required String? issueTitle,
    required String? issueBody,
    Version Function(http.Response)? versionExtractor,
  })  : prefix = prefix,
        super(
          name: name,
          currentVersion: Version.parse(currentVersion.startsWith(prefix)
              ? currentVersion.substring(prefix.length)
              : currentVersion),
          url: url,
          versionExtractor:
              versionExtractor ?? jsonVersionExtractor(path, prefix),
          issueTitle: issueTitle,
          issueBody: issueBody,
        );
  static Version Function(http.Response response) jsonVersionExtractor(
      String path, String prefix) {
    return (http.Response response) {
      var json = jsonDecode(response.body);
      for (var key in path.split('.')) {
        if (json is Map<String, dynamic> && json.containsKey(key)) {
          json = json[key];
        } else {
          throw 'No version found!';
        }
      }
      if (json is String) {
        if (json.startsWith(prefix)) {
          json = json.substring(prefix.length);
        }
        return Version.parse(json);
      } else {
        throw 'No version found!';
      }
    };
  }

  @override
  String printVersion(Version version) {
    return '$prefix${super.printVersion(version)}';
  }

  static GenericDependency? parse({
    required String name,
    required YamlNode yaml,
    required String currentVersion,
    required String? issueTitle,
    required String? issueBody,
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
      );
    }
  }
}
