class Variable {
  String name;
  dynamic value;
  bool constant;

  Variable(this.name, this.value, this.constant);
}

class Func {
  String name;
  List<Map<String, Type>> arguments = [];
  Function body;

  Func(this.name, this.arguments, this.body);
}

class Memory {
  Map<String, Variable> variables = {};
  Map<String, Func> funcs = {};

  Memory(this.variables, this.funcs);
}