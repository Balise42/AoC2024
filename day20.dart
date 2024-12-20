import "utils.dart";

void main() {
  var lines = fileToStrings('./data/day20.dat');

  Map<(int, int), String> grid = {};
  int startX = -1, startY = -1, endX = -1, endY = -1;
  for (var y = 0; y<lines.length; y++) {
    for (var x = 0; x<lines[0].length; x++) {
      grid[(x, y)] = lines[y][x];
      if (lines[y][x] == 'S') {
        startX = x;
        startY = y;
      }
      if (lines[y][x] == 'E') {
        endX = x;
        endY = y;
      }
    }
  }

  Map<(int, int), int> path = {};
  var prev = 0;
  var pos = (startX, startY);
  path[pos] = 0;
  while(pos != (endX, endY)) {
    pos = findNext(grid, path, pos);
    path[pos] = prev+1;
    prev++;
  }

  int noCheatLength = path[(endX, endY)]!;

  var large = 0;

  for (var kv in grid.entries) {
    if(kv.value == '.') {
      continue;
    }
    var pos = kv.key;
    var neighs = [];
    for(var newPos in [(pos.$1 - 1, pos.$2), (pos.$1+1, pos.$2), (pos.$1, pos.$2 - 1), (pos.$1, pos.$2 + 1)]) {
      if (path.containsKey(newPos)) {
        neighs.add(newPos);
      }
    }
    if (neighs.length < 2) {
      continue;
    }
    var min = noCheatLength + 1;
    var max = -1;
    for(var neigh in neighs) {
      if (path[neigh]! < min) {
        min = path[neigh]!;
      }
      if (path[neigh]! > max) {
        max = path[neigh]!;
      }
    }
    var spare = max-min-2;

    if (spare >= 100) {
      large++;
    }
  }

  print(large);

  var pathList = List<(int, int)>.from(path.keys);
  pathList.sort((a, b) => path[a]!.compareTo(path[b]!));

  var longCheats = 0;
  for (var pos1 = 0; pos1 < pathList.length-2; pos1++) {
    for (var pos2 = pos1+2; pos2 < pathList.length; pos2++) {
      var x1 = pathList[pos1].$1;
      var x2 = pathList[pos2].$1;
      var y1 = pathList[pos1].$2;
      var y2 = pathList[pos2].$2;
      if ((x2-x1).abs() + (y2-y1).abs() <= 20) {
        var spare = path[(x2, y2)]! - path[(x1, y1)]! - ((x2-x1).abs() + (y2-y1).abs());
        if (spare >= 100) {
          longCheats++;
        }
      }
    }
  }
  print(longCheats);
}

(int, int) findNext(Map<(int, int), String> grid, Map<(int, int), int> path, (int, int) pos) {
  for(var newPos in [(pos.$1 - 1, pos.$2), (pos.$1+1, pos.$2), (pos.$1, pos.$2 - 1), (pos.$1, pos.$2 + 1)]) {
    if (!path.containsKey(newPos) && grid.containsKey(newPos) && grid[newPos]! != '#') {
      return newPos;
    }
  }
  throw ("can't find next");
}

