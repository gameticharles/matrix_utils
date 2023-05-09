import 'package:matrix_utils/matrix_utils.dart';

void printLine(String s) {
  var l = '--- ' * 10;
  print('\n$l$s $l\n');
}

void main() {
  var mat = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]);
}
