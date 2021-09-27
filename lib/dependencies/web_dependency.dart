part of dependencies;

class WebDependency extends GenericDependency {
  @override
  final String name;
  Version _currentVersion;
  final Uri url;
  static const String identifier = 'web';
  final Version Function(http.Response) versionExtractor;

  WebDependency({
    required this.name,
    required Version currentVersion,
    required this.url,
    this.versionExtractor = defaultVersionExtractor,
  }) : _currentVersion = currentVersion;

  static Version defaultVersionExtractor(http.Response response) =>
      Version.parse(response.body);

  @override
  Version get currentVersion => _currentVersion;

  @override
  Future<Version> newestVersion({http.Client? client}) async {
    final response = await _get(client: client)(url);
    if (response.statusCode < 200 || response.statusCode >= 400) {
      throw Exception('Invalid response: ${response.statusCode}');
    } else {
      return versionExtractor(response);
    }
  }

  Future<http.Response> Function(Uri url, {Map<String, String>? headers}) _get(
      {http.Client? client}) {
    return (Uri url, {Map<String, String>? headers}) =>
        client?.get(url, headers: headers) ?? http.get(url, headers: headers);
  }

  static GenericDependency? parse({
    required String name,
    required YamlNode yaml,
    required String currentVersion,
  }) {
    var url = yaml.getMapValue('url')?.asString();
    if (url != null && Uri.tryParse(url) != null) {
      return WebDependency(
          name: name,
          currentVersion: Version.parse(currentVersion),
          url: Uri.parse(url));
    }
  }
}
