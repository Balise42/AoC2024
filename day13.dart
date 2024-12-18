import "utils.dart";
import "dart:math";

void main() {
  var input = fileToStrings('./data/day13-sample.dat');

  var buttonRe = RegExp(r'Button [AB]: X\+(\d+), Y\+(\d+)');
  var prizeRe = RegExp(r'Prize: X=(\d+), Y=(\d+)');

  int linenr = 0;
  int res = 0;
  int res2 = 0;
  while(linenr < input.length) {
    var matchesA = buttonRe.allMatches(input[linenr]).first;
    linenr++;
    var matchesB = buttonRe.allMatches(input[linenr]).first;
    linenr++;
    var matchesPrize = prizeRe.allMatches(input[linenr]).first;
    linenr += 2;

    var AX = int.parse(matchesA[1]!);
    var AY = int.parse(matchesA[2]!);
    var BX = int.parse(matchesB[1]!);
    var BY = int.parse(matchesB[2]!);
    var tarX = int.parse(matchesPrize[1]!);
    var tarY = int.parse(matchesPrize[2]!);

    //part 1
    var cost = 400;
    for(var i = 0; i<=100; i++) {
      var distAX = AX * i;
      var distAY = AY * i;
      if (distAX > tarX || distAY > tarY) {
        break;
      }
      if ((tarX - distAX) % BX == 0 && (tarY - distAY) % BY == 0 && (tarX - distAX) ~/ BX == (tarY - distAY) ~/ BY) {
        var newCost = i*3 + (tarX - distAX) ~/ BX;
        if (newCost < cost) {
          cost = newCost;
        }
      }
    }
    if (cost < 400) {
      res += cost;
    }

    // part 2
    // if ax + by = c, there exists an integer solution only c % gcd(a,b) == 0
    tarX += 10000000000000;
    tarY += 10000000000000;

    var gcdx = AX.gcd(BX);
    var gcdy = AY.gcd(BY);
    if (tarX % gcdx == 0 && tarY % gcdy == 0) {
      var a = AX;
      var b = BX;
      var c = tarX;
      var d = gcdx;

      var a1 = a ~/ d;
      var b1 = b ~/ d;
      var c1 = c ~/ d;

      var x0 = 0, y0 = 0;
      for (var i = 0; i <= b1; i++) {
        if ((a1*i) % b1 == 1) {
          x0 = i;
          y0 = (1-a1*x0)~/b1;
          break;
        }
      }

      var x1 = x0*c1;
      var y1 = y0*c1;

      if (y1 < 0) {
        var k = y1 ~/ -a1 + 1;
        y1 += k*a1;
        x1 -= k*b1;
      }

      print("$x1 $y1 ${x1 * AX + y1*BX} ${x1 * AX + y1*BY}");
    }
    else {
      print("coin");
    }
  }
  print(res);
}