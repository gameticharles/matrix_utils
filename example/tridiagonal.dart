import 'package:matrix_utils/matrix_utils.dart';

void printLine(String s) {
  var l = '--- ' * 10;
  print('\n$l$s $l\n');
}

void main() {
  printLine('Tridiagonalize');

  Matrix tri = Matrix.factory.tridiagonal(10, -4, 1, 2);
  print('Matrix tri = Matrix.tridiagonal(10, -4, 1, 2);\n$tri\n');

  // 2x2 simple symmetric matrix
  var a1 = Matrix([
    [2, 1],
    [1, 2]
  ]);

  //3x3 symmetric matrix with zeros on the diagonal
  var a2 = Matrix([
    [0, 2, 3],
    [2, 0, 4],
    [3, 4, 0]
  ]);

  // 4x4 symmetric matrix
  var a3 = Matrix([
    [4, 3, 2, 1],
    [3, 6, 5, 4],
    [2, 5, 8, 7],
    [1, 4, 7, 10]
  ]);

  // 5x5 symmetric matrix:
  var a4 = Matrix([
    [5, 4, 3, 2, 1],
    [4, 9, 8, 7, 6],
    [3, 8, 13, 12, 11],
    [2, 7, 12, 17, 16],
    [1, 6, 11, 16, 21]
  ]);

  // 4x4 sparse symmetric matrix
  var a5 = Matrix([
    [1, 0, 2, 0],
    [0, 3, 0, 4],
    [2, 0, 5, 0],
    [0, 4, 0, 6]
  ]);

  // 3x3 symmetric matrix with negative elements
  var a6 = Matrix([
    [2, -1, 3],
    [-1, 5, 4],
    [3, 4, 7]
  ]);

  var triA1 = a1.tridiagonalize();
  print("Is the triA1 tridiagonal? ${triA1.isTridiagonal()}");
  print('triA1:\n$triA1\n');

  var triA2 = a2.tridiagonalize();
  print("Is the triA2 tridiagonal? ${triA2.isTridiagonal()}");
  print('triA2:\n$triA2\n');

  var triA3 = a3.tridiagonalize();
  print("Is the triA3 tridiagonal? ${triA3.isTridiagonal()}");
  print('triA3:\n$triA3\n');

  var triA4 = a4.tridiagonalize();
  print("Is the triA4 tridiagonal? ${triA4.isTridiagonal()}");
  print('triA4:\n$triA4\n');

  var triA5 = a5.tridiagonalize();
  print("Is the triA5 tridiagonal? ${triA5.isTridiagonal()}");
  print('triA5:\n$triA5\n');

  var triA6 = a6.tridiagonalize();
  print("Is the triA6 tridiagonal? ${triA6.isTridiagonal()}");
  print('triA6:\n$triA6\n');
}
