import "dart:math";

import "package:collection/collection.dart";

import "utils.dart";

void main() {
  var lines = fileToStrings('./data/day17.dat');
  var A = int.parse(lines[0].split(': ')[1]!);
  var B = int.parse(lines[1].split(': ')[1]!);
  var C = int.parse(lines[2].split(': ')[1]!);

  var prog = List<int>.from(lines[4].split(': ')[1]!.split(',').map((E) => int.parse(E)));

  List<int> res = runProg(prog, A, B, C);
  print(res.join(','));

  var progS = prog.join('');

  var candidates = [];
  for (var i = 2000; i<10000;i++) {
    var res = runProg(prog, i, B, C);
    if (res.join('').endsWith(progS.substring(progS.length - res.length))) {
      candidates.add(i);
    }
  }

  while(candidates.isNotEmpty) {
    var prev = candidates.removeAt(0);
    for (var i = 0; i<8; i++) {
      var next = prev * 8 + i;
      var res = runProg(prog, next, B, C);
      if (res.join('').endsWith(progS.substring(progS.length - res.length))) {
        candidates.add(next);
        if(res.length == progS.length) {
          print(next);
          return;
        }
      }
    }
  }

 /* while(candidates.isNotEmpty) {
    var prev = candidates.removeAt(0);
    for (var i = 1; i<257; i++) {
      var candidate = prev * i;
      var res = runProg(prog, candidate, B, C);
      if (res.join('') == progS) {
        print(candidate);
        break;
      } else if (progS.length -1 >= res.length) {
       if (res.join('').endsWith(progS.substring(progS.length - res.length-1))) {
         candidates.add(candidate);
          var a = candidate + 1;
          res = runProg(prog, a, B, C);
          while (res.join('').endsWith(progS.substring(progS.length -  res.length-1))) {
            if (res.join('').endsWith(progS.substring(progS.length - res.length))) {
              candidates.add(a);
            }
            a++;
            res = runProg(prog, a, B, C);
          }
        }
      }
    }
  }*/
}

List<int> runProg(List<int> prog, int A, int B, int C) {
  var ptr = 0;
  List<int> res = [];
  while(ptr < prog.length-1) {
    var out = -1;
    (A, B, C, ptr, out) = runInstr(prog, ptr, A, B, C);
    if (out != -1) {
      res.add(out);
    }
  }
  return res;
}

(int, int, int, int, int) runInstr(List<int> prog, int ptr, int A, int B, int C) {
  var out = -1;
  var op = prog[ptr+1];
  var nextPtr = ptr+2;
  switch(prog[ptr]) {
    case 0:
      A = A ~/ pow(2, combo(op, A, B, C));
      break;
    case 1:
      B = xor(B, op);
      break;
    case 2:
      B = combo(op, A, B, C) % 8;
      break;
    case 3:
      if (A != 0){
        nextPtr = op;
      }
      break;
    case 4:
      B = xor(B, C);
      break;
    case 5:
      out = B % 8;
      break;
    case 6:
      B = A ~/ pow(2, combo(op, A, B, C));
      break;
    case 7:
      C = A ~/ pow(2, combo(op, A, B, C));
      break;
  }
  return (A, B, C, nextPtr, out);
}

int combo(int op, int A, int B, int C) {
  if (op >= 0 && op < 4) {
    return op;
  } else if (op == 4) {
    return A;
  } else if (op == 5) {
    return B;
  } else if (op == 6) {
    return C;
  }
  throw ("wrong combo");
}

int xor(int a, int b) {
  var stra = a.toRadixString(2);
  var strb = b.toRadixString(2);
  var m = max(stra.length, strb.length);
  stra = stra.padLeft(m, '0');
  strb = strb.padLeft(m, '0');

  var res = '';
  for (var i = 0; i<m; i++) {
    res = res + ((stra[i] == strb[i]) ? '0' : '1');
  }
  return int.parse(res, radix: 2);
}