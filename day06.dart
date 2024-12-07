import "utils.dart";

void main() {
  var gridS = fileToStrings('./data/day06.dat');
  int x = -1,
      y = -1;
  for (var i = 0; i < gridS.length; i++) {
    x = gridS[i].indexOf("^");
    if (x != -1) {
      y = i;
      break;
    }
  }
  if (x == -1 || y == -1) {
    throw ("Couldn't find guard");
  }

  var guard = {'l': y, 'c': x, 'dL': -1, 'dC': 0};

  var grid = <List<String>>[];

  Set<int> lines = {};
  Set<int> cols = {};

  for (var i = 0; i<gridS.length; i++) {
    grid.add([]);
    for (var j = 0; j< gridS[i].length; j++) {
      grid[i].add(gridS[i][j]);
      if(gridS[i][j] == '#') {
        lines.add(i);
        if (i < grid.length-1) {
          lines.add(i + 1);
        }
        if (i > 0) {
          lines.add(i - 1);
        }
        cols.add(j);
        if (j < grid[i].length - 1) {
          cols.add(j + 1);
        }
        if (j > 0 ) {
          cols.add(j - 1);
        }
      }
    }
  }

  // part 1
  print(visitGrid(grid, guard));

  // part 2

  var res = 0;
  for (var line in lines) {
    for (var col in cols) {
      if (grid[line][col] == '#') {
        continue;
      }
      grid[line][col] = '#';
      guard = {'l': y, 'c': x, 'dL': -1, 'dC': 0};
      if (visitGrid(grid, guard) == -1) {
        res++;
      }
      grid[line][col] = '.';
    }
  }
  print(res);
}

int visitGrid(List<List<String>> grid, Map<String, int> guard) {
  var visited = <List<String>>[];
  for (var i = 0; i<grid.length; i++) {
    visited.add(List.filled(grid[i].length, '.'));
  }
  visited[guard['l']!][guard['c']!] = 'N';

  var loop = false;
  while(true) {
    var newL = guard['l']! + guard['dL']!;
    var newC = guard['c']! + guard['dC']!;

    if (newL < 0 || newC < 0 || newL >= grid.length || newC >= grid[newL].length) {
      break;
    }
    if(grid[newL][newC] == '#') {
      turn(guard);
      continue;
    } else {
      guard['l'] = newL;
      guard['c'] = newC;
      var guardDir = guardToDir(guard);
      if (visited[newL][newC] == guardDir) {
        loop = true;
        break;
      }
      visited[newL][newC] = guardDir;
    }
  }

  if(loop) {
    return -1;
  } else {
    return visited.fold(0, (previous, newelem) =>
    previous + newelem
        .where((E) => E != '.')
        .length);
  }
}

String guardToDir(Map<String, int> guard) {
  if (guard['dL'] == -1) {
    return 'N';
  }
  if (guard['dL'] == 1) {
    return 'S';
  }
  if (guard['dC'] == -1) {
    return 'W';
  }
  if (guard['dC'] == 1) {
    return 'E';
  }
  throw("invalid direction");
}

void turn(Map<String, int> guard) {
  if (guard['dL']!.abs() + guard['dC']!.abs() != 1) {
    throw "invalid direction";
  }
  if (guard['dL'] == -1) {
    guard['dL'] = 0;
    guard['dC'] = 1;
  } else if (guard['dL'] == 1) {
    guard['dL'] = 0;
    guard['dC'] = -1;
  } else if (guard['dC'] == 1) {
    guard['dL'] = 1;
    guard['dC'] = 0;
    return;
  } else if (guard['dC'] == -1) {
    guard['dL'] = -1;
    guard['dC'] = 0;
  } else {
    throw("invalid direction");
  }
}