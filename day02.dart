import "utils.dart";

void main() {
  var safe = 0;
  var safePart2 = 0;
  for (var line in fileToStrings('./data/day02-sample.dat')) {
    var arr = <int>[];
    var toks = line.split(' ');
    for (var tok in toks) {
      arr.add(int.parse(tok));
    }
    if (isSafe(arr)) {
      safe++;
      safePart2++;
    }
    else if (isSafePart2(arr)) {
      safePart2++;
    }
  }
  print(safe);
  print(safePart2);
}

bool isSafe(List<int> arr) {
  var sign = (arr[1] - arr[0]).sign;
  for (var i = 1; i<arr.length; i++) {
    var diff = arr[i] - arr[i-1];
    if (diff.abs() < 1 || diff.abs() > 3 || diff.sign != sign) {
      return false;
    }
  }
  return true;
}

bool isSafePart2(List<int> arr) {
  for (var i = 0; i<arr.length; i++) {
    var newArr = List<int>.from(arr);
    newArr.removeAt(i);
    if (isSafe(newArr)) {
      return true;
    }
  }
  return false;
}