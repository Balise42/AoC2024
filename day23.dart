import "utils.dart";

void main() {
  var input = fileToStrings("./data/day23.dat");

  Map<String, List<String>> graph = {};
  for (var line in input) {
    var toks = line.split('-');
    graph.putIfAbsent(toks[0], () => []);
    graph.putIfAbsent(toks[1], () => []);
    graph[toks[0]]!.add(toks[1]);
    graph[toks[1]]!.add(toks[0]);
  }

  Set<String> ttriangles = {};
  Set<String> alltriangles = {};
  for (var entry in graph.entries) {
    for (var u in entry.value) {
      for (var v in entry.value) {
        if (graph[u]!.contains(v)) {
          var triangle = [entry.key, u, v];
          triangle.sort();
          var triangleS = triangle.join(',');
          if (entry.key.startsWith('t')) {
            ttriangles.add(triangleS);
          }
          alltriangles.add(triangleS);
        }
      }
    }
  }

  print(ttriangles.length);

  var currCliques = alltriangles;

  while(currCliques.isNotEmpty) {
    Set<String> nextCliques = {};
    for (String cliqueS in currCliques) {
      var clique = cliqueS.split(',');
      var candidates = Set<String>.from(graph[clique[0]]!);
      for (var i = 1; i < clique.length; i++) {
        candidates =
            candidates.intersection(Set<String>.from(graph[clique[i]]!));
      }
      for (var candidate in candidates) {
        var newClique = List.from(clique);
        newClique.add(candidate);
        newClique.sort();
        nextCliques.add(newClique.join(','));
      }
    }
    if(currCliques.length == 1) {
      print(currCliques.first);
    }
    currCliques = nextCliques;
  }


}