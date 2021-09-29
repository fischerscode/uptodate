import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:uptodate/src/dependencies/dependency.dart';
import 'package:version/version.dart';
import 'webYaml_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  test('test WebYamlDependency', () async {
    final dependency = WebYamlDependency(
      name: 'testDependency',
      currentVersion: 'v1.2.3',
      url: Uri.parse('https://postman-echo.com/get?version=v1.2.4'),
      path: 'args.version',
      prefix: 'v',
      issueTitle: '\$name: \$currentVersion -> \$latestVersion',
      issueBody: '\$name: \$currentVersion -> \$latestVersion',
    );

    final client = MockClient();

    when(client.get(any)).thenAnswer((realInvocation) async =>
        http.Response('args:\n  version: "v1.2.4"', 200));

    expect(
        await dependency.latestVersion(client: client), TypeMatcher<Version>());
    expect(await dependency.latestVersion(client: client), Version(1, 2, 4));
    verify(client.get(any)).called(2);
    expect(dependency.buildIssueTitle(Version(1, 2, 4)),
        'testDependency: v1.2.3 -> v1.2.4');
    expect(dependency.buildIssueBody(Version(1, 2, 4)),
        'testDependency: v1.2.3 -> v1.2.4');
  });
}
