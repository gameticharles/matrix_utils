import 'package:matrix_utils/matrix_utils.dart';

void printLine(String s) {
  var l = '--- ' * 10;
  print('\n$l$s $l\n');
}

void main() {
  var mat = Matrix.fromList([
    [2, 3, 3, 3],
    [9, 9, 8, 6],
    [1, 1, 2, 9]
  ]);

  var matt = Matrix.fromList([
    [1, 2, -1],
    [3, 8, -1],
    [-1, 1, 2]
  ]);
  var eMat = Matrix("1 2 3 4; 2 5 6 7; 3 6 8 9; 4 7 9 10");
  var eMat1 = Matrix("-26 -32 -25; 31 42 23; -11 -15 -4");
  var eMat2 = Matrix([
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
    [13, 14, 15, 16]
  ]);

  printLine('Matrix Properties');
  var randMat = Matrix.random(5, 4);
  print(randMat.round(3));

  printLine('Matrix Properties');

  print('Properties of the Matrix:\n$eMat\n');
  eMat.matrixProperties().forEach((element) => print(' - $element'));

  printLine('Eigen matrix');

  var matr = Matrix.fromList([
    [4, 1, 1],
    [1, 4, 1],
    [1, 1, 4]
  ]);

  var eigen = matr.eigen1();
  print('Eigen Values:\n${eigen.values}\n');
  print('Eigenvectors:');
  for (Matrix eigenvector in eigen.vectors) {
    print(eigenvector.round(2));
  }
  print('Verification: ${eigen.verify(matr)}');
  print('Reconstruct Original:\n ${eigen.check}');

  List<Matrix> normalizedEigenvectors =
      eigen.vectors.map((vector) => vector.normalize()).toList();
  Eigen normalizedEigen = Eigen(eigen.values, normalizedEigenvectors);

  print('Normalized eigenvectors:');
  for (Matrix eigenvector in normalizedEigen.vectors) {
    print(eigenvector);
  }
  print('Reconstruct Original:\n ${normalizedEigen.check}');

  eigen = Eigen([
    6,
    3,
    3
  ], [
    Matrix([
      [1],
      [1],
      [1]
    ]),
    Matrix([
      [-1],
      [0],
      [1]
    ]),
    Matrix([
      [-1],
      [1],
      [0]
    ]),
  ]);
  print('Check Matrix: ${eigen.check}');

  // eigen = DivideAndConquer().divideAndConquer(eMat);
  // print('Eigen Values:\n${eigen.values}\n');
  // print('Eigen Values:\n${eigen.vectors}\n');
  // print('Check: ${eigen.verify(eMat)}');

  printLine('Element Search');
  var y = mat.where(
    (value) => value.contains(6),
  );
  print('Rows that contains 6:\n${y}');

  printLine('Iterate through rows');
  // Iterate through the rows of the matrix using the default iterator
  for (List<dynamic> row in mat.rows) {
    print(row);
  }

  printLine('Iterate through columns');
  // Iterate through the columns of the matrix using the column iterator
  for (List<dynamic> column in mat.columns) {
    print(column);
  }
  printLine('Iterate through elements');
  // Iterate through the elements of the matrix using the element iterator
  for (dynamic element in mat.elements) {
    print(element);
  }

  printLine('Matrix Statistics');

  var A = Matrix("1 2 3 4; 2 5 6 7; 3 6 8 9; 4 7 9 10");
  print(A);

  print('Shape: ${A.shape}');
  print('Sum: ${A.sum()}');
  print('Absolute Sum: ${A.sum(absolute: true)}');
  print('Determinant: ${A.determinant()}');
  print('Rank: ${A.rank()}');
  print('Trace: ${A.trace()}');
  print('Skewness: ${A.skewness()}');
  print('Kurtosis: ${A.kurtosis()}');
  print('Norm(l1Norm): ${A.l1Norm()}'); // Output: 7.0
  print('l2Norm: ${A.l2Norm()}'); // Output: 5.477225575051661
  print('Infinity Norm: ${A.infinityNorm()}'); // Output: 5.0

  print(A.rowEchelonForm());
  print(A.reducedRowEchelonForm());

  // var yy = Matrix([
  //   [1, 2, 3],
  //   [0, 1, 1],
  //   [0, 0, 0]
  // ]);
  // print(yy.reducedRowEchelonForm());
  // print(yy.rowSpace());

  printLine('Access Row and Column');

  print(mat);

  // Change element value
  mat[0][0] = 3;

  // Access item
  print('\nmat[1][2]: ${mat[1][2]}'); // 8

  // Access row
  print('Access row 0');
  print(mat[0]);
  print(mat.row(0));

  // Access column
  print(mat.column(0)); //TODO

  // update row method 1
  mat[0] = [1, 2, 3, 4];
  print(mat);

  // update row method 2
  var v = mat.setRow(0, [4, 5, 6, 7]);
  print(v);

  // Update column
  v = mat.setColumn(0, [1, 4, 5]);
  print(v);

  // Insert row
  v = mat.insertRow(0, [8, 8, 8, 8]);
  print(v);

  // Insert column
  v = mat.insertColumn(4, [8, 8, 8, 8]);
  print(v);

  // Append Rows
  var tailRows = [
    [8, 8, 8, 8, 8],
    [8, 8, 8, 8, 8]
  ];

  print(mat.appendRows(tailRows));

  var tailColumns = Matrix.fromList([
    [8, 8],
    [8, 8],
    [8, 8],
    [8, 8]
  ]);

  print(mat.appendColumns(tailColumns));

  // Delete row
  print(mat.removeRow(0));

  // Delete column
  print(mat.removeColumn(0));

// Delete rows
  mat.removeRows([0, 1]);

// Delete columns
  mat.removeColumns([0, 2]);

  Matrix m = Matrix([
    [1, 2],
    [1, 2]
  ]);

  // flatten
  print(m.flatten());

  // transpose
  print(m.transpose());

  printLine('Arithmetic operations');

  var aa = Matrix([
    [1, 1],
    [1, 1]
  ]);

  var bb = Matrix([
    [2, 2],
    [2, 2]
  ]);
  print('aa:\n $aa');
  print('aa:\n $aa\n');

  print('Addition:\n${aa + bb}\n');

  print('Subtraction:\n${aa + bb}\n');

  print('Division:');
  var div = aa.elementDivide(Matrix([
    [2, 0],
    [2, 2]
  ]));
  print(div);

  print('\nDot operation:');
  var dot = [
    [1, 2],
    [3, 4]
  ].toMatrix().dot([
        [11, 12],
        [13, 14]
      ].toMatrix());
  print(dot);

  printLine('Creating Matrices');

  print('Arrange 1 to 10');
  var arange = Matrix.range(10);
  print(arange);

  print('Create Zero 2x2 Matrix');
  var zeros = Matrix.zeros(2, 2);
  print(zeros);

  print('Create Ones 2x3 Matrix');
  var ones = Matrix.ones(2, 3);
  print(ones);

  print('Sum');
  var sum = Matrix([
    [2, 2],
    [2, 2]
  ]);
  print(sum.sum);

  // reshape
  var array = [
    [0, 1, 2, 3, 4, 5, 6, 7]
  ];
  print(array.toMatrix().reshape(4, 2));

  // linspace
  var linspace = Matrix.linspace(2, 3, 5);
  print(linspace);

  // diagonal
  var arr = [
    [1, 1, 1],
    [2, 2, 2],
    [3, 3, 3]
  ];
  print(arr.diagonal);
  print(Diagonal(arr.diagonal));

  //fill
  var fill = Matrix.fill(3, 3, 'matrix');
  print(fill);

  // compare object
  var compare = Matrix.compare(m, '>=', 2);
  print(compare);

  // concatenate

  // axis 0
  var l1 = Matrix([
    [1, 1, 1],
    [1, 1, 1],
    [1, 1, 1]
  ]);
  var l2 = Matrix([
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
  ]);
  var l3 = l1.concatenate([l2]);
  print(l3);

  // axis 1
  var a1 = Matrix([
    [1, 1, 1, 1],
    [1, 1, 1, 1],
    [1, 1, 1, 1]
  ]);
  var a2 = Matrix([
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  ]);

  var a3 = a2.concatenate([a1], axis: 1);
  print(a3);

  // slice
  var sliceArray = Matrix([
    [1, 2, 3, 4, 5],
    [6, 7, 8, 9, 10],
    [6, 7, 8, 9, 10]
  ]);

  var newArray = sliceArray.subMatrix(0, 2, 1, 4);
  print(" sliced array: ${newArray}");

  // min max
  var numbers = Matrix([
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
  ]);
  print(numbers.min());
  print(numbers.max());

  Matrix a = Matrix([
    [1, 2],
    [3, 4]
  ]);

  Matrix b = Matrix([
    [5, 6],
    [7, 8]
  ]);

// Index (row,column) of an element in the matrix
  var index = a.indexOf(3);
  print(index);
// Output: [1, 0]

// Swap rows
  var matrix = Matrix([
    [1, 2],
    [3, 4]
  ]);
  matrix.swapRows(0, 1);
  print(matrix);

// Swap columns
  matrix.swapColumns(0, 1);
  print(matrix);

  m = Matrix.fromList([
    [2, 3, 3, 3],
    [9, 9, 8, 6],
    [1, 1, 2, 9]
  ]);
  var cmp = Matrix.compare(m, '>', 2);
  print(cmp);

  var m1 = Matrix([
    [1, 2],
    [3, 4]
  ]);
  var m2 = Matrix([
    [1, 2],
    [3, 4]
  ]);
  print(m1 == m2); // Output: true
  print(m1.notEqual(m2)); // Output: false

  // Transpose of a matrix
  var transpose = matrix.transpose();
  print(transpose);

  // Inverse of Matrix
  var inverse = matrix.inverse();
  print(inverse);

  //Solve Matrix
  var AA = Matrix([
    [2, 1, 1],
    [1, 3, 2],
    [1, 0, 0]
  ]);
  var bbb = Matrix([
    [4],
    [5],
    [6]
  ]);
  //var result = A.gaussianElimination(b);
  var sol = AA.linear.solve(bbb, method: LinearSystemMethod.leastSquares);
  print(sol);

  // Find the normalized matrix
  var normalize = matrix.normalize();
  print(normalize);

  Matrix x = Matrix.fromList([
    [2, 3, 3, 3],
    [9, 9, 8, 6],
    [1, 1, 2, 9],
    [0, 1, 1, 1]
  ]);

  //Sorting all elements in ascending order (default behavior):
  var sortedMatrix = x.sort();
  print(sortedMatrix);
  // Matrix: 4x4
  // ┌ 0 1 1 1 ┐
  // │ 1 1 2 2 │
  // │ 3 3 3 6 │
  // └ 8 9 9 9 ┘

  // Sorting all elements in descending order:
  var sortedMatrix1 = x.sort(ascending: false);
  print(sortedMatrix1);
  // Matrix: 4x4
  // ┌ 9 9 9 8 ┐
  // │ 6 3 3 3 │
  // │ 2 2 1 1 │
  // └ 1 1 1 0 ┘

// Sort by a single column in descending order
  var sortedMatrix2 = x.sort(columnIndices: [0]);
  print(sortedMatrix2);
  // Matrix: 4x4
  // ┌ 0 1 1 1 ┐
  // │ 1 1 2 9 │
  // │ 2 3 3 3 │
  // └ 9 9 8 6 ┘

// Sort by multiple columns in specified orders
  var sortedMatrix3 = x.sort(columnIndices: [1, 0]);
  print(sortedMatrix3);
  // Matrix: 4x4
  // ┌ 0 1 1 1 ┐
  // │ 1 1 2 9 │
  // │ 2 3 3 3 │
  // └ 9 9 8 6 ┘

// Sorting rows based on the values in column 2 (descending order):
  Matrix xSortedColumn2Descending =
      x.sort(columnIndices: [2], ascending: false);
  print(xSortedColumn2Descending);
  // Matrix: 4x4
  // ┌ 9 9 8 6 ┐
  // │ 2 3 3 3 │
  // │ 1 1 2 9 │
  // └ 0 1 1 1 ┘
}
