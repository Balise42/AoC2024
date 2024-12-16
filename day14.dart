import 'utils.dart';

void main() {
  var input = fileToStrings('./data/day14.dat');
  var width = 101;
  var height = 103;

  var lineRe = RegExp(r'p=(\d+),(\d+) v=(-?\d+),(-?\d+)');

  Map<(int, int), int> robots = {};
  List<(int, int, int, int)> initRobots = [];

  for (var line in input) {
    var match = lineRe.firstMatch(line);
    var pX = int.parse(match![1]!);
    var pY = int.parse(match[2]!);
    var vX = int.parse(match[3]!);
    var vY = int.parse(match[4]!);

    initRobots.add((pX, pY, vX, vY));

    (int, int) pos = moveRobot(pX, pY, vX, vY, 100, width, height);
    robots.putIfAbsent(pos, () => 0);
    robots[pos] = robots[pos]! + 1;
  }

  var (q1, q2, q3, q4, uniq) = countQuadrants(robots, width, height);
  print (q1 * q2 * q3 * q4);


  var iter = 0;
  while(iter < 10000) {
    iter++;
    robots = {};
    var grid = List.filled(height, []);
    for (var i = 0; i< grid.length; i++) {
      grid[i] = List.filled(width, '.');
    }
    List<(int,int,int,int)> nextRobots = [];
    for (var robot in initRobots) {
      (int, int) pos = moveRobot(robot.$1, robot.$2, robot.$3, robot.$4, 1, width, height);
      robots.putIfAbsent(pos, () => 0);
      robots[pos] = robots[pos]! + 1;
      nextRobots.add((pos.$1, pos.$2, robot.$3, robot.$4));
      grid[pos.$2][pos.$1] = '#';
    }
    (q1, q2, q3, q4, uniq) = countQuadrants(robots, width, height);
    if (uniq) {
      print ("haha! $iter");
      for(var line in grid) {
        print(line.join(''));
      }
    }
    initRobots = nextRobots;


  }

}

(int, int, int, int, bool) countQuadrants(Map<(int, int), int> robots, width, height) {
  var q1 = 0, q2 = 0, q3 = 0, q4 = 0;
  var uniq = true;
  for (var entry in robots.entries) {
    if(entry.value > 1) {
      uniq = false;
    }
    var x = entry.key.$1;
    var y = entry.key.$2;
    if (x < (width - 1) ~/ 2 && y < (height - 1) ~/ 2) {
      q1 += entry.value;
    } else if (x > (width - 1) ~/ 2 && y <(height - 1) ~/ 2) {
      q2 += entry.value;
    } else if (x < (width - 1) ~/ 2 && y > (height - 1) ~/ 2) {
      q3 += entry.value;
    } else if (x > (width - 1) ~/ 2 && y > (height - 1) ~/ 2) {
      q4 += entry.value;
    }
  }
  return (q1, q2, q3, q4, uniq);
}

(int, int) moveRobot(int pX, int pY, int vX, int vY, int n, int width, int height) {
  for(var i = 0; i<n; i++) {
    pX = pX + vX;
    pY = pY + vY;

    while(pX < 0) {
      pX += width;
    }
    while(pY < 0) {
      pY += height;
    }
    while(pX >= width) {
      pX -= width;
    }
    while(pY >= height) {
      pY -= height;
    }
  }
  return (pX, pY);
}