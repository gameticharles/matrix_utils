import 'package:matrix_utils/matrix_utils.dart';

void printLine(String s) {
  var l = '--- ' * 10;
  print('\n$l$s $l\n');
}

void main() {
  var matt = Matrix.fromList([
    [1, 2, -1],
    [3, 8, -1],
    [-1, 1, 2]
  ]);

  var eMat = Matrix("1 2 3 4; 2 5 6 7; 3 6 8 9; 4 7 9 10");

  printLine('QR decomposition');
  var qr1 = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]).decomposition.qrDecompositionGramSchmidt();
  print(qr1.Q);
  print(qr1.R);
  print(qr1.Q.isOrthogonalMatrix());
  print(qr1.R.isUpperTriangular());
  print(qr1.checkMatrix);
  print(matt.isAlmostEqual(qr1.checkMatrix));

  printLine('QR decomposition Householder');
  var qr2 = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]).decomposition.qrDecompositionHouseholder();
  print(qr2.Q);
  print(qr2.R);
  print(qr2.Q.isOrthogonalMatrix());
  print(qr2.R.isUpperTriangular());
  print(qr2.checkMatrix);
  print(matt.isAlmostEqual(qr2.checkMatrix));

  printLine('LQ decomposition');
  var lq = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]).decomposition.lqDecomposition();
  print("L:\n ${lq.L}");
  print("Q:\n ${lq.Q}");
  print(lq.checkMatrix);

  printLine('Cholesky Decomposition');
  var choleskyDec = Matrix([
    [4, 12, -16],
    [12, 37, -43],
    [-16, -43, 98]
  ]).decomposition.choleskyDecomposition();
  print('L:\n${choleskyDec.L}\n');
  print('isLowerTriangular: ${choleskyDec.isLowerTriangular}');
  print('isPositiveDefiniteMatrix: ${choleskyDec.isPositiveDefiniteMatrix}');
  print(choleskyDec.checkMatrix);

  // printLine('Eigenvalue Decomposition');
  // var B = Matrix([
  //   [2, 1],
  //   [1, 2]
  // ]);
  // var egd = B.decomposition.eigenvalueDecomposition();
  // print("D:\n ${egd.D}");
  // print("V:\n ${egd.V}");
  // print(egd.verify(B));
  // print(egd.checkMatrix);

  printLine('Singular Value Decomposition');
  var svd = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]).decomposition.singularValueDecomposition();
  print("U:\n ${svd.U}");
  print("S:\n ${svd.S}");
  print("V:\n ${svd.V}");
  print(svd.checkMatrix);

  printLine('Schur Decomposition');
  var shur = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]).decomposition.schurDecomposition();
  print("A:\n ${shur.A}");
  print("Q:\n ${shur.Q}");
  print("isOrthogonalMatrix: ${shur.isOrthogonalMatrix}");
  print(shur.checkMatrix);

  printLine('LU decomposition');

  var luMat = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]);
  var luB = Column([106.8, 177.2, 279.2]);

  ///L = Matrix([
  /// [   1,   0, 0],
  /// [2.56,   1, 0],
  /// [5.76, 3.5, 1]
  /// ])
  ///
  /// U = Matrix([
  ///   [25,    5,     1],
  ///   [ 0, -4.8, -1.56],
  ///   [ 0,    0,   0.7]
  /// ])
  print('\nluDecomposition');

  var lud = luMat.decomposition.luDecomposition();
  print("L:\n ${lud.L}");
  print("U:\n ${lud.U}");
  print(lud.checkMatrix);
  print(lud.solve(luB));

  // print('\nluDecompositionCrout');
  // lud = luMat.decomposition.luDecompositionCrout();
  // print("L:\n ${lud.L}");
  // print("U:\n ${lud.U}");
  // print(lud.checkMatrix);
  // print(lud.solve(luB));

  // print('\nluDecompositionDoolittle');
  // lud = luMat.decomposition.luDecompositionDoolittle();
  // print("L:\n ${lud.L}");
  // print("U:\n ${lud.U}");
  // print("P:\n ${lud.P}");
  // print(lud.checkMatrix);
  // print(lud.solve(luB));

  // print('\nluDecompositionGauss');
  // lud = luMat.decomposition.luDecompositionGauss();
  // print("L:\n ${lud.L}");
  // print("U:\n ${lud.U}");
  // print("P:\n ${lud.P}");
  // print(lud.checkMatrix);
  // print(lud.solve(luB));

  // print('\nluDecomposition');
  // lud = luMat.decomposition.luDecomposition();
  // print("L:\n ${lud.L}");
  // print("U:\n ${lud.U}");
  // print(lud.checkMatrix);
  // print(lud.solve(luB));

  // print('\nluDecompositionPartialPivoting');
  // lud = luMat.decomposition.luDecompositionPartialPivoting();
  // print("L:\n ${lud.L}");
  // print("U:\n ${lud.U}");
  // print("P:\n ${lud.P}");
  // print(lud.checkMatrix);
  // print(lud.solve(luB));

  // print('\n\nluDecompositionCompletePivoting');
  // lud = luMat.decomposition.luDecompositionCompletePivoting();
  // print("L:\n ${lud.L}");
  // print("U:\n ${lud.U}");
  // print("P:\n ${lud.P}");
  // print("Q:\n ${lud.Q}");
  // print(lud.checkMatrix);
  // print(lud.solve(luB));
}
