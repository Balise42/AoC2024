import "dart:collection";

import "utils.dart";

void main() {
  var grid = fileToStrings('./data/day12.dat');
  for (int i = 0; i < grid.length; i++) {
    grid[i] = '@' + grid[i] + '@';
  }
  grid.insert(0, List.filled(grid[0].length, '@').join(''));
  grid.add(List.filled(grid[0].length, '@').join(''));

  var visited = <List<String>>[];
  for (var i = 0; i < grid.length; i++) {
    visited.add(List.filled(grid[0].length, '@'));
  }

  var components = <(int, int), int>{};

  var price = 0;
  var id = 0;
  for (var y = 1; y < grid.length-1; y++) {
    for (var x = 1; x < grid[0].length-1; x++) {
      if(visited[y][x] != grid[y][x]) {
        id++;
        price += computePrice(grid, visited, y, x, components, id);
      }
    }
  }
  print(price);

  var price2 = 0;

  // observation: the number of edges is equal to the number of corners, and corners are (feel) easier to detect
  for (var i = 1; i <= id; i++) {
    Map<(int, int), int> filtered = Map.from(components);
    filtered.removeWhere(((int, int) a, int b) => b != i);

    var corner = 0;
    for (var pos in filtered.keys) {
      var x = pos.$1;
      var y = pos.$2;
      if (!filtered.containsKey((x-1, y)) && !filtered.containsKey((x, y-1))) {
        corner++;
      }
      if (!filtered.containsKey((x+1, y)) && !filtered.containsKey((x, y-1))) {
        corner++;
      }
      if (!filtered.containsKey((x-1, y)) && !filtered.containsKey((x, y+1))) {
        corner++;
      }
      if (!filtered.containsKey((x+1, y)) && !filtered.containsKey((x, y+1))) {
        corner++;
      }

      if (filtered.containsKey((x-1, y)) && filtered.containsKey((x, y-1)) && !filtered.containsKey((x-1, y-1))) {
        corner++;
      }
      if (filtered.containsKey((x+1, y)) && filtered.containsKey((x, y-1)) && !filtered.containsKey((x+1, y-1))) {
        corner++;
      }
      if (filtered.containsKey((x-1, y)) && filtered.containsKey((x, y+1)) && !filtered.containsKey((x-1, y+1))) {
        corner++;
      }
      if (filtered.containsKey((x+1, y)) && filtered.containsKey((x, y+1)) && !filtered.containsKey((x+1, y+1))) {
        corner++;
      }
    }
    price2 += corner * filtered.length;
  }
  print(price2);
}

int computePrice(List<String> grid, List<List<String>> visited, int startY, int startX, Map<(int, int), int>components, int id) {
  var queue = Queue<(int,int)>();
  queue.addFirst((startY, startX));
  int perimeter = 0;
  int area = 0;
  var val = grid[startY][startX];
  visited[startY][startX] = val;
  components[(startX, startY)] = id;
  while(queue.isNotEmpty) {
    var (y, x) = queue.removeFirst();
    components[(x, y)] = id;
    area += 1;

    if (grid[y - 1][x] != val) {
      perimeter += 1;
    } else if (visited[y-1][x] != val) {
      visited[y-1][x] = val;
      queue.add((y - 1, x));
    }

    if (grid[y + 1][x] != val) {
      perimeter += 1;
    } else if (visited[y+1][x] != val) {
      visited[y+1][x] = val;
      queue.add((y + 1, x));
    }

    if (grid[y][x-1] != val) {
      perimeter += 1;
    } else if (visited[y][x-1] != val) {
      visited[y][x-1] = val;
      queue.add((y, x-1));
    }

    if (grid[y][x+1] != val) {
      perimeter += 1;
    } else if (visited[y][x+1] != val) {
      visited[y][x+1] = val;
      queue.add((y, x+1));
    }
  }
  return perimeter * area;
}