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
  List<String> ignore = [' ', '\n', '\t'];
  List<String> quotes = ['"'];
  List<String> operators = ['<', '<=', '=', '>=', '>', '+', '-', '*', '/'];
  String symbols = '<=>+-*/'; // possible operator and assignment symbols
  String assignment = '<-';

  Lexer(this.code) {
    this.char = code[index];
  }

  void moveForward() {
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
      this.moveForward();
    }
    return word;
  }

  String getNumber() {
    String num = '';
    while (!this.end && isNumeric(this.char)) {
      num += this.char;
      this.moveForward();
    }
    return num;
  }

  String getSymbols() {
    String symbols = '';
    while (!this.end && isSymbol(this.char)) {
      symbols += this.char;
      this.moveForward();
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

        continue;
      }
      if (isSymbol(this.char)) {
        String symbols = this.getSymbols();
        if (symbols == this.assignment) {
          this.tokens.add(new Assignment(symbols));

          continue;
        } else if (this.operators.contains(symbols)) {
          this.tokens.add(new Operator(symbols));

          continue;
        }
        // else isNumeric
      } 
      if (isNumeric(this.char) || this.char == '+' || this.char == '-') {
        String firstDigit = this.char; // could be digit or sign
        this.moveForward();
        String num = firstDigit + getNumber();
        if (num.contains('.')) this.tokens.add(new Double(num));
        else this.tokens.add(new Integer(num));

        continue;
      }
      if (quotes.contains(this.char)) {
        String begin = this.char;
        this.moveForward();
        String text = '';
        while (!end && this.char != begin) {
          text += this.char;
          this.moveForward();
        }
        if (this.char == begin) {
          this.tokens.add(new Text(text));

          this.moveForward();
          continue;
        } else throw new Exception('missing closing quote');
      }
      if (ignore.contains(this.char)) {
        this.moveForward();
        continue;
      }
      throw new Exception('invalid character');
    }
    return this.tokens;
  }
}