import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:uptodate/src/dependencies/dependency.dart';
import 'package:version/version.dart';
import 'github_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  test('test GitHub release', () async {
    final client = MockClient();
    when(client.get(Uri.parse(
            'https://api.github.com/repos/fischerscode/api-test-repo/releases?page=1')))
        .thenAnswer(
            (realInvocation) async => http.Response(releasesResponse, 200));
    when(client.get(Uri.parse(
            'https://api.github.com/repos/fischerscode/api-test-repo/releases?page=2')))
        .thenAnswer((realInvocation) async => http.Response('[]', 200));

    final dependency = GitHubDependency(
      name: 'testDependency',
      currentVersion: 'release-0.0.1',
      issueTitle: '\$name: \$currentVersion -> \$latestVersion',
      issueBody: '\$name: \$currentVersion -> \$latestVersion',
      repo: 'fischerscode/api-test-repo',
      prefix: 'release-',
      isTag: false,
      issueLabels: [],
    );

    var latestVersion = await dependency.latestVersion(client: client);

    verify(client.get(any)).called(1);

    expect(latestVersion, TypeMatcher<Version>());
    expect(latestVersion, Version(1, 0, 0));

    expect(dependency.buildIssueTitle(latestVersion),
        'testDependency: release-0.0.1 -> release-1.0.0');
    expect(dependency.buildIssueBody(latestVersion),
        'testDependency: release-0.0.1 -> release-1.0.0');
  });
  test('test GitHub tag', () async {
    final client = MockClient();
    when(client.get(Uri.parse(
            'https://api.github.com/repos/fischerscode/api-test-repo/tags?page=1')))
        .thenAnswer((realInvocation) async => http.Response(tagsResponse, 200));
    when(client.get(Uri.parse(
            'https://api.github.com/repos/fischerscode/api-test-repo/tags?page=2')))
        .thenAnswer((realInvocation) async => http.Response('[]', 200));

    final dependency = GitHubDependency(
      name: 'testDependency',
      currentVersion: 'tag-0.0.1',
      issueTitle: '\$name: \$currentVersion -> \$latestVersion',
      issueBody: '\$name: \$currentVersion -> \$latestVersion',
      repo: 'fischerscode/api-test-repo',
      prefix: 'tag-',
      isTag: true,
      issueLabels: [],
    );

    var latestVersion = await dependency.latestVersion(client: client);
    verify(client.get(any)).called(1);
    expect(latestVersion, TypeMatcher<Version>());
    expect(latestVersion, Version(1, 0, 1));

    expect(dependency.buildIssueTitle(latestVersion),
        'testDependency: tag-0.0.1 -> tag-1.0.1');
    expect(dependency.buildIssueBody(latestVersion),
        'testDependency: tag-0.0.1 -> tag-1.0.1');
  });
}

const String tagsResponse = '''
[
  {
    "name": "tag-1.0.1",
    "zipball_url": "https://api.github.com/repos/fischerscode/api-test-repo/zipball/refs/tags/tag-1.0.1",
    "tarball_url": "https://api.github.com/repos/fischerscode/api-test-repo/tarball/refs/tags/tag-1.0.1",
    "commit": {
      "sha": "2c920e1b3b39b6a0aa8fb20953306eb14762a014",
      "url": "https://api.github.com/repos/fischerscode/api-test-repo/commits/2c920e1b3b39b6a0aa8fb20953306eb14762a014"
    },
    "node_id": "REF_kwDOGIkxe7NyZWZzL3RhZ3MvdGFnLTEuMC4x"
  },
  {
    "name": "tag-1.0.0",
    "zipball_url": "https://api.github.com/repos/fischerscode/api-test-repo/zipball/refs/tags/tag-1.0.0",
    "tarball_url": "https://api.github.com/repos/fischerscode/api-test-repo/tarball/refs/tags/tag-1.0.0",
    "commit": {
      "sha": "2c920e1b3b39b6a0aa8fb20953306eb14762a014",
      "url": "https://api.github.com/repos/fischerscode/api-test-repo/commits/2c920e1b3b39b6a0aa8fb20953306eb14762a014"
    },
    "node_id": "REF_kwDOGIkxe7NyZWZzL3RhZ3MvdGFnLTEuMC4w"
  },
  {
    "name": "release-1.0.1",
    "zipball_url": "https://api.github.com/repos/fischerscode/api-test-repo/zipball/refs/tags/release-1.0.1",
    "tarball_url": "https://api.github.com/repos/fischerscode/api-test-repo/tarball/refs/tags/release-1.0.1",
    "commit": {
      "sha": "2c920e1b3b39b6a0aa8fb20953306eb14762a014",
      "url": "https://api.github.com/repos/fischerscode/api-test-repo/commits/2c920e1b3b39b6a0aa8fb20953306eb14762a014"
    },
    "node_id": "REF_kwDOGIkxe7dyZWZzL3RhZ3MvcmVsZWFzZS0xLjAuMQ"
  },
  {
    "name": "release-1.0.0",
    "zipball_url": "https://api.github.com/repos/fischerscode/api-test-repo/zipball/refs/tags/release-1.0.0",
    "tarball_url": "https://api.github.com/repos/fischerscode/api-test-repo/tarball/refs/tags/release-1.0.0",
    "commit": {
      "sha": "2c920e1b3b39b6a0aa8fb20953306eb14762a014",
      "url": "https://api.github.com/repos/fischerscode/api-test-repo/commits/2c920e1b3b39b6a0aa8fb20953306eb14762a014"
    },
    "node_id": "REF_kwDOGIkxe7dyZWZzL3RhZ3MvcmVsZWFzZS0xLjAuMA"
  }
]
''';

const String releasesResponse = '''
[
  {
    "url": "https://api.github.com/repos/fischerscode/api-test-repo/releases/50464233",
    "assets_url": "https://api.github.com/repos/fischerscode/api-test-repo/releases/50464233/assets",
    "upload_url": "https://uploads.github.com/repos/fischerscode/api-test-repo/releases/50464233/assets{?name,label}",
    "html_url": "https://github.com/fischerscode/api-test-repo/releases/tag/release-1.0.1",
    "id": 50464233,
    "author": {
      "login": "fischerscode",
      "id": 45403027,
      "node_id": "MDQ6VXNlcjQ1NDAzMDI3",
      "avatar_url": "https://avatars.githubusercontent.com/u/45403027?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/fischerscode",
      "html_url": "https://github.com/fischerscode",
      "followers_url": "https://api.github.com/users/fischerscode/followers",
      "following_url": "https://api.github.com/users/fischerscode/following{/other_user}",
      "gists_url": "https://api.github.com/users/fischerscode/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/fischerscode/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/fischerscode/subscriptions",
      "organizations_url": "https://api.github.com/users/fischerscode/orgs",
      "repos_url": "https://api.github.com/users/fischerscode/repos",
      "events_url": "https://api.github.com/users/fischerscode/events{/privacy}",
      "received_events_url": "https://api.github.com/users/fischerscode/received_events",
      "type": "User",
      "site_admin": false
    },
    "node_id": "RE_kwDOGIkxe84DAgXp",
    "tag_name": "release-1.0.1",
    "target_commitish": "master",
    "name": "Release 1.0.1",
    "draft": false,
    "prerelease": true,
    "created_at": "2021-09-29T11:22:49Z",
    "published_at": "2021-09-29T11:23:38Z",
    "assets": [

    ],
    "tarball_url": "https://api.github.com/repos/fischerscode/api-test-repo/tarball/release-1.0.1",
    "zipball_url": "https://api.github.com/repos/fischerscode/api-test-repo/zipball/release-1.0.1",
    "body": ""
  },
  {
    "url": "https://api.github.com/repos/fischerscode/api-test-repo/releases/50464215",
    "assets_url": "https://api.github.com/repos/fischerscode/api-test-repo/releases/50464215/assets",
    "upload_url": "https://uploads.github.com/repos/fischerscode/api-test-repo/releases/50464215/assets{?name,label}",
    "html_url": "https://github.com/fischerscode/api-test-repo/releases/tag/release-1.0.0",
    "id": 50464215,
    "author": {
      "login": "fischerscode",
      "id": 45403027,
      "node_id": "MDQ6VXNlcjQ1NDAzMDI3",
      "avatar_url": "https://avatars.githubusercontent.com/u/45403027?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/fischerscode",
      "html_url": "https://github.com/fischerscode",
      "followers_url": "https://api.github.com/users/fischerscode/followers",
      "following_url": "https://api.github.com/users/fischerscode/following{/other_user}",
      "gists_url": "https://api.github.com/users/fischerscode/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/fischerscode/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/fischerscode/subscriptions",
      "organizations_url": "https://api.github.com/users/fischerscode/orgs",
      "repos_url": "https://api.github.com/users/fischerscode/repos",
      "events_url": "https://api.github.com/users/fischerscode/events{/privacy}",
      "received_events_url": "https://api.github.com/users/fischerscode/received_events",
      "type": "User",
      "site_admin": false
    },
    "node_id": "RE_kwDOGIkxe84DAgXX",
    "tag_name": "release-1.0.0",
    "target_commitish": "master",
    "name": "Release 1.0.0",
    "draft": false,
    "prerelease": false,
    "created_at": "2021-09-29T11:22:41Z",
    "published_at": "2021-09-29T11:23:20Z",
    "assets": [

    ],
    "tarball_url": "https://api.github.com/repos/fischerscode/api-test-repo/tarball/release-1.0.0",
    "zipball_url": "https://api.github.com/repos/fischerscode/api-test-repo/zipball/release-1.0.0",
    "body": ""
  }
]
''';
