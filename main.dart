import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'memory.dart';
import 'lexer.dart';
import 'tokens.dart';
import 'parser.dart';

String exit = '~';

void main(List<String> args) {
  if (args.length == 1) {
    File(args[0]).readAsString().then((String code) {
      print(code);
      var memory = new Memory({}, {});
      var lexer = new Lexer(code);
      List<Token> tokens = lexer.generateTokens();
      var parser = new Parser(tokens);
      List<dynamic Function(Memory memory)> instructions = parser.parse();
      print('RUNTIME');
      for (dynamic Function(Memory memory) instruction in instructions) {
        instruction(memory);
        List<String> entries = [];
        for (String k in memory.variables.keys) {
          entries.add('${k}: ${memory.variables[k]?.value}');
        }
        print(entries.join(', '));
      }
    });
  } else {
    print('Dart Interpreter');
    var memory = new Memory({}, {});
    String input = '';
    while (true) {
      input = stdin.readLineSync(encoding: utf8) ?? '';
      if (input.length == 0) break;
      var lexer = new Lexer(input);
      List<Token> tokens = lexer.generateTokens();
      printTokens(tokens);
      var parser = new Parser(tokens);
      List<dynamic Function(Memory memory)> instructions = parser.parse();
      for (dynamic Function(Memory memory) instruction in instructions) {
        memory = instruction(memory);
      }
    }
    print(memory.variables);
    String variableName = '';
    while (true) {
      variableName = stdin.readLineSync(encoding: utf8) ?? '';
      if (variableName.length == 0) break;
      print(memory.variables[variableName]?.value);
    }
  }
}