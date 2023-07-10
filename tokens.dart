class Token {
  String value;

  Token(this.value);
}

class Call extends Token {
  Call(value) : super(value);
}

class Integer extends Token {
  Integer(value) : super(value);
}

class Text extends Token {
  Text(value) : super(value);
}

void printTokens(List<Token> tokens) {
  for (var token in tokens) {
    print('${token} -> "${token.value}"');
  }
}