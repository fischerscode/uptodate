import 'dart:convert';

import 'package:http/http.dart' as http;

import 'github_consts.dart';
import 'version_checker.dart';

class IssueController {
  final String token;
  final String repo;

  IssueController({
    required this.token,
    required this.repo,
  });

  String generateTitle(DependencyState state) =>
      'Update ${state.name} to ${state.printVersion(state.newestVersion)}';

  Future<void> handleDependencies(List<DependencyState> states) async {
    if (states.any((state) => state.hasUpdate)) {
      var existingIssues = await getIssues();
      for (var state in states) {
        if (state.hasUpdate) {
          var issue = existingIssues
              .where((issue) => issue.title == generateTitle(state))
              .firstOrNull();
          if (issue == null) {
            await createIssue(state);
          }
        }
      }
    }
  }

  Future<List<Issue>> getIssues() async {
    var response = await http.get(
        GitHubConstants.issuesListUrl(
          repo: repo,
          filter: 'created',
        ),
        headers: {
          'authorization': 'Bearer $token',
        });
    if (response.statusCode < 200 || response.statusCode >= 400) {
      throw 'Failed to get issues for $repo: ${response.body}';
    } else {
      return (jsonDecode(response.body) as List)
          .map((issue) => Issue.fromJsonObject(issue))
          .toList();
    }
  }

  Future<void> createIssue(DependencyState state) async {
    var title = generateTitle(state);
    var response = await http.post(
      GitHubConstants.issueCreateUrl(repo: repo),
      headers: {
        'authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'body': generateTitle(state),
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 400) {
      throw '''Failed to create issues '${generateTitle(state)}': ${response.body}''';
    } else {
      print('Created issue: $title');
    }
  }
}

class Issue {
  int? _number;
  String title;
  String state;
  String body;
  bool locked;

  Issue({
    int? number,
    required this.title,
    required this.state,
    required this.body,
    required this.locked,
  }) : _number = number;

  factory Issue.fromJsonObject(issue) {
    return Issue(
      title: issue['title'],
      state: issue['state'],
      body: issue['body'],
      locked: issue['locked'],
      number: issue['number'],
    );
  }
}

extension on Iterable<Issue> {
  Issue? firstOrNull() {
    try {
      return first;
    } catch (_) {
      return null;
    }
  }
}
