import 'utils.dart';

var CRATE = 'O'.codeUnits[0];
var WALL = '#'.codeUnits[0];
var EMPTY = '.'.codeUnits[0];
var LEFT = '['.codeUnits[0];
var RIGHT = ']'.codeUnits[0];

void main() {
  var input = fileToStrings('./data/day15.dat');
  List<List<int>> grid = [];
  List<List<int>> grid2 = [];
  String path = '';
  bool isGrid = true;
  int posX = -1;
  int posY = -1;
  int posX2 = -1;
  int posY2 = -1;
  var posline = -1;
  for (var line in input) {
    posline++;
    if (line.trim() == '') {
      isGrid = false;
      continue;
    }
    if (isGrid) {
      grid.add(List.from(line.codeUnits));
      if (line.indexOf('@') != -1) {
        posY = posline;
        posX = line.indexOf('@');
        grid[posY][posX] = EMPTY;
      }

      line = line.replaceAll('O', '[]');
      line = line.replaceAll('@', '@Q');
      line = line.replaceAll('.', '..');
      line = line.replaceAll('#', '##');
      line = line.replaceAll('Q', '.');
      grid2.add(List.from(line.codeUnits));
      if (grid2.last.length != grid.last.length * 2) {
        throw("bad grid conversion");
      }
      if (line.indexOf('@') != -1) {
        posY2 = posline;
        posX2 = line.indexOf('@');
        grid2[posY2][posX2] = EMPTY;
      }
    } else {
      path += line;
    }
  }

  if (posY == -1 || posX == -1 || posY2 == -1 || posX2 == -1) {
    throw "didn't find robot";
  }

  for (var i = 0; i < path.length; i++) {
    (posX, posY) = moveRobot(grid, path[i], posX, posY);
    (posX2, posY2) = moveRobot2(grid2, path[i], posX2, posY2);
  }

  var gps = 0;
  var gps2 = 0;
  for (var i = 0; i < grid.length; i++) {
    for (var j = 0; j < grid[0].length; j++) {
      if (grid[i][j] == CRATE) {
        gps += 100 * i + j;
      }
    }
    for (var j = 0; j<grid2[0].length; j++) {
      if (grid2[i][j] == LEFT) {
        gps2 += 100 * i + j;
      }
    }
  }
  print(gps);
  print(gps2);
}

void printGrid(List<List<int>> grid) {
  for (var line in grid) {
    print(String.fromCharCodes(line));
  }
}

(int, int) moveRobot(List<List<int>> grid, String path, int posX, int posY) {
  switch(path) {
    case '^':
      for (var i = posY-1; i >= 0; i--) {
        if(grid[i][posX] == EMPTY) {
          if(i != posY - 1) {
            grid[i][posX] = CRATE;
            grid[posY-1][posX] = EMPTY;
          }
          posY--;
          break;
        }
        else if(grid[i][posX] == WALL) {
          break;
        }
      }
      break;
    case 'v':
      for (var i = posY+1; i < grid.length; i++) {
        if(grid[i][posX] == EMPTY) {
          if(i != posY + 1) {
            grid[i][posX] = CRATE;
            grid[posY+1][posX] = EMPTY;
          }
          posY++;
          break;
        }
        else if(grid[i][posX] == WALL) {
          break;
        }
      }
      break;
    case '<':
      for (var i = posX-1; i >= 0; i--) {
        if(grid[posY][i] == EMPTY) {
          if(i != posX - 1) {
            grid[posY][i] = CRATE;
            grid[posY][posX-1] = EMPTY;
          }
          posX--;
          break;
        }
        else if(grid[posY][i] == WALL) {
          break;
        }
      }
      break;
    case '>':
      for (var i = posX+1; i >= 0; i++) {
        if(grid[posY][i] == EMPTY) {
          if(i != posX + 1) {
            grid[posY][i] = CRATE;
            grid[posY][posX+1] = EMPTY;
          }
          posX++;
          break;
        }
        else if(grid[posY][i] == WALL) {
          break;
        }
      }
      break;
  }
  return (posX, posY);
}

(int, int) moveRobot2(List<List<int>> grid, String path, int posX, int posY) {
  var newX = posX;
  var newY = posY;
  switch(path) {
    case '^':
    case 'v':
      var dir = path == '^' ? -1 : 1;
      newY = posY + dir;
      if (grid[newY][newX] == EMPTY) {
        posY = newY;
        posX = newX;
        break;
      } else if (grid[newY][newX] == WALL) {
        break;
      } else {
        if (canMoveCrateVert(grid,
            grid[newY][newX] == LEFT ? newX : newX - 1, newY, dir)) {
          moveCrateVert(grid, grid[newY][newX] == LEFT ? newX : newX - 1, newY, dir);
          posY = newY;
          posX = newX;
        }
      }
      break;
    case '<':
      var dir = path == '<' ? -1 : 1;
      newX = posX + dir;
      if (grid[newY][newX] == EMPTY) {
        posY = newY;
        posX = newX;
        break;
      } else if (grid[newY][newX] == WALL) {
        break;
      } else {
        if (canMoveCrateLeft(grid,
            grid[newY][newX] == LEFT ? newX : newX - 1, newY)) {
          moveCrateLeft(grid, grid[newY][newX] == LEFT ? newX : newX - 1, newY);
          posY = newY;
          posX = newX;
        }
      }
      break;
    case '>':
      var dir = path == '<' ? -1 : 1;
      newX = posX + dir;
      if (grid[newY][newX] == EMPTY) {
        posY = newY;
        posX = newX;
        break;
      } else if (grid[newY][newX] == WALL) {
        break;
      } else {
        if (canMoveCrateRight(grid,
            grid[newY][newX] == LEFT ? newX : newX - 1, newY)) {
          moveCrateRight(grid, grid[newY][newX] == LEFT ? newX : newX - 1, newY);
          posY = newY;
          posX = newX;
        }
      }
      break;
  }
  return (posX, posY);
}

bool canMoveCrateLeft(List<List<int>> grid, int X, int Y) {
  if(grid[Y][X-1] == WALL) {
    return false;
  }
  if(grid[Y][X-1] == EMPTY) {
    return true;
  }
  return canMoveCrateLeft(grid, X-2, Y);
}

void moveCrateLeft(List<List<int>> grid, int X, int Y) {
  if (grid[Y][X-1] == WALL) {
    throw('should not hit wall');
  }
  if (grid[Y][X-1] == RIGHT) {
    moveCrateLeft(grid, X-2, Y);
  }
  grid[Y][X-1] = LEFT;
  grid[Y][X] = RIGHT;
  grid[Y][X+1] = EMPTY;
}

bool canMoveCrateRight(List<List<int>> grid, int X, int Y) {
  if(grid[Y][X+2] == WALL) {
    return false;
  }
  if(grid[Y][X+2] == EMPTY) {
    return true;
  }
  return canMoveCrateRight(grid, X+2, Y);
}

void moveCrateRight(List<List<int>> grid, int X, int Y) {
  if (grid[Y][X+2] == WALL) {
    throw('should not hit wall');
  }
  if (grid[Y][X+2] == LEFT) {
    moveCrateRight(grid, X+2, Y);
  }
  grid[Y][X+2] = RIGHT;
  grid[Y][X+1] = LEFT;
  grid[Y][X] = EMPTY;
}

bool canMoveCrateVert(List<List<int>> grid, int X, int Y, int dir) {
  if (grid[Y+dir][X] == WALL || grid[Y+dir][X+1] == WALL) {
    return false;
  }
  if (grid[Y+dir][X] == EMPTY && grid[Y+dir][X+1] == EMPTY) {
    return true;
  }

  var left = grid[Y+dir][X] == EMPTY ||
      (grid[Y+dir][X] == LEFT && canMoveCrateVert(grid, X, Y+dir, dir)) ||
      (grid[Y+dir][X] == RIGHT && canMoveCrateVert(grid, X-1, Y+dir, dir));
  var right = grid[Y+dir][X+1] == EMPTY ||
      (grid[Y+dir][X+1] == LEFT && canMoveCrateVert(grid, X+1, Y+dir, dir)) ||
      (grid[Y+dir][X+1] == RIGHT && canMoveCrateVert(grid, X, Y+dir, dir));
  return left && right;
}

void moveCrateVert(List<List<int>> grid, int X, int Y, int dir) {
  if (grid[Y+dir][X] == WALL || grid[Y+dir][X+1] == WALL) {
    throw('should not hit wall');
  }
  if (grid[Y+dir][X] == LEFT) {
    moveCrateVert(grid, X, Y+dir, dir);
  }
  if(grid[Y+dir][X] == RIGHT) {
    moveCrateVert(grid, X-1, Y+dir, dir);
  }
  if (grid[Y+dir][X+1] == LEFT) {
    moveCrateVert(grid, X+1, Y+dir, dir);
  }
  grid[Y+dir][X] = LEFT;
  grid[Y+dir][X+1] = RIGHT;
  grid[Y][X] = EMPTY;
  grid[Y][X+1] = EMPTY;
}