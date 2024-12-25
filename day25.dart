import "utils.dart";

void main() {
  var lines = fileToStrings('data/day25.dat');
  List<List<String>> keys = [];
  List<List<String>> locks = [];
  List<String>? curr = null;
  for (var line in lines) {
    if (line.trim() == '') {
      curr = null;
      continue;
    }
    if (curr != null) {
      curr.add(line);
      continue;
    }
    if (line.startsWith('#')) {
      locks.add([]);
      curr = locks.last;
      curr.add(line);
    } else {
      keys.add([]);
      curr = keys.last;
      curr.add(line);
    }
  }

  List<List<int>> formattedKeys = [];
  for (var key in keys) {
    formattedKeys.add(format(key));
  }

  List<List<int>> formattedLocks = [];
  for (var lock in locks) {
    formattedLocks.add(format(lock));
  }

  var size = keys[0].length;

  var res = 0;
  for (var key in formattedKeys) {
    for (var lock in formattedLocks) {
      if (fits(key, lock, size)) {
        res++;
      }
    }
  }

  print(res);
}

bool fits(List<int> key, List<int> lock, int size) {
  for (var i = 0; i<key.length; i++) {
    if (key[i] + lock[i] > size) {
      return false;
    }
  }
  return true;
}

List<int> format(List<String> elem) {
  List<int> res = [];
  for (var col = 0; col<elem[0].length; col++) {
    res.add(0);
    for (var line = 0; line<elem.length; line++) {
      res[col] = res[col] + (elem[line][col] == '#' ? 1 : 0);
    }
  }
  return res;
}