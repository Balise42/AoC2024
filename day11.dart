import "dart:math";
import "utils.dart";

var memo = <(int, int), int>{};

void main() {
  var input = fileToString('./data/day11-sample.dat');
  int resA = 0;
  int resB = 0;
  for (String a in input.split(' ')) {
    var stone = int.parse(a);
    resA += runStone(stone, 25);
    resB += runStone(stone, 75);
  }
  print(resA);
  print(resB);
}


int runStone(int stone, int rounds) {
  if (rounds == 0) {
    return 1;
  }
  if (memo.containsKey((stone, rounds))) {
    return memo[(stone, rounds)]!;
  }
  var numDigits = stone > 0 ? (log(stone) / log(10)).floor() + 1 : 0;
  if (stone== 0) {
    memo[(stone, rounds)] = runStone(1, rounds-1);
  }
  else if (numDigits % 2 == 0) {
    memo[(stone, rounds)] = runStone(stone ~/ pow(10, numDigits ~/ 2), rounds - 1)
        + runStone((stone % pow(10, numDigits ~/ 2)).toInt(), rounds - 1);
  } else {
    memo[(stone, rounds)] = runStone(stone * 2024, rounds - 1);
  }
  return memo[(stone, rounds)]!;
}
