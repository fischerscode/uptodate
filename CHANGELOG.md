## v0.6.1

- Fixed a bug where creating GitHub issues failed if an existing one had an empty body.

## v0.6.0

- 💥 `WebYamlDependency` does not extend `WebJsonDependency` anymore, it has it's own `yamlPathResolver` now.
- `webyaml` and `helm` dependencies should now be more robust and compute faster.
- update dependencies

## v0.5.0

- add issueLabels

## v0.4.0

- publish to pub.dev
- add exports to `package:uptodate/uptodate.dart`

## v0.3.3

- fixed helm: dependency has not been checked

## v0.3.2

- added verbose
- improve usage exceptions

## v0.3.1

GitHubDependency: semantic prereleases are no longe selected.

## v0.3.0

- GitHubDependency:
  - added ability to reference tags
  - :boom: Now instead of the latest release (or tag), the latest (non prerelease) matching the prefix is used.

## v0.2.1

- fix helm

## v0.2.0

- :boom: rename `git` dependency to `github`
- :boom: rename `newestVersion` to `latestVersion`
- add [README](README.md)

## v0.1.1

- add WebYamlDependency
- WebJsonDependency: allow number in path
- add HelmDependency

## v0.1.0

- add issueTitle and issueBody
- Rename action to uptodate

## v0.0.2

- Rename action to up-to-date

## v0.0.1

- Initial version
