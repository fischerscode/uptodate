class GitHubConstants {
  static Uri releaseUrl(String repo, int page) =>
      Uri.parse('https://api.github.com/repos/$repo/releases?page=$page');

  static Uri tagUrl(String repo, int page) =>
      Uri.parse('https://api.github.com/repos/$repo/tags?page=$page');

  static Uri issuesListUrl({
    required String repo,
    required String filter,
    String? labels,
    String? state,
  }) =>
      Uri.parse(
          'https://api.github.com/repos/$repo/issues?filter=$filter&labels=${labels ?? ''}&per_page=100&state=${state ?? 'all'}');

  static Uri issueCreateUrl({
    required String repo,
  }) =>
      Uri.parse('https://api.github.com/repos/$repo/issues');
}
