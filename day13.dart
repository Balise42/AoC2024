import "utils.dart";
import "dart:math";

void main() {
  var input = fileToStrings('./data/day13.dat');

  var buttonRe = RegExp(r'Button [AB]: X\+(\d+), Y\+(\d+)');
  var prizeRe = RegExp(r'Prize: X=(\d+), Y=(\d+)');

  int linenr = 0;
  int res = 0;
  double res2 = 0;
  while(linenr < input.length) {
    var matchesA = buttonRe
        .allMatches(input[linenr])
        .first;
    linenr++;
    var matchesB = buttonRe
        .allMatches(input[linenr])
        .first;
    linenr++;
    var matchesPrize = prizeRe
        .allMatches(input[linenr])
        .first;
    linenr += 2;

    int xA = int.parse(matchesA[1]!);
    int yA = int.parse(matchesA[2]!);
    int xB = int.parse(matchesB[1]!);
    int yB = int.parse(matchesB[2]!);
    int Tx = int.parse(matchesPrize[1]!);
    int Ty = int.parse(matchesPrize[2]!);

    //part 1
    var cost = 400;
    for (var i = 0; i <= 100; i++) {
      var distAX = xA * i;
      var distAY = yA * i;
      if (distAX > Tx || distAY > Ty) {
        break;
      }
      if ((Tx - distAX) % xB == 0 && (Ty - distAY) % yB == 0 &&
          (Tx - distAX) ~/ xB == (Ty - distAY) ~/ yB) {
        var newCost = i * 3 + (Tx - distAX) ~/ xB;
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
    Tx += 10000000000000;
    Ty += 10000000000000;

    var det = (xA*yB-yA*xB);
    var alpha = (yB*Tx - xB*Ty)~/det;
    var beta = (-yA*Tx + xA*Ty)~/det;
    if(alpha*xA + beta*xB == Tx && alpha*yA + beta*yB == Ty) {
      res2 += alpha*3 + beta;
    }
  }
  print(res);
  print(res2);
}