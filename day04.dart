import "utils.dart";

void main() {
  var grid = fileToStrings('./data/day04-sample.dat');

  int res = 0;
  for (int i = 0; i<grid.length; i++) {
    var matches = 'X'.allMatches(grid[i]);
    for (var match in matches) {
      res += findXmas(grid, i, match.start);
    }
  }
  print(res);
  res = 0;
  for (int i = 1; i<grid.length-1; i++) {
    var matches = 'A'.allMatches(grid[i]);
    for (var match in matches) {
      if (match.start > 0 && match.start < grid[i].length - 1) {
        res += countCrossMas(grid, i, match.start);
      }
    }
  }
  print(res);
}

int findXmas(List<String> grid, int line, int col) {
  int res = 0;
  if (grid[line].length > col + 3) {
    res += countXmas(grid[line][col], grid[line][col+1], grid[line][col+2], grid[line][col+3]);
    if(grid.length > line + 3) {
      res += countXmas(grid[line][col], grid[line+1][col+1], grid[line+2][col+2], grid[line+3][col+3]);
    }
    if (line >= 3) {
      res += countXmas(grid[line][col], grid[line-1][col+1], grid[line-2][col+2], grid[line-3][col+3]);
    }
  }
  if (col >= 3) {
    res += countXmas(grid[line][col], grid[line][col-1], grid[line][col-2], grid[line][col-3]);
    if(grid.length > line + 3) {
      res += countXmas(grid[line][col], grid[line+1][col-1], grid[line+2][col-2], grid[line+3][col-3]);
    }
    if (line >= 3) {
      res += countXmas(grid[line][col], grid[line-1][col-1], grid[line-2][col-2], grid[line-3][col-3]);
    }
  }
  if (grid.length > line + 3) {
    res += countXmas(grid[line][col], grid[line+1][col], grid[line+2][col], grid[line+3][col]);
  }
  if (line >= 3) {
    res += countXmas(grid[line][col], grid[line-1][col], grid[line-2][col], grid[line-3][col]);
  }
  return res;
}

int countXmas(String c1, String c2, String c3, String c4) {
  if (c1 == 'X' && c2 == 'M' && c3 == 'A' && c4 == 'S') {
    return 1;
  }
  return 0;
}

int countCrossMas(List<String> grid, int line, int col) {
  if (isMas(grid[line-1][col-1], grid[line+1][col+1]) && isMas(grid[line-1][col+1], grid[line+1][col-1])) {
    return 1;
  }
  return 0;
}

bool isMas(String c1, String c2) {
  return (c1 == 'M' && c2 == 'S') || (c1 == 'S' && c2 == 'M');
}

