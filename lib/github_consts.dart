class GitHubConstants {
  static final Uri Function(String repo) releaseUrl =
      (repo) => Uri.parse('https://api.github.com/repos/$repo/releases/latest');

  static final Uri Function({
    required String repo,
    required String filter,
    String? labels,
    String? state,
  }) issuesListUrl = ({
    required repo,
    required filter,
    labels,
    state,
  }) =>
      Uri.parse(
          'https://api.github.com/repos/$repo/issues?filter=$filter&labels=${labels ?? ''}&per_page=100&state=${state ?? 'all'}');
  static final Uri Function({
    required String repo,
    required String title,
    required String body,
    String? labels,
  }) issueCreateUrl = ({
    required repo,
    required title,
    required body,
    labels,
  }) =>
      Uri.parse(
          'https://api.github.com/repos/$repo/issues?title=$title&title=$body&labels=${labels ?? ''}');
}
