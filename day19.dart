import "utils.dart";

void main() {
  var lines = fileToStrings('./data/day19.dat');

  var towels = lines[0].split(', ');
  Map<String, List<String>> towelMap = {};
  for (var towel in towels) {
    towelMap.putIfAbsent(towel[towel.length-1], () => <String>[]);
    towelMap[towel[towel.length-1]]!.add(towel);
  }

  var res = 0;
  var designs = 0;
  for (var i = 2; i<lines.length; i++) {
    if (possibleDesign(lines[i], towelMap)) {
      res++;
      designs += getNumDesigns(lines[i], towelMap);
    }
  }
  print(res);
  print(designs);
}

bool possibleDesign(String s, Map<String, List<String>> towelMap) {
  if(s.length == 0) {
    return true;
  }
  if(!towelMap.containsKey(s[s.length-1])) {
    return false;
  }

  for (var towel in towelMap[s[s.length-1]]!) {
    var possible = false;
    if(s.endsWith(towel)) {
      // first attempt was recursing on the start of the string, and there's
      // one in there that makes things LONG™ (probably also the reason why
      // the regex approach is LONG™ - at least it grumbles on the same one),
      // but apparently starting from the end does work. lol.
      possible = possible || possibleDesign(s.replaceRange(s.length-towel.length, s.length, ''), towelMap);
      if (possible) {
        return true;
      }
    }
  }
  return false;
}


// once again, memo makes thing go from "uruuuughhh" to "instant". magical.
Map<String, int> memo = {};

int getNumDesigns(String s, Map<String, List<String>> towelMap) {
  if (memo.containsKey(s)) {
    return memo[s]!;
  }
  if(s.length == 0) {
    return 1;
  }
  if(!towelMap.containsKey(s[s.length-1])) {
    return 0;
  }

  var designs = 0;
  for (var towel in towelMap[s[s.length-1]]!) {
    if(s.endsWith(towel)) {
      designs = designs + getNumDesigns(s.replaceRange(s.length-towel.length, s.length, ''), towelMap);
    }
  }
  memo[s] = designs;
  return designs;
}


