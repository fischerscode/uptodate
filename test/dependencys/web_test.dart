import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:uptodate/src/dependencies/dependency.dart';
import 'package:version/version.dart';
import 'web_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('test WebDependency', () {
    final dependency = WebDependency(
      name: 'testDependency',
      currentVersion: Version(1, 0, 0),
      url: Uri.parse('http://example.com'),
      issueTitle: '\$name: \$currentVersion -> \$newestVersion',
      issueBody: '\$name: \$currentVersion -> \$newestVersion',
    );
    test('test Success', () async {
      final client = MockClient();

      when(client.get(any))
          .thenAnswer((realInvocation) async => http.Response('1.5.6', 200));

      expect(await dependency.newestVersion(client: client),
          TypeMatcher<Version>());
      expect(await dependency.newestVersion(client: client), Version(1, 5, 6));
      expect(dependency.buildIssueTitle(Version(1, 5, 6)),
          'testDependency: 1.0.0 -> 1.5.6');
      expect(dependency.buildIssueBody(Version(1, 5, 6)),
          'testDependency: 1.0.0 -> 1.5.6');
      verify(client.get(any)).called(2);
    });
    test('test Failure', () async {
      final client = MockClient();

      when(client.get(any)).thenAnswer(
          (realInvocation) async => http.Response('not Found', 404));

      expect(() async => await dependency.newestVersion(client: client),
          throwsException);
      verify(client.get(any)).called(1);
    });
  });
}
