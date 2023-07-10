class Token {
  String value;

  Token(this.value);
}

class Keyword extends Token {
  Keyword(value) : super(value);
}

class Declaration extends Token {
  Declaration(value) : super(value);
}

class Assignment extends Token {
  Assignment(value) : super(value);
}

class Conditional extends Token {
  Conditional(value) : super(value);
}

class Operator extends Token {
  Operator(value) : super(value);
}

class Reference extends Token {
  Reference(value) : super(value);
}

class Integer extends Token {
  Integer(value) : super(value);
}

class Double extends Token {
  Double(value) : super(value);
}

class Text extends Token {
  Text(value) : super(value);
}

class Bracket extends Token {
  Bracket(value) : super(value);
}

class End extends Token {
  End(value) : super(value);
}

void printTokens(List<Token> tokens) {
  for (var token in tokens) {
    print('${token} -> "${token.value}"');
  }
}