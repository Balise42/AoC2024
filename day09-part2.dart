import "dart:collection";

import "utils.dart";

final class Block extends LinkedListEntry<Block> {
  bool hole = true;
  int size = 0;
  int pos = 0;
  int id = -1;
}

void main() {
  var input = fileToString('./data/day09-sample.dat');

  final blocks = LinkedList<Block>();
  var pos = 0;
  var id = 0;
  for (int i = 0; i < input.length; i++) {
    var next = int.parse(input[i]);
    var block = new Block();
    block.hole = (i%2 == 1);
    block.size = next;
    block.pos = pos;
    if (!block.hole) {
      block.id = id;
      id++;
    }
    pos += block.size;
    blocks.add(block);
  }

  var first = blocks.first;
  var last = blocks.last;

  while(last.previous != null) {
    if (last.hole) {
      last = last.previous!;
      continue;
    }
    Block? curr = first;
    var prevLast = last.previous!;
    while(curr != null && curr.pos < last.pos) {
      if(curr.hole && curr.size >= last.size) {
        last.unlink();
        curr.insertBefore(last);
        last.pos = curr.pos;

        if (last.size < curr.size) {
          curr.size -= last.size;
          curr.pos += last.size;
        } else {
          curr.unlink();
        }
        break;
      }
      curr = curr.next;
    }
    last = prevLast;
  }

  var res = 0;
  for (var block in blocks) {
    if(block.hole) {
      continue;
    }
    for(var i = 0; i<block.size; i++) {
      res += (block.pos + i) * block.id;
    }
  }
  print(res);
}