part of dependencies;

class GitDependency extends WebJsonDependency {
  static const String identifier = 'git';

  final String repo;

  GitDependency({
    required String name,
    required String currentVersion,
    required this.repo,
    String? path,
    String? prefix,
    required String? issueTitle,
    required String? issueBody,
  }) : super(
          currentVersion: currentVersion,
          name: name,
          path: path ?? 'tag_name',
          url: GitHubConstants.releaseUrl(repo),
          prefix: prefix ?? '',
          issueTitle: issueTitle,
          issueBody: issueBody,
        );

  static GitDependency? parse({
    required String name,
    required YamlNode yaml,
    required String currentVersion,
    required String? issueTitle,
    required String? issueBody,
  }) {
    var repo = yaml.getMapValue('repo')?.asString();
    var path = yaml.getMapValue('path')?.asString();
    var prefix = yaml.getMapValue('prefix')?.asString();
    if (repo != null) {
      return GitDependency(
        name: name,
        currentVersion: currentVersion,
        repo: repo,
        path: path,
        prefix: prefix ?? '',
        issueTitle: issueTitle,
        issueBody: issueBody,
      );
    }
  }
}
