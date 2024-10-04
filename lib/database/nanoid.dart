import 'dart:math' show Random;

String nanoid({
  required int length,
  required Alphabet alphabet,
}) {
  final buf = StringBuffer();
  for (int index = length; 0 < index; index -= 1) {
    buf.write(alphabet.chars[_random.nextInt(alphabet.chars.length)]);
  }
  return buf.toString();
}

enum Alphabet {
  // https://github.com/CyberAP/nanoid-dictionary/blob/master/src/nolookalikes-safe.js
  noLookAlikesSafe('6789BCDFGHJKLMNPQRTWbcdfghjkmnpqrtwz'),
  ;

  const Alphabet(this.chars);
  final String chars;
}

final Random _random = _createRandom();

Random _createRandom() {
  try {
    return Random.secure();
  } on UnsupportedError {
    return Random();
  }
}
