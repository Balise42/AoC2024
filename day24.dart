import "dart:math";

import "utils.dart";

class Gate {
  String val;
  String i1;
  String i2;
  String op;
  bool? out;

  Gate(this.val, this.i1, this.i2, this.op);
  
  bool canCompute(State state) {
    return state.knownValues.containsKey(this.i1) && state.knownValues.containsKey(this.i2);
  }

  void compute(State state) {
    if (this.op == 'OR') {
      this.out = state.knownValues[this.i1]! || state.knownValues[this.i2]!;
    } else if (this.op == 'AND') {
      this.out = state.knownValues[this.i1]! && state.knownValues[this.i2]!;
    } else if (this.op == 'XOR') {
      this.out = state.knownValues[this.i1]! ^ state.knownValues[this.i2]!;
    }
    if (state.knownValues.containsKey(this.val) && state.knownValues[val] != this.out) {
      throw "inconsistent state";
    }
    state.knownValues[this.val] = this.out!;
  }

  @override
  String toString() {
    return 'Gate{val: $val}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Gate &&
          runtimeType == other.runtimeType &&
          val == other.val &&
          i1 == other.i1 &&
          i2 == other.i2 &&
          op == other.op;

  @override
  int get hashCode => val.hashCode ^ i1.hashCode ^ i2.hashCode ^ op.hashCode;
}


class State {
  Map<String, bool> knownValues = {};
  Map<String, List<Gate>> unknown = {};
  Map<String, Gate> gates = {};

  void cascade(var val) {
    if (this.unknown.containsKey(val)) {
      List<Gate> toRemove = [];
      for (var candidate in this.unknown[val]!) {
        if (candidate.canCompute(this)) {
          toRemove.add(candidate);
          candidate.compute(this);
        }
      }
      for (var remove in toRemove) {
        cascade(remove.val);
        this.unknown[remove.i1]?.removeWhere((test) => test.val == remove.val);
        this.unknown[remove.i2]?.removeWhere((test) => test.val == remove.val);
      }
    }
  }

  void addGate(String val, String i1, String i2, String op) {
    var gate = Gate(val, i1, i2, op);
    this.gates[val] = gate;
    if (gate.canCompute(this)) {
      gate.compute(this);
    }
    if (gate.out != null) {
      this.cascade(gate.val);
    } else {
      addUnknown(gate);
    }
  }

  void addUnknown(Gate gate) {
    this.unknown.putIfAbsent(gate.i1, () => []);
    this.unknown.putIfAbsent(gate.i2, () => []);
    this.unknown[gate.i1]!.add(gate);
    this.unknown[gate.i2]!.add(gate);
  }

  void addKnownValue(String val, bool b) {
    this.knownValues[val] = b;
    cascade(val);
  }
  
  void reset() {
    this.unknown = {};
    for (var gate in this.gates.values) {
      gate.out = null;
      this.addUnknown(gate);
    }
    this.knownValues = {};
  }
}

void main() {
  List<String> lines = fileToStrings("./data/day24.dat");
  var state = State();
  var readGates = false;
  for (String line in lines) {
    if (line.trim() == '') {
      readGates = true;
      continue;
    }
    if (!readGates) {
      var toks = line.split(": ");
      state.addKnownValue(toks[0], toks[1] == '1' ? true : false);
      continue;
    } else {
      var toks = line.split(" ");
      var i1 = toks[0];
      var i2 = toks[2];
      var op = toks[1];
      var val = toks[4];
      state.addGate(val, i1, i2, op);
    }
  }

  var values = Map.from(state.knownValues);
  values.removeWhere((key, value) => !key.startsWith('z'));
  var maxPos = values.length;
  var res = 0;
  for (var i = 0; i < maxPos; i++) {
    var varName = "z" + i.toString().padLeft(2, '0');
    res += values[varName]! ? pow(2, i).toInt() : 0;
  }
  print(res);
}