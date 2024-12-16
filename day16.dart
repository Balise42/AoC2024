import 'package:collection/collection.dart';

import 'utils.dart';

class Node {
  int row;
  int col;
  String dir;

  @override
  bool operator ==(Object other) {
    return other is Node && row == other.row && col == other.col && dir == other.dir;
  }

  @override
  int get hashCode => Object.hash(row, col, dir);

  Node(this.row, this.col, this.dir);
  List<Node> neighbors(List<String> grid) {
    List<Node> res = [];
    switch(dir) {
      case 'N':
        res.add(Node(this.row, this.col, 'E'));
        res.add(Node(this.row, this.col, 'W'));
        if (grid[row-1][col] != '#') {
          res.add(Node(this.row-1, col, 'N'));
        }
        break;
      case 'S':
        res.add(Node(this.row, this.col, 'E'));
        res.add(Node(this.row, this.col, 'W'));
        if (grid[row+1][col] != '#') {
          res.add(Node(this.row+1, col, 'S'));
        }
        break;
      case 'W':
        res.add(Node(this.row, this.col, 'N'));
        res.add(Node(this.row, this.col, 'S'));
        if (grid[row][col-1] != '#') {
          res.add(Node(this.row, col-1, 'W'));
        }
        break;
      case 'E':
        res.add(Node(this.row, this.col, 'N'));
        res.add(Node(this.row, this.col, 'S'));
        if (grid[row][col+1] != '#') {
          res.add(Node(this.row, col+1, 'E'));
        }
        break;
    }
    return res;
  }
}

class DijkstraNode {
  Node node;
  int dist;
  DijkstraNode(this.node, this.dist);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DijkstraNode &&
          runtimeType == other.runtimeType &&
          node == other.node &&
          dist == other.dist;

  @override
  int get hashCode => node.hashCode ^ dist.hashCode;
}

void main() {
  var grid = fileToStrings('./data/day16-sample.dat');
  var startRow = -1;
  var startCol = -1;
  var endRow = -1;
  var endCol = -1;
  for (var line = 0; line < grid.length; line++) {
    var candS = grid[line].indexOf('S');
    var candE = grid[line].indexOf('E');
    if (candS != -1) {
      startRow = line;
      startCol = candS;
    }
    if (candE != -1) {
      endRow = line;
      endCol = candE;
    }
  }

  Map<Node, int> visited = {};
  PriorityQueue<DijkstraNode> queue = new PriorityQueue(
    (DijkstraNode a, DijkstraNode b) => a.dist.compareTo(b.dist)
  );
  Map<DijkstraNode, Set<DijkstraNode>> parenthood = {};
  var start = Node(startRow, startCol, 'E');
  visited[start] = 0;
  queue.add(new DijkstraNode(start, 0));

  Set<(int, int)> spots = {};
  var dist = -1;

  while(queue.isNotEmpty) {
    var u = queue.removeFirst();
    if (u.node.row == endRow && u.node.col == endCol) {
      if (dist == -1 || visited[u.node] == dist) {
        if (dist == -1) {
          print(visited[u.node]);
        }
        dist = visited[u.node]!;
        addSpots(u, parenthood, spots);
      }
    }
    for(var v in u.node.neighbors(grid)) {
      var alt = visited[u.node]! + (v.dir == u.node.dir ? 1 : 1000);
      if(!visited.containsKey(v) || visited[v]! >= alt) {
        visited[v] = alt;
        var dv = new DijkstraNode(v, alt);
        if (!parenthood.containsKey(dv)) {
          parenthood[dv] = {};
        }
        parenthood[dv]!.add(u);
        queue.add(new DijkstraNode(v, alt));
      }
    }
  }

  // the +1 is for the arrival itself
  print(spots.length + 1);
}

void addSpots(DijkstraNode u, Map<DijkstraNode, Set<DijkstraNode>> parenthood, Set<(int, int)> spots) {
  if(parenthood.containsKey(u)) {
    for (var spot in parenthood[u]!) {
      spots.add((spot.node.row, spot.node.col));
      addSpots(spot, parenthood, spots);
    }
  }
}