import 'tokens.dart';

class Lexer {
  String code;
  int index = 0;
  late String char;
  List<Token> tokens = [];
  bool end = false;

  Lexer(this.code) {
    this.char = code[index];
  }

  void moveCursor() {
    index++;
    if (index < code.length) {
      this.char = code[index];
    } else {
      end = true;
    }
  }

  bool isValidLetter(String letter) {
    return letter.toLowerCase() != letter.toUpperCase() || letter == '_';
  }

  bool isNumeric(String letter) {
    return '0123456789'.contains(letter);
  }

  String getWord() {
    String word = '';
    while (!end && isValidLetter(this.char)) {
      word += this.char;
      this.moveCursor();
    }
    return word;
  }

  List<Token> generateTokens() {
    while (!end) {
      if (isValidLetter(this.char)) {
        String word = getWord();
        this.tokens.add(new Call(word)); // every word is a function call
      }
    }
    return this.tokens;
  }
}