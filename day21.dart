import "package:collection/collection.dart";

import "utils.dart";

Map<String, (int, int)> numpad = {
  '0': (1, 0),
  'A': (2, 0),
  '1': (0, 1),
  '2': (1, 1),
  '3': (2, 1),
  '4': (0, 2),
  '5': (1, 2),
  '6': (2, 2),
  '7': (0, 3),
  '8': (1, 3),
  '9': (2, 3)
};

Map<String, (int, int)> dirpad = {
  '<': (0, 0),
  'v': (1, 0),
  '>': (2, 0),
  '^': (1, 1),
  'A': (2, 1)
};

void main() {
  var lines = fileToStrings('./data/day21.dat');
  var res1 = 0, res2 = 0;
  for (var line in lines) {
    var pathLength = typeNum(line, 2);
    res1 += pathLength * int.parse(line.substring(0, 3));
    pathLength = typeNum(line, 25);
    res2 += pathLength * int.parse(line.substring(0, 3));
  }
  print(res1);
  print(res2);
}

int typeNum(String s, int iter) {
  String firstRobot = typeDigits(s, 'A');

  var robot = firstRobot;
  var split = robot.split('A');
  split.removeLast();
  robot = '';
  Map<String, int> robotRep = {};
  for (var s in split) {
    robotRep.putIfAbsent(s + 'A', () => 0);
    robotRep[s + 'A'] = robotRep[s+'A']! + 1;
  }

  for (var i = 0; i<iter; i++) {
    Map<String, int> newRep = {};
    for (var entry in robotRep.entries) {
      var next = typeRobot(entry.key, 'A');
      var nextSplit = next.split('A');
      nextSplit.removeLast();
      for (var ns in nextSplit) {
        newRep.putIfAbsent(ns + 'A', () => 0);
        newRep[ns + 'A'] = newRep[ns + 'A']! + entry.value;
      }
    }
    robotRep = newRep;
  }

  var res = 0;
  for (var rep in robotRep.entries) {
    res += rep.key.length * rep.value;
  }
  return res;
}

Map<(String, int), String> memo = {};

String splitAndType(String robot, int iter) {
  if (memo.containsKey((robot, iter))) {
    return memo[(robot, iter)]!;
  }

  if (iter == 0) {
    return robot;
  }
  var split = robot.split('A');
  split.removeLast();
  var res = '';
  for (var s in split) {
    var next = typeRobot(s + 'A', 'A');
    next = splitAndType(next, iter-1);
    res += next;
  }
  if(iter < 20) {
    memo[(robot, iter)] = res;
  }
  return res;
}

String typeDigits(String s, String prev) {
  if(s == '') {
    return '';
  } else {
    var goto = s[0];
    var sofar = getNumpadPaths(prev, goto);
    var next = s.substring(1);
    return sofar + typeDigits(next, goto);
  }
}


String typeRobot(String firstRobot, String prev) {
  if(firstRobot == '') {
    return '';
  } else {
    var goto = firstRobot[0];
    var sofar = getDirpadPaths(prev, goto);
    var next = firstRobot.substring(1);
    return sofar + typeRobot(next, goto);
  }
}

String getNumpadPaths(String s, String e) {
  if (s == e) {
    return 'A';
  }

  var sPos = numpad[s]!;
  var ePos = numpad[e]!;

  if (sPos.$1 == ePos.$1) {
    var str = goDown(sPos, ePos);
    str += goUp(sPos, ePos);
    return str + 'A';
  }

  if (sPos.$2 == ePos.$2) {
    var str = goLeft(sPos, ePos);
    str += goRight(sPos, ePos);
    return str + 'A';
  }

  if(!((s == '0' || s == 'A') && (e == '1' || e == '4' || e == '7'))
  && (!((s == '4' || s == '1' || s == '7') && (e == '0' || e == 'A')))) {
    var str = goLeft(sPos, ePos);
    str += goDown(sPos, ePos);
    str += goUp(sPos, ePos);
    str += goRight(sPos, ePos);
    return(str + 'A');
  }
  var str = goRight(sPos, ePos);
  str += goUp(sPos, ePos);
  str += goLeft(sPos, ePos);
  str += goDown(sPos, ePos);
  return str + 'A';
}

String getDirpadPaths(String s, String e) {
  if(s == e) {
    return 'A';
  }

  var sPos = dirpad[s]!;
  var ePos = dirpad[e]!;

  if (sPos.$1 == ePos.$1) {
    var str = goDown(sPos, ePos);
    str += goUp(sPos, ePos);
    str + 'A';
  }

  if (sPos.$2 == ePos.$2) {
    var str = goLeft(sPos, ePos);
    str += goRight(sPos, ePos);
    return str + 'A';
  }

  if(!(e == '<' && (s == '^' || s == 'A')) &&
      !(s == '<' && (e == '^' || e == 'A'))) {
    var str = goLeft(sPos, ePos);
    str += goDown(sPos, ePos);
    str += goUp(sPos, ePos);
    str += goRight(sPos, ePos);
    return(str + 'A');
  }

  var str = goRight(sPos, ePos);
  str += goDown(sPos, ePos);
  str += goLeft(sPos, ePos);
  str += goUp(sPos, ePos);
  return(str + 'A');

}

String goRight((int, int) sPos, (int, int) ePos) {
  var res = '';
  for (var i = sPos.$1; i<ePos.$1 ;i++) {
    res += '>';
  }
  return res;
}

String goLeft((int, int) sPos, (int, int) ePos) {
  var res = '';
  for (var i = sPos.$1; i>ePos.$1 ;i--) {
    res += '<';
  }
  return res;
}

String goUp((int, int) sPos, (int, int) ePos) {
  var res = '';
  for(var i = sPos.$2; i< ePos.$2; i++) {
    res += '^';
  }
  return res;
}

String goDown((int, int) sPos, (int, int) ePos) {
  var res = '';
  for(var i = sPos.$2; i > ePos.$2; i--) {
    res += 'v';
  }
  return res;
}