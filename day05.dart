import "utils.dart";

void main() {
  List<String> lines = fileToStrings('./data/day05-sample.dat');
  Set<Record> rules = {};

  var part1 = 0;
  var part2 = 0;

  for (var line in lines) {
    if(line.contains('|')) {
      var toks = line.split('|');
      rules.add((int.parse(toks[0]), int.parse(toks[1])));
    }
    else if(line.contains(',')) {
      List<int> pages = List.from(line.split(',').map((e) => int.parse(e)));
      int valid = addValidUpdate(pages, rules, false);
      part1 += valid;
      if (valid == 0) {
        part2 += addValidUpdate(reorder(pages, rules), rules, true);
      }
    }
  }
  print(part1);
  print(part2);
}

int addValidUpdate(List<int> pages, Set<Record> rules, bool part2) {
  bool valid = true;
  for (var i = 0; i < pages.length - 1; i++) {
    for (var j = i + 1; j < pages.length; j++) {
      if (rules.contains((pages[j], pages[i]))) {
        if (part2) {
          throw('Update should be valid');
        }
        valid = false;
      }
    }
  }
  return valid ? pages[pages.length ~/ 2] : 0;
}

List<int> reorder(List<int> pages, Set<Record> rules) {
  for (var i = 0; i < pages.length - 1; i++) {
    for (var j = i + 1; j < pages.length; j++) {
      if (rules.contains((pages[j], pages[i]))) {
        var tmp = pages[i];
        pages[i] = pages[j];
        pages[j] = tmp;
      }
    }
  }
  return pages;
}
