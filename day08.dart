import "utils.dart";

void main() {
  var input = fileToStrings('./data/day08.dat');

  Map<String, List<(int, int)>> antennas = {};

  for (int line = 0; line < input.length; line++) {
    for (int col = 0; col < input[line].length; col++) {
      if (input[line][col] == '.') {
        continue;
      } else {
        antennas.putIfAbsent(input[line][col], () => <(int, int)>[]);
        antennas[input[line][col]]!.add((line, col));
      }
    }
  }

  Set<Record> antinodes = {};

  for (List<(int, int)> list in antennas.values) {
    if (list.length < 2) {
      continue;
    }
    for (var i1 in list) {
      for (var i2 in list) {
        if (i1 == i2) {
          continue;
        }
        var candidate = (i1.$1 + i1.$1 - i2.$1, i1.$2 + i1.$2 - i2.$2);
        if (isValid(candidate, input.length, input[0].length)) {
          antinodes.add(candidate);
        }
        candidate = (i2.$1 + i2.$1 - i1.$1, i2.$2 + i2.$2 - i1.$2);
        if (isValid(candidate, input.length, input[0].length)) {
          antinodes.add(candidate);
        }
      }
    }
  }
  print(antinodes.length);
}

bool isValid((int, int) candidate, int numLines, int numCols) {
  return candidate.$1 >= 0 &&
      candidate.$1 < numLines &&
      candidate.$2 >= 0 &&
      candidate.$2 < numCols;
}
