import 'dart:io';

List<String> fileToStrings(String path) {
  var file = File(path);
  return file.readAsLinesSync();
}

String fileToString(String path) {
  var file = File(path);
  return file.readAsStringSync();
}