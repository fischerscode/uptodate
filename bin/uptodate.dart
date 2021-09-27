import 'dart:io';

import 'package:uptodate/uptodate.dart';

void main(List<String> arguments) async {
  var code = await UpToDateCommandRunner().run(arguments);
  await Future.wait([stdout.close(), stderr.close()]);
  exit(code);
}
