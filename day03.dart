import "utils.dart";

void main() {
  var input = fileToString('./data/day03.dat');
  var res = computeMemory(input);
  print(res);

  List<RegExpMatch> dos = RegExp(r'do\(\)', multiLine: true).allMatches(input).toList();
  List<RegExpMatch> donts = RegExp(r"don't\(\)", multiLine: true).allMatches(input).toList();

  var cursor = 0;
  var nextCursor = 0;
  var on = true;

  res = 0;
  while(true) {
    if(on && donts.length == 0) {
      res += computeMemory(input.substring(cursor));
      break;
    }
    if (!on && dos.length == 0) {
      break;
    }
    if(on) {
      nextCursor = donts[0].start;
      res += computeMemory(input.substring(cursor, nextCursor));
      donts.removeAt(0);
      while(dos.length > 0 && dos[0].start < nextCursor) {
        dos.removeAt(0);
      }
      cursor = nextCursor;
    } else {
      nextCursor = dos[0].start;
      dos.removeAt(0);
      while(donts.length > 0 && donts[0].start < nextCursor) {
        donts.removeAt(0);
      }
      cursor = nextCursor;
    }
    on = !on;
  }
  print(res);
}

int computeMemory(String input) {
  var res = 0;
  var r = RegExp(r'mul\((?<op1>\d{1,3}),(?<op2>\d{1,3})\)', multiLine: true);

  for (var match in r.allMatches(input)) {
    res += int.parse(match.namedGroup('op1') ?? '0') *
        int.parse(match.namedGroup('op2') ?? '0');
  }
  return res;
}