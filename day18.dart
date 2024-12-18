import 'package:collection/collection.dart';

import 'utils.dart';

class DijkstraNode {
  (int, int) node;
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

  List<DijkstraNode> neighbors(Set<(int, int)> nodes) {
    List<DijkstraNode> res = [];
    if (nodes.contains((this.node.$1-1, this.node.$2))) {
      res.add(new DijkstraNode(
          (this.node.$1 - 1, this.node.$2), this.dist + 1));
    }
    if (nodes.contains((this.node.$1+1, this.node.$2))) {
      res.add(new DijkstraNode(
          (this.node.$1 + 1, this.node.$2), this.dist + 1));
    }
    if (nodes.contains((this.node.$1, this.node.$2-1))) {
      res.add(new DijkstraNode(
          (this.node.$1, this.node.$2 - 1), this.dist + 1));
    }
    if (nodes.contains((this.node.$1, this.node.$2+1))) {
      res.add(new DijkstraNode(
          (this.node.$1, this.node.$2 + 1), this.dist + 1));
    }
    return res;
  }
}

var numBytes = 1024;
var maxCoord = 70;

void main() {
  var lines = fileToStrings('./data/day18.dat');

  Set<(int, int)> nodes = {};
  for(var y = 0; y<=maxCoord; y++) {
    for (var x = 0; x <=maxCoord; x++) {
      nodes.add((x, y));
    }
  }

  for (var i = 0; i < numBytes; i++) {
    var coords = List<int>.from(lines[i].split(',').map((E)=>int.parse(E)));
    nodes.remove((coords[0], coords[1]));
  }

  print(dijkstra(nodes));

  for (var i = numBytes; i<lines.length; i++) {
    var coords = List<int>.from(lines[i].split(',').map((E)=>int.parse(E)));
    nodes.remove((coords[0], coords[1]));
    if (dijkstra(nodes) == -1) {
      print('${coords[0]},${coords[1]}');
      break;
    }
  }
}

int dijkstra(Set<(int, int)> nodes) {
  PriorityQueue<DijkstraNode> queue = new PriorityQueue(
          (DijkstraNode a, DijkstraNode b) => a.dist.compareTo(b.dist)
  );
  queue.add(new DijkstraNode((0, 0), 0));
  Map<(int, int), int> visited = {};
  visited[(0,0)] = 0;
  while(queue.isNotEmpty) {
    var u = queue.removeFirst();
    if (u.node.$1 == maxCoord && u.node.$2 == maxCoord) {
      return u.dist;
    }
    for (var neigh in u.neighbors(nodes)) {
      if(!visited.containsKey(neigh.node) || visited[neigh.node]! > neigh.dist) {
        visited[neigh.node] = neigh.dist;
        queue.add(neigh);
      }
    }
  }
  return -1;
}