import 'package:matrix_utils/matrix_utils.dart';

void printLine(String s) {
  var l = '--- ' * 10;
  print('\n$l$s $l\n');
}

void main() {
  var eMat = Matrix("1 2 3 4; 2 5 6 7; 3 6 8 9; 4 7 9 10");

  var mat = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]);
  var b = Column([106.8, 177.2, 279.2]);

  Matrix A = Matrix.fromList([
    [4, 1, -1],
    [1, 4, -1],
    [-1, -1, 4]
  ]);
  Matrix b0 = Matrix.fromList([
    [6],
    [25],
    [14]
  ]);

  printLine('Properties of the Matrix');
  print('\n$mat\n');
  print('l1Norm: ${mat.l1Norm()}');
  print('l2Norm: ${mat.l2Norm()}');
  print('Condition number: ${mat.conditionNumber()}');
  mat.matrixProperties().forEach((element) => print(' - $element'));

  print('\n\n$A\n');
  print('l1Norm: ${A.l1Norm()}');
  print('l2Norm: ${A.l2Norm()}');
  //print('Rank: ${A.rank()}');
  print('Condition number: ${A.conditionNumber()}');
  //print('Decomposition Condition number: ${A.decomposition.conditionNumber()}');
  A.matrixProperties().forEach((element) => print(' - $element'));

  // print(A.ref());
  // print(A.rowEchelonForm());
  // print(A.rowEchelonForms());

  printLine('Solve linear Equations');

  print('Solve Decomposition: ${mat.linear.solve(b)}\n');

  printLine('QR decomposition Gram Schmidt');
  var qr1 = A.decomposition.qrDecompositionGramSchmidt();
  print(qr1.Q);
  print(qr1.R);
  print(qr1.Q.isOrthogonalMatrix());
  print(qr1.R.isUpperTriangular());
  print(qr1.checkMatrix);
  print(qr1.solve(b0));
  // print(matt.isAlmostEqual(qr1.checkMatrix));

  printLine('QR decomposition Householder');

  var qr2 = A.decomposition.qrDecompositionHouseholder();
  print(qr2.Q);
  print(qr2.R);
  print(qr2.Q.isOrthogonalMatrix());
  print(qr2.R.isUpperTriangular());
  print(qr2.checkMatrix);
  print(qr2.solve(b0));

  printLine('LQ decomposition');
  mat = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]);
  var lq = A.decomposition.lqDecomposition();
  print("L:\n ${lq.L}");
  print("Q:\n ${lq.Q}");
  print(lq.checkMatrix);
  print(lq.solve(b0));

  printLine('Cholesky Decomposition');

  var choleskyDec = A.decomposition.choleskyDecomposition();
  print('L:\n${choleskyDec.L}\n');
  print('isLowerTriangular: ${A.isLowerTriangular()}');
  print('isPositiveDefiniteMatrix: ${A.isPositiveDefiniteMatrix()}');
  print(choleskyDec.checkMatrix);
  print(choleskyDec.solve(b0));

  printLine('Eigenvalue Decomposition');
  mat = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]);

  var B = Matrix([
    [2, 1],
    [1, 2]
  ]);
  var matr = Matrix.fromList([
    [4, 1, 1],
    [1, 4, 1],
    [1, 1, 4]
  ]);
  // var egd = matr.decomposition.eigenvalueDecomposition();
  // print("D:\n ${egd.D}");
  // print("V:\n ${egd.V}");
  // print(egd.verify(B));
  // print(egd.checkMatrix);

  // print(matr.eigen().vectors);

  //var eig = matr.eigenSymmetric();
  // print("D:\n ${eig.values}");
  // print("V:\n");
  // for (Matrix eigenvector in eig.vectors) {
  //   print(eigenvector.round(1));
  // }
  // // print(eig.verify(B));

  printLine('Singular Value Decomposition');
  mat = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]);
  var svd = A.decomposition.singularValueDecomposition();
  print("U:\n ${svd.U}");
  print("S:\n ${svd.S}");
  print("V:\n ${svd.V}");
  print(svd.checkMatrix);
  print(svd.solve(b0));

  printLine('Schur Decomposition');

  // Note: It is generally preferable to use other decomposition methods, such
  // as LU or QR decomposition, to solve linear systems, as they are specifically
  // designed for this purpose.
  var shur = A.decomposition.schurDecomposition();
  print("A:\n ${shur.A}");
  print("Q:\n ${shur.Q}");
  print("isOrthogonalMatrix: ${shur.isOrthogonalMatrix}");
  print(shur.checkMatrix);
  print(shur.solve(b0));

  printLine('LU Decomposition Doolittle\'s algorithm');
  mat = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]);

  var lud = mat.decomposition.luDecompositionDoolittle();
  print("L:\n ${lud.L}");
  print("U:\n ${lud.U}");
  print(lud.checkMatrix);
  print(lud.solve(b));

  printLine('LU Decomposition Doolittle Partial Pivoting');
  mat = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]);
  lud = mat.decomposition.luDecompositionDoolittlePartialPivoting();
  print("L:\n ${lud.L}");
  print("U:\n ${lud.U}");
  print("P:\n ${lud.P}");
  print(lud.checkMatrix);
  print(lud.solve(b));

  printLine('LU Decomposition Doolittle Complete Pivoting');
  mat = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]);

  lud = mat.decomposition.luDecompositionDoolittleCompletePivoting();
  print("L:\n ${lud.L}");
  print("U:\n ${lud.U}");
  print("P:\n ${lud.P}");
  print("Q:\n ${lud.Q}");
  print(lud.checkMatrix);
  print(lud.solve(b));

  printLine('LU Decomposition Crout');
  mat = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]);

  lud = mat.decomposition.luDecompositionCrout();
  print("L:\n ${lud.L}");
  print("U:\n ${lud.U}");
  print(lud.checkMatrix);
  print(lud.solve(b));

  printLine('LU Decomposition Gauss');
  mat = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]);

  lud = mat.decomposition.luDecompositionGauss();
  print("L:\n ${lud.L}");
  print("U:\n ${lud.U}");
  print("P:\n ${lud.P}");
  print(lud.checkMatrix);
  print(lud.solve(b));

  printLine('LU Decomposition Partial Pivoting');
}
