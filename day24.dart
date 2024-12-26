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
    state.knownValues[this.val] = this.out!;
  }

  @override
  String toString() {
    return 'Gate{$i1 $op $i2 => $val}';
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
  Map<String, List<Gate>> children = {};
  Set<String> xs = {};
  Set<String> ys = {};

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
    this.children.putIfAbsent(i1, () => <Gate>[]);
    this.children.putIfAbsent(i2, () => <Gate>[]);
    this.children[i1]!.add(gate);
    this.children[i2]!.add(gate);
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

  int getNum(String prefix) {
    int res = 0;
    for (var entry in this.knownValues.entries) {
      if (entry.key.startsWith(prefix)) {
        var exp = int.parse(entry.key.substring(1));
        res += entry.value ? pow(2, exp).toInt() : 0;
      }
    }
    return res;
  }
}

void main() {
  List<String> lines = fileToStrings("./data/day24-fixed.dat");
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
      if (toks[0].startsWith('x')) {
        state.xs.add(toks[0]);
      }if (toks[0].startsWith('x')) {
        state.ys.add(toks[0]);
      }
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

  print(state.getNum('z'));

  /*z = x xor y xor prevcarry;
  carry = (x and y) or (prevcarry and (x xor y));

  P = x xor y
  Q = x and y
  Z = P xor prevcarry
  carry = Q or R
  R = prevcarry AND P*/

  Map<(String, String, String), Gate> gateByInput = {};
  for (var gate in state.gates.values) {
    gateByInput[(gate.i1, gate.i2, gate.op)] = gate;
    gateByInput[(gate.i2, gate.i1, gate.op)] = gate;
  }

  var prevCarry = 'rjr';
  for (var i = 1; i<45; i++) {
    print(i);
    var x = 'x' + i.toString().padLeft(2, '0');
    var y = 'y' + i.toString().padLeft(2, '0');
    var z = 'z' + i.toString().padLeft(2, '0');
    var P = gateByInput[(x, y, 'XOR')];
    if (P == null) {
      print("no P");
      break;
    }
    print("P: $P");
    var Q = gateByInput[(x, y, 'AND')];
    if (Q == null) {
      print("no Q");
      break;
    }
    print("Q: $Q");
    var R = gateByInput[(P.val, prevCarry, 'AND')];
    if (R == null) {
      print("no R");
      break;
    }
    print("R: $R");
    var prevCarryGate = gateByInput[(R.val, Q.val, 'OR')];
    if (prevCarryGate == null) {
      print("no prevCarryGate");
      break;
    }
    print("prevCarry: $prevCarryGate");
    var Z = gateByInput[(P.val, prevCarry, 'XOR')];
    if (Z == null) {
      print("no Z");
      break;
    }
    if (Z.val != z) {
      print("wrong Z $Z");
      break;
    }
    print("Z: $Z");
    if (prevCarryGate == null) {
      break;
    }
    prevCarry = prevCarryGate.val;
  }

  var res = ['hmt', 'z18', 'z27', 'bfq', 'z31', 'hkh', 'bng', 'fjp'];
  res.sort();
  print(res.join(','));
}