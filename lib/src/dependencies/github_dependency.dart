part of dependencies;

class GitHubDependency extends GenericDependency {
  static const String identifier = 'github';

  @override
  final String name;
  final String repo;
  final bool isTag;
  final String path;

  GitHubDependency({
    required this.name,
    required String currentVersion,
    required this.repo,
    String? path,
    String? prefix,
    required String? issueTitle,
    required String? issueBody,
    required this.isTag,
    required List<String> issueLabels,
  })  : path = path ?? (isTag ? 'name' : 'tag_name'),
        super(
          issueTitle: issueTitle,
          issueBody: issueBody,
          currentVersion: currentVersion,
          prefix: prefix,
          issueLabels: issueLabels,
        );

  static GitHubDependency? parse({
    required String name,
    required YamlNode yaml,
    required String currentVersion,
    required String? issueTitle,
    required String? issueBody,
    required List<String> issueLabels,
  }) {
    var repo = yaml.getMapValue('repo')?.asString();
    var path = yaml.getMapValue('path')?.asString();
    var prefix = yaml.getMapValue('prefix')?.asString();
    var isTag = yaml.getMapValue('isTag')?.asBool() ?? false;
    if (repo != null) {
      return GitHubDependency(
        name: name,
        currentVersion: currentVersion,
        repo: repo,
        path: path,
        prefix: prefix ?? '',
        issueTitle: issueTitle,
        issueBody: issueBody,
        isTag: isTag,
        issueLabels: issueLabels,
      );
    }
    return null;
  }

  @override
  Version get currentVersion => _currentVersion;

  @override
  Future<Version> latestVersion({http.Client? client}) async {
    final regexp = RegExp('^$prefix'
        r'([\d.]+)(-([0-9A-Za-z\-.]+))?(\+([0-9A-Za-z\-.]+))?$');

    var page = 1;
    while (true) {
      final response = await WebDependency._get(client: client)((isTag
          ? GitHubConstants.tagUrl
          : GitHubConstants.releaseUrl)(repo, page));
      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw Exception('Invalid response: ${response.statusCode}');
      } else {
        var json = jsonDecode(response.utf8Body);
        if (json is! List) {
          throw Exception('Invalid response: ${response.utf8Body}');
        }
        if (json.isEmpty) {
          throw Exception(
              'No matching ${isTag ? 'tag' : 'release'} found for dependency $name!');
        }

        for (var item in json) {
          var version = WebJsonDependency.jsonPathResolver(item, path);

          if (isTag ||
              (item['prerelease'] == false && item['draft'] == false)) {
            if (regexp.hasMatch(version)) {
              var result = Version.parse(version.substring(prefix.length));
              if (!result.isPreRelease) {
                return result;
              }
            }
          }
        }
      }

      page++;
    }
  }
}
