part of dependencies;

class WebDependency extends GenericDependency {
  @override
  final String name;
  final Uri url;
  static const String identifier = 'web';
  final Version Function(http.Response) versionExtractor;

  WebDependency({
    required this.name,
    required String currentVersion,
    required this.url,
    this.versionExtractor = defaultVersionExtractor,
    required String? issueTitle,
    required String? issueBody,
    String? prefix,
  }) : super(
          issueTitle: issueTitle,
          issueBody: issueBody,
          currentVersion: currentVersion,
          prefix: prefix,
        );

  static Version defaultVersionExtractor(http.Response response) =>
      Version.parse(response.body);

  @override
  Future<Version> latestVersion({http.Client? client}) async {
    final response = await WebDependency._get(client: client)(url);
    if (response.statusCode < 200 || response.statusCode >= 400) {
      throw Exception('Invalid response: ${response.statusCode}');
    } else {
      return versionExtractor(response);
    }
  }

  static Future<http.Response> Function(Uri url, {Map<String, String>? headers})
      _get({http.Client? client}) {
    return (Uri url, {Map<String, String>? headers}) =>
        client?.get(url, headers: headers) ?? http.get(url, headers: headers);
  }

  static GenericDependency? parse({
    required String name,
    required YamlNode yaml,
    required String currentVersion,
    required String? issueTitle,
    required String? issueBody,
  }) {
    var url = yaml.getMapValue('url')?.asString();
    if (url != null && Uri.tryParse(url) != null) {
      return WebDependency(
        name: name,
        currentVersion: currentVersion,
        url: Uri.parse(url),
        issueTitle: issueTitle,
        issueBody: issueBody,
      );
    }
  }
}
