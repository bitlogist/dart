import 'tokens.dart';
import 'memory.dart';

class Parser {
  List<Token> tokens;
  int index = 0;
  bool end = false;
  late Token token;
  List<Memory Function(Memory memory)> instructions = [];

  Parser(this.tokens) {
    this.token = this.tokens[index];
  }

  void moveForward() {
    this.index++;
    if (index < this.tokens.length) {
      this.token = this.tokens[this.index];
    } else {
      this.end = true;
    }
  }

  void declare(bool writable) {
    List<String> names = [];
    while (!this.end && this.token is Reference) {
      names.add(this.token.value);
      this.moveForward();
    }
    if (names.length == 0) throw new Exception('blank declaration');
    if (!(this.token is Assignment)) throw new Exception('expected assignment');
    this.moveForward();
    if (this.token is Reference) {
      // todo: check for punctuation
      this.instructions.add((Memory memory) {
        for (var name in names) {
          memory.variables[name] = new Variable(name, memory.variables[this.token.value], writable);
        }
        return memory;
      });
    } else if (this.token is Integer) {
      this.instructions.add((Memory memory) {
        for (var name in names) {
          memory.variables[name] = new Variable(name, int.parse(this.token.value), writable);
        }
        return memory;
      });
    } else if (this.token is Text) {
      this.instructions.add((Memory memory) {
        for (var name in names) {
          memory.variables[name] = new Variable(name, this.token.value, writable);
        }
        return memory;
      });
    }
  }

  List<Memory Function(Memory memory)> parse() {
    while (!this.end) {
      if (this.token is Declaration) {
        this.moveForward();
        declare(this.token == 'const');

        this.moveForward();
        continue;
      }
      if (this.token is Bracket) {
        // todo: handle grouping

        this.moveForward();
        continue;
      }
      throw new Exception('suspicious token');
    }
    return this.instructions;
  }
}

void printInstructions(List<Memory Function(Memory memory)> instructions) {
  for (Memory Function(Memory memory) instruction in instructions) {
    print(instruction);
  }
}