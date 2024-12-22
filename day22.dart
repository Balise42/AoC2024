import "utils.dart";

void main() {
  var input = fileToStrings('./data/day22.dat').map((E) => int.parse(E)).toList();

  Map<(int, int, int, int), int> moves = {};

  var res = 0;
  for (var seed in input) {
    var nums = generate(seed, 2000);
    nums.insert(0, seed);
    Set<(int, int, int, int)> seen = {};
    for (var i = 1; i<nums.length-4; i++) {
      var (a, b, c, d) = (nums[i]%10-nums[i-1]%10, nums[i+1]%10 - nums[i]%10, nums[i+2]%10 - nums[i+1]%10, nums[i+3]%10 - nums[i+2]%10);
      if (!seen.contains((a, b, c, d))) {
        moves.putIfAbsent((a, b, c, d), () => 0);
        moves[(a, b, c, d)] = moves[(a, b, c, d)]! + nums[i + 3] % 10;
        seen.add((a, b, c, d));
      }
    }
    res += nums[nums.length-1];
  }

  int max = 0;
  for (var val in moves.values) {
    if (val > max) {
      max = val;
    }
  }

  print(res);
  print(max);
}

List<int> generate(int seed, int iter) {
  List<int> nums = [];
  for (var i = 0; i<iter; i++) {
    seed = prune(mix(seed, seed * 64));
    seed = prune(mix(seed, seed ~/ 32));
    seed = prune(mix(seed, seed*2048));
    nums.add(seed);
  }
  return nums;
}

int mix(int seed, int tomix) {
  return seed ^ tomix;
}

int prune(int seed) {
  return seed % 16777216;
}

