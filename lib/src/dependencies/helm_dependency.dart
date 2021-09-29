part of dependencies;

class HelmDependency extends WebYamlDependency {
  static const String identifier = 'helm';

  final String repo;
  final String chart;

  HelmDependency({
    required String name,
    required String currentVersion,
    required this.repo,
    required this.chart,
    String? path,
    String? prefix,
    required String? issueTitle,
    required String? issueBody,
  }) : super(
          currentVersion: currentVersion,
          name: name,
          path: path ?? 'entries.$chart.0.version',
          url: Uri.parse('$repo${repo.endsWith('/') ? '' : '/'}index.yaml'),
          prefix: prefix ?? '',
          issueTitle: issueTitle,
          issueBody: issueBody,
        );

  static HelmDependency? parse({
    required String name,
    required YamlNode yaml,
    required String currentVersion,
    required String? issueTitle,
    required String? issueBody,
  }) {
    var repo = yaml.getMapValue('repo')?.asString();
    var chart = yaml.getMapValue('chart')?.asString();
    var path = yaml.getMapValue('path')?.asString();
    var prefix = yaml.getMapValue('prefix')?.asString();
    if (repo != null && chart != null) {
      return HelmDependency(
        name: name,
        currentVersion: currentVersion,
        repo: repo,
        chart: chart,
        path: path,
        prefix: prefix ?? '',
        issueTitle: issueTitle,
        issueBody: issueBody,
      );
    }
  }
}
