import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:uptodate/src/tools/substitute.dart';

void main() {
  test('test substitution', () {
    expect('hello \$name!'.substitute('name', 'octocat'), 'hello octocat!');
    expect('hello \\\$name!'.substitute('name', 'octocat'), 'hello \$name!');
    expect(
        'hello \\\$\\name!'.substitute('name', 'octocat'), 'hello \$\\name!');
    expect(
        'hello \\\\\$name!'.substitute('name', 'octocat'), 'hello \\octocat!');
  });
  test('test substitution with custom character', () {
    expect('hell\\o oname!'.substitute('name', 'octocat', character: 'o'),
        'hello octocat!');
    expect('hell\\o \\oname!'.substitute('name', 'octocat', character: 'o'),
        'hello oname!');
    expect('hell\\o \\o\\name!'.substitute('name', 'octocat', character: 'o'),
        'hello o\\name!');
    expect('hello \\\\oname!'.substitute('name', 'octocat', character: 'o'),
        'hello \\octocat!');
  });
  test('test substitution with custom character and escapeCharacter', () {
    expect(
        'helljo oname!'.substitute('name', 'octocat',
            character: 'o', escapeCharacter: 'j'),
        'hello octocat!');
    expect(
        'helljo joname!'.substitute('name', 'octocat',
            character: 'o', escapeCharacter: 'j'),
        'hello oname!');
    expect(
        'helljo jojname!'.substitute('name', 'octocat',
            character: 'o', escapeCharacter: 'j'),
        'hello ojname!');
    expect(
        'hello jjoname!'.substitute('name', 'octocat',
            character: 'o', escapeCharacter: 'j'),
        'hello joctocat!');
  });
}
