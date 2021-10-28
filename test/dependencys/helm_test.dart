import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:uptodate/src/dependencies/dependency.dart';
import 'package:version/version.dart';
import 'helm_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  test('test HelmDependency', () async {
    final dependency = HelmDependency(
      name: 'testDependency',
      currentVersion: '1.2.3',
      issueTitle: '\$name: \$currentVersion -> \$latestVersion',
      issueBody: '\$name: \$currentVersion -> \$latestVersion',
      repo: 'http://example.com/helmCharts/',
      chart: 'testchart',
      issueLabels: [],
    );

    final client = MockClient();

    when(client.get(any)).thenAnswer((realInvocation) async => http.Response('''
entries:
  testchart:
   - version: 1.2.4
   - version: 1.2.3''', 200));

    expect(
        await dependency.latestVersion(client: client), TypeMatcher<Version>());
    expect(await dependency.latestVersion(client: client), Version(1, 2, 4));
    verify(client.get(any)).called(2);
    expect(dependency.buildIssueTitle(Version(1, 2, 4)),
        'testDependency: 1.2.3 -> 1.2.4');
    expect(dependency.buildIssueBody(Version(1, 2, 4)),
        'testDependency: 1.2.3 -> 1.2.4');
    expect(
        dependency.url.toString(), 'http://example.com/helmCharts/index.yaml');
  });
}
