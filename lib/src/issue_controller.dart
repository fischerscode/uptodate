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

  Future<void> handleDependencies(List<DependencyState> states) async {
    if (states.any((state) => state.hasUpdate)) {
      var existingIssues = await getIssues();
      for (var state in states) {
        if (state.hasUpdate) {
          var issue = existingIssues
              .where((issue) => issue.title == state.issueTitle)
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
    var response = await http.post(
      GitHubConstants.issueCreateUrl(repo: repo),
      headers: {
        'authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'title': state.issueTitle,
        'body': state.issueBody,
        'labels': state.issueLabels,
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 400) {
      throw '''Failed to create issues '${state.issueTitle}': ${response.body}''';
    } else {
      print('Created issue: ${state.issueTitle}');
    }
  }
}

class Issue {
  // int? _number;
  String title;
  String state;
  String? body;
  bool locked;

  Issue({
    int? number,
    required this.title,
    required this.state,
    required this.body,
    required this.locked,
  })
  //  : _number = number
  ;

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
