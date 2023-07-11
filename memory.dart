class Variable {
  String name;
  dynamic value;
  bool isConstant;

  Variable(this.name, this.value, this.isConstant);
}

class Func {
  String name;
  List<Map<String, Type>> arguments = [];
  dynamic Function(List) body;

  Func(this.name, this.arguments, this.body);
}

class Memory {
  Map<String, Variable> variables = {};
  Map<String, Func> funcs = {};

  Memory(this.variables, this.funcs);
}

void addFunc(Memory memory, String name, List<Map<String, Type>> arguments, dynamic Function(List) body) {
  memory.funcs[name] = new Func(name, arguments, body);
}