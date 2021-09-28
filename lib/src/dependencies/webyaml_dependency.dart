part of dependencies;

class WebYamlDependency extends WebJsonDependency {
  static const String identifier = 'webyaml';

  WebYamlDependency({
    required final String name,
    required final String currentVersion,
    required final Uri url,
    required String path,
    required String prefix,
    required String? issueTitle,
    required String? issueBody,
    Version Function(http.Response)? versionExtractor,
  }) : super(
          name: name,
          currentVersion: currentVersion,
          url: url,
          path: path,
          prefix: prefix,
          issueTitle: issueTitle,
          issueBody: issueBody,
          versionExtractor: versionExtractor ??
              (response) =>
                  WebJsonDependency.jsonVersionExtractor(path, prefix)(
                    http.Response(
                      jsonEncode(loadYaml(response.body)),
                      response.statusCode,
                      headers: response.headers,
                      isRedirect: response.isRedirect,
                      persistentConnection: response.persistentConnection,
                      reasonPhrase: response.reasonPhrase,
                      request: response.request,
                    ),
                  ),
        );

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
      return WebYamlDependency(
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
