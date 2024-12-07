import "dart:math";

import "utils.dart";

void main() {
  var input = fileToStrings('./data/day07.dat');

  var res1 = 0, res2 = 0;

  for (String line in input) {
    var toks = line.split(': ');
    var target = int.parse(toks[0]);
    List<int> numbers = List<int>.from(toks[1].split(' ').map((A) => int.parse(A)));

    var ways1 = countWays(target, numbers, false);
    if (ways1 > 0) {
       res1 += target;
    }

    numbers = List<int>.from(toks[1].split(' ').map((A) => int.parse(A)));
    var ways2 = countWays(target, numbers, true);
    if (ways2 > 0) {
      res2 += target;
    }
  }
  print(res1);
  print(res2);
}

int countWays(int target, List<int> numbers, bool part2) {
  if (target < 0) {
    return 0;
  }
  if (numbers.length == 1) {
    return target == numbers[0] ? 1 : 0;
  }

  var res = 0;
  var last = numbers.removeLast();
  if (target % last == 0) {
    res += countWays(target ~/ last, List.from(numbers), part2);
  }
  res += countWays(target - last, List.from(numbers), part2);

  if(part2 && target.toString().endsWith(last.toString())) {
    res += countWays(target ~/ pow(10, last.toString().length), List.from(numbers), true);
  }

  return res;
}