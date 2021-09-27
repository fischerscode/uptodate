import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:uptodate/dependencies/dependency.dart';
import 'package:version/version.dart';
import 'webJson_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  test('test WebJsonDependency', () async {
    final dependency = WebJsonDependency(
      name: 'testDependency',
      currentVersion: 'v1.2.3',
      url: Uri.parse('https://postman-echo.com/get?version=v1.2.4'),
      path: 'args.version',
      prefix: 'v',
    );

    final client = MockClient();

    when(client.get(any)).thenAnswer((realInvocation) async =>
        http.Response('{"args":{"version":"v1.2.4"}}', 200));

    expect(
        await dependency.newestVersion(client: client), TypeMatcher<Version>());
    expect(await dependency.newestVersion(client: client), Version(1, 2, 4));
    verify(client.get(any)).called(2);
  });
}
