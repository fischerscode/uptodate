import 'package:test/test.dart';
import 'package:uptodate/src/dependencies/dependency.dart';
import 'package:version/version.dart';

void main() {
  test('Integration test GitHub release', () async {
    final dependency = GitHubDependency(
      name: 'testDependency',
      currentVersion: 'release-0.0.1',
      issueTitle: '\$name: \$currentVersion -> \$latestVersion',
      issueBody: '\$name: \$currentVersion -> \$latestVersion',
      repo: 'fischerscode/api-test-repo',
      prefix: 'release-',
      isTag: false,
    );

    var latestVersion = await dependency.latestVersion();

    expect(latestVersion, TypeMatcher<Version>());
    expect(latestVersion, Version(1, 0, 0));

    expect(dependency.buildIssueTitle(latestVersion),
        'testDependency: release-0.0.1 -> release-1.0.0');
    expect(dependency.buildIssueBody(latestVersion),
        'testDependency: release-0.0.1 -> release-1.0.0');
  }, tags: 'github');
  test('Integration test GitHub tag', () async {
    final dependency = GitHubDependency(
      name: 'testDependency',
      currentVersion: 'tag-0.0.1',
      issueTitle: '\$name: \$currentVersion -> \$latestVersion',
      issueBody: '\$name: \$currentVersion -> \$latestVersion',
      repo: 'fischerscode/api-test-repo',
      prefix: 'tag-',
      isTag: true,
    );

    var latestVersion = await dependency.latestVersion();

    expect(latestVersion, TypeMatcher<Version>());
    expect(latestVersion, Version(1, 0, 1));

    expect(dependency.buildIssueTitle(latestVersion),
        'testDependency: tag-0.0.1 -> tag-1.0.1');
    expect(dependency.buildIssueBody(latestVersion),
        'testDependency: tag-0.0.1 -> tag-1.0.1');
  }, tags: 'github');
}
