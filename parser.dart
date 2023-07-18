import 'tokens.dart';
import 'memory.dart';

class Parser {
  List<Token> tokens;
  int index = 0;
  bool end = false;
  late Token token;
  List<void Function(Memory memory)> instructions = [];

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

  void moveBackward() {
    this.index--;
    if (index < 0) {
      throw new Exception('negative token index');
    } else {
      this.token = this.tokens[index];
    }
  }

  void declare(bool isConstant) {
    List<String> names = [];
    while (!this.end && this.token is Reference) {
      names.add(this.token.value);
      this.moveForward();
    }
    if (names.length == 0) throw new Exception('blank declaration');
    if (!(this.token is Assignment)) throw new Exception('expected assignment');
    this.moveForward();
    String v = this.token.value; // necessary to create unique references
    if (this.token is Reference) {
      // todo: check for punctuation
      this.instructions.add((Memory memory) {
        for (String name in names) {
          memory.variables[name] = new Variable(name, memory.variables[v]?.value, isConstant);
        }
      });
    } else if (this.token is Integer) {
      this.instructions.add((Memory memory) {
        for (String name in names) {
          memory.variables[name] = new Variable(name, int.parse(v), isConstant);
        }
      });
    } else if (this.token is Text) {
      this.instructions.add((Memory memory) {
        for (String name in names) {
          memory.variables[name] = new Variable(name, v, isConstant);
        }
      });
    }
  }

  void mutate() {
    List<String> names = [];
    while (!this.end && this.token is Reference) {
      names.add(this.token.value);
      this.moveForward();
    }
    if (names.length == 0) throw new Exception('blank declaration');
    if (this.token is Operator) {
      // compute right side
      return;
    }
    if (!(this.token is Assignment)) throw new Exception('expected assignment or operation');
    this.moveForward();
    String v = this.token.value; // necessary to create unique references
    if (this.token is Reference) {
      // todo: check for function punctuation
      this.instructions.add((Memory memory) {
        for (String name in names) {
          if (memory.variables[name]?.isConstant ?? false) throw new Exception('assignment to constant');
          memory.variables[name]?.value = memory.variables[v]?.value;
        }
      });
    } else if (this.token is Integer) {
      this.instructions.add((Memory memory) {
        for (String name in names) {
          if (memory.variables[name]?.isConstant ?? false) throw new Exception('assignment to constant');
          memory.variables[name]?.value = int.parse(v);
        }
      });
    } else if (this.token is Text) {
      this.instructions.add((Memory memory) {
        for (String name in names) {
          if (memory.variables[name]?.isConstant ?? false) throw new Exception('assignment to constant');
          memory.variables[name]?.value = v;
        }
      });
    }
  }

  List<List<Token>> getGroup(String closingBracket) {
    List<List<Token>> group = [];
    List<Token> temp = [];
    while (!this.end && this.token.value != closingBracket) {
      if (this.token.value == ',') {
        if (temp.isEmpty) throw new Exception('invalid arguments');
        group.add(temp);
        temp.clear();
      } else temp.add(this.token);
      this.moveForward();
    }
    if (temp.isNotEmpty) group.add(temp);
    return group;
  }

  dynamic simplify(List<Token> tokens, Memory memory) {
    // todo: functions and operations
    if (tokens.length == 1) {
      Token token = tokens[0];
      if (token is Reference) {
        // todo: recursive function returns
        Variable? variable = memory.variables[token.value];
        if (variable == null) throw new Exception('${token.value} is an undefined variable');
        return variable.value;
      }
      if (token is Integer) return int.parse(token.value);
      if (token is Text) return token.value;
    }
  }

  List<void Function(Memory memory)> parse() {
    while (!this.end) {
      if (this.token is Declaration) {
        bool isConstant = this.token.value == 'const';
        this.moveForward();
        declare(isConstant);

        this.moveForward();
        continue;
      }
      if (this.token is Reference) {
        String name = this.token.value;
        this.moveForward();
        if (this.token is Bracket) {
          if (this.token.value == '(') {
            this.moveForward();
            List<List<Token>> group = this.getGroup(')');
            this.instructions.add((Memory memory) {
              Func func = memory.funcs[name] ?? new Func('', [], (x) {});
              if (func.name.isEmpty) throw new Exception('calling of nonexistent function');
              List args = [];
              for (int i = 0; i < group.length; i++) {
                dynamic item = this.simplify(group[i], memory);
                dynamic argType = func.arguments[i].values.first;
                dynamic runtimeType = item.runtimeType;
                if (runtimeType != argType) throw new Exception('expected ${argType} for positional argument ${i + 1}');
                args.add(item);
              }
              if (args.length != func.arguments.length) throw new Exception('expected ${func.arguments.length} arguments but received ${args.length}');
              dynamic returnValue = func.body(args);
            });
          }
        } else {
          this.moveBackward();
          this.mutate();
        }

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

void printInstructions(List<void Function(Memory memory)> instructions) {
  for (void Function(Memory memory) instruction in instructions) {
    print(instruction);
  }
}