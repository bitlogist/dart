import 'tokens.dart';

class Lexer {
  String code;
  int index = 0;
  late String char;
  List<Token> tokens = [];
  bool end = false;

  List<String> keywords = ['return'];
  List<String> declarations = ['var', 'const'];
  List<String> conditionals = ['if', 'while'];
  String symbols = '<=>+-';
  String assignment = '<-';
  List<String> ignore = [' ', '\n'];

  Lexer(this.code) {
    this.char = code[index];
  }

  void moveCursor() {
    this.index++;
    if (index < this.code.length) {
      this.char = this.code[this.index];
    } else {
      this.end = true;
    }
  }

  bool isValidLetter(String letter) {
    return letter.toLowerCase() != letter.toUpperCase() || letter == '_';
  }

  bool isNumeric(String letter) {
    return '.0123456789'.contains(letter);
  }

  bool isSymbol(String letter) {
    return this.symbols.contains(letter);
  }

  String getWord() {
    String word = '';
    while (!this.end && isValidLetter(this.char)) {
      word += this.char;
      this.moveCursor();
    }
    return word;
  }

  String getNumber() {
    String num = '';
    while (!this.end && isNumeric(this.char)) {
      num += this.char;
      this.moveCursor();
    }
    return num;
  }

  String getSymbols() {
    String symbols = '';
    while (!this.end && isSymbol(this.char)) {
      symbols += this.char;
      this.moveCursor();
    }
    return symbols;
  }

  List<Token> generateTokens() {
    while (!this.end) {
      if (isValidLetter(this.char)) {
        String word = getWord();
        if (this.keywords.contains(word)) this.tokens.add(new Keyword(word));
        else if (this.declarations.contains(word)) this.tokens.add(new Declaration(word));
        else if (this.conditionals.contains(word)) this.tokens.add(new Conditional(word));
        else this.tokens.add(new Reference(word));

        this.moveCursor();
        continue;
      } 
      if (isNumeric(this.char) || this.char == '+' || this.char == '-') {
        String firstDigit = this.char; // could be digit or sign
        this.moveCursor();
        String num = firstDigit + getNumber();
        if (num.contains('.')) this.tokens.add(new Double(num));
        else this.tokens.add(new Integer(num));

        this.moveCursor();
        continue;
      } 
      if (isSymbol(this.char)) {
        String symbols = this.getSymbols();
        if (symbols == this.assignment) this.tokens.add(new Assignment(symbols));
        else this.tokens.add(new Operator(symbols));

        this.moveCursor();
        continue;
      } 
      if (ignore.contains(this.char)) {
        this.moveCursor();
        continue;
      }
      throw new Exception('invalid character');
    }
    return this.tokens;
  }
}