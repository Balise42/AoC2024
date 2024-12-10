import "utils.dart";

void main() {
  var input = fileToString('./data/day09-sample.dat');

  var files = <int>[];
  var holes = <int>[];
  for (int i = 0; i< input.length; i++) {
    if (i % 2 == 0) {
      files.add(int.parse(input[i]));
    } else {
      holes.add(int.parse(input[i]));
    }
  }

  var checksum = 0;
  var pos = 0;
  var holePos = 0;
  var endFilePos = files.length-1;
  for (var filePos = 0; filePos < files.length; filePos++) {
    for (var i = 0; i <files[filePos]; i++) {
      checksum += pos * filePos;
      pos++;
    }
    var hole = holePos < holes.length ? holes[holePos] : 0;
    while(hole > 0 && filePos < endFilePos) {
      if (files[endFilePos] > 0) {
        checksum += pos * endFilePos;
        files[endFilePos]--;
        pos++;
        hole--;
      } else {
        endFilePos--;
      }
    }
    holePos++;
  }
  print(checksum);
}