import "utils.dart";
import "package:collection/collection.dart";

void main() {
  var l1 = <int>[];
  var l2 = <int>[];
  for (var line in fileToStrings('./data/day01.dat')) {
    var toks = line.split('   ');
    l1.add(int.parse(toks[0]));
    l2.add(int.parse(toks[1]));
  }
  l1.sort();
  l2.sort();

  var sum = 0;
  var similarity = 0;
  for (var i = 0; i<l1.length; i++) {
    sum += (l1[i] - l2[i]).abs();
    similarity += l2.where((item) => item == l1[i]).length * l1[i];
  }
  print(sum);
  print(similarity);
}