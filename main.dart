import 'dart:convert';
import 'dart:io';

import 'memory.dart';
import 'lexer.dart';
import 'tokens.dart';
import 'parser.dart';

void main() {
  print('Dart Interpreter');
  var memory = new Memory({}, {});
  String input = stdin.readLineSync(encoding: utf8) ?? '';
  var lexer = new Lexer(input);
  List<Token> tokens = lexer.generateTokens();
  printTokens(tokens);
  var parser = new Parser(tokens);
  List<dynamic Function(Memory memory)> instructions = parser.parse();
  for (dynamic Function(Memory memory) instruction in instructions) {
    memory = instruction(memory);
  }
  print(memory.variables);
}