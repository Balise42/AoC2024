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
  //lines = ['894A'];
  /*Map<(String, String), int> typeDigit = {};
  for (var i = 0; i <= 9; i++) {
    var istr = i.toString();
    for (var j = 0; j <= 9; j++) {
      var jstr = j.toString();
      typeDigit[(istr, jstr)] = typeNum(istr, jstr);
    }
    typeDigit[(istr, 'A')] = typeNum(istr, 'A');
    typeDigit[('A', istr)] = typeNum('A', istr);
  }*/
  //typeDigit['A'] = typeNum('A');

  var res = 0;
  for (var line in lines) {
    var pathLength = typeNum(line);
    res += pathLength * int.parse(line.substring(0, 3));
  }
  print(res);
}

int typeNum(String s) {
  List<String> firstRobots = typeDigits(s, 'A');

  var robots = firstRobots;
  for (var i = 0; i < 2; i++) {
    List<String> nextRobots = [];
    for (var robot in robots) {
      nextRobots.addAll(typeRobot(robot, 'A'));
    }
    robots = nextRobots;
  }

  var len = 1000;
  for (String robot in robots) {
    if (robot.length < len) {
      len = robot.length;
    }
  }
  return len;
}

List<String> typeDigits(String s, String prev) {
  if(s == '') {
    return [''];
  } else {
    var goto = s[0];
    var sofar = getNumpadPaths(prev, goto);
    var next = s.substring(1);
    List<String> res = [];
    for (var curr in sofar) {
      res.addAll(typeDigits(next, goto).map((E) => curr + E));
    }
    return res;
  }
}

List<String> typeRobot(String firstRobot, String prev) {
  if(firstRobot == '') {
    return [''];
  } else {
    var goto = firstRobot[0];
    var sofar = getDirpadPaths(prev, goto);
    var next = firstRobot.substring(1);
    List<String> res = [];
    for (var curr in sofar) {
      res.addAll(typeRobot(next, goto).map((E) => curr + E));
    }
    return res;
  }
}

 /*
  for (var line in lines) {

  }
  // 252324 too high
  // 239800 too low

  print(res);
}

String typeNum(String line) {
  var typed = getNumpadPaths('A', line[0]);
  for (var i = 0; i < line.length-1; i++) {
    List<String> tmp = [];
    for (var str in getNumpadPaths(line[i], line[i + 1])) {
      tmp.addAll(List<String>.from(typed.map((E) => E + str)));
    }
    typed = tmp;
  }
  print(typed);
  return '';
  //List<String> dirs = typed.fold([], (List<String> init, String E) => List<String>.from(init.add(typeDir(E))));
}

List<String> typeDir(String line) {
  return [];
  /*var typed = getDirpadPaths('A', line[0]) + 'A';
  for (var i = 0; i<line.length-1; i++) {
    typed += getDirpadPaths(line[i], line[i+1]);
    typed += 'A';
  }
  return typed;*/
}*/

List<String> getNumpadPaths(String s, String e) {
  if (s == e) {
    return ['A'];
  }

  var sPos = numpad[s]!;
  var ePos = numpad[e]!;

  if (sPos.$1 == ePos.$1) {
    var str = goDown(sPos, ePos);
    str += goUp(sPos, ePos);
    return [str + 'A'];
  }

  if (sPos.$2 == ePos.$2) {
    var str = goLeft(sPos, ePos);
    str += goRight(sPos, ePos);
    return [str + 'A'];
  }

  List<String> res = [];
  var str = goRight(sPos, ePos);
  str += goUp(sPos, ePos);
  str += goLeft(sPos, ePos);
  str += goDown(sPos, ePos);
  res.add(str + 'A');
  if(!((s == '0' || s == 'A') && (e == '1' || e == '4' || e == '7'))
  && (!((s == '4' || s == '1' || s == '7') && (e == '0' || e == 'A')))) {
    str = goDown(sPos, ePos);
    str += goLeft(sPos, ePos);
    str += goUp(sPos, ePos);
    str += goRight(sPos, ePos);
    res.add(str + 'A');
  }
  return res;
}

List<String> getDirpadPaths(String s, String e) {
  if(s == e) {
    return ['A'];
  }

  var sPos = dirpad[s]!;
  var ePos = dirpad[e]!;

  if (sPos.$1 == ePos.$1) {
    var str = goDown(sPos, ePos);
    str += goUp(sPos, ePos);
    return [str + 'A'];
  }

  if (sPos.$2 == ePos.$2) {
    var str = goLeft(sPos, ePos);
    str += goRight(sPos, ePos);
    return [str + 'A'];
  }

  List<String> res = [];
  var str = goRight(sPos, ePos);
  str += goDown(sPos, ePos);
  str += goLeft(sPos, ePos);
  str += goUp(sPos, ePos);
  res.add(str + 'A');
  if(!(e == '<' && (s == '^' || s == 'A')) &&
      !(s == '<' && (e == '^' || e == 'A'))) {
    str = goUp(sPos, ePos);
    str += goLeft(sPos, ePos);
    str += goDown(sPos, ePos);
    str += goRight(sPos, ePos);
    res.add(str + 'A');
  }

  return res;
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