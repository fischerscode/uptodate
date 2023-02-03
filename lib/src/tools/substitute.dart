extension SubstitutableString on String {
  /// Replace every occurrence of the [variable] marked by the [character]
  /// with the [value], except the [character] is escaped by the [escapeCharacter].
  String substitute(
    String variable,
    String value, {
    String character = '\$',
    String escapeCharacter = '\\',
  }) {
    return replaceAll('$escapeCharacter$escapeCharacter',
            '$escapeCharacter$escapeCharacter ')
        .replaceAll('$escapeCharacter$character',
            '$escapeCharacter$character$escapeCharacter')
        .replaceAll('$character$variable', value)
        .replaceAll('$escapeCharacter$character$escapeCharacter', character)
        .replaceAll('$escapeCharacter$escapeCharacter ', escapeCharacter);
  }
}
