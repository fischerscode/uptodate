class GitHubConstants {
  static final Uri Function(String repo, int page) releaseUrl = (repo, page) =>
      Uri.parse('https://api.github.com/repos/$repo/releases?page=$page');
  static final Uri Function(String repo, int page) tagUrl = (repo, page) =>
      Uri.parse('https://api.github.com/repos/$repo/tags?page=$page');

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
  }) issueCreateUrl = ({
    required repo,
  }) =>
      Uri.parse('https://api.github.com/repos/$repo/issues');
}
