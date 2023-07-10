import 'dart:convert';
import 'dart:io';

import 'memory.dart';
import 'lexer.dart';
import 'tokens.dart';

void main() {
  print('Dart Interpreter');
  var memory = new Memory({}, {});
  String input = stdin.readLineSync(encoding: utf8) ?? '';
  var lexer = new Lexer(input);
  List<Token> tokens = lexer.generateTokens();
  printTokens(tokens);
}