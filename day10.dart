import "utils.dart";

var grid = <List<int>>[];
var memo = <(int, int), Set<(int, int)>>{};
var memo2 = <(int, int), int>{};

void main() {
  var lines = fileToStrings('./data/day10-sample.dat');
  for(var line in lines) {
    grid.add(List.from(line.codeUnits.map((E) => int.parse(String.fromCharCode(E)))));
  }

  var res = 0;
  var res2 = 0;
  for (var line = 0; line < grid.length; line++) {
    for (var head in '0'.allMatches(lines[line])) {
      res += score(line, head.start).length;
      res2 += numTrails(line, head.start);
    }
  }
  print(res);
  print(res2);
}


Set<(int, int)> score(int line, int col) {
  if (memo.keys.contains((line, col))) {
    return memo[(line, col)]!;
  }
  if(grid[line][col] == 9) {
    return {(line, col)};
  }

  Set<(int,int)> res = {};
  int goal = grid[line][col] + 1;
  if(line > 0 && grid[line-1][col] == goal){
    res.addAll(score(line-1, col));
  }
  if (line < grid.length-1 && grid[line+1][col] == goal) {
    res.addAll(score(line+1, col));
  }
  if (col > 0 && grid[line][col-1] == goal) {
    res.addAll(score(line, col-1));
  }
  if (col < grid[line].length-1 && grid[line][col+1] == goal) {
    res.addAll(score(line, col+1));
  }

  memo[(line, col)] = res;
  return res;
}

int numTrails(int line, int col) {
  if (memo2.keys.contains((line, col))) {
    return memo2[(line, col)]!;
  }
  if(grid[line][col] == 9) {
    return 1;
  }

  int res = 0;
  int goal = grid[line][col] + 1;
  if(line > 0 && grid[line-1][col] == goal){
    res += numTrails(line-1, col);
  }
  if (line < grid.length-1 && grid[line+1][col] == goal) {
    res += numTrails(line+1, col);
  }
  if (col > 0 && grid[line][col-1] == goal) {
    res += numTrails(line, col-1);
  }
  if (col < grid[line].length-1 && grid[line][col+1] == goal) {
    res += numTrails(line, col+1);
  }

  memo2[(line, col)] = res;
  return res;
}