# Matrix Library for Dart

[![pub package](https://img.shields.io/pub/v/matrix_utils.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/matrix_utils)
[![Null Safety](https://img.shields.io/badge/null-safety-brightgreen)](https://dart.dev/null-safety)
[![Last Commits](https://img.shields.io/github/last-commit/gameticharles/matrix_utils?ogo=github&logoColor=white)](https://github.com/gameticharles/matrix_utils/commits/master)
[![Pull Requests](https://img.shields.io/github/issues-pr/gameticharles/matrix_utils?ogo=github&logoColor=white)](https://github.com/gameticharles/matrix_utils/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/gameticharles/matrix_utils?ogo=github&logoColor=white)](https://github.com/gameticharles/matrix_utils)
[![License](https://img.shields.io/github/license/gameticharles/matrix_utils?ogo=github&logoColor=white)](https://github.com/gameticharles/matrix_utils/blob/main/LICENSE)

[![CI](https://img.shields.io/github/workflow/status/gameticharles/matrix_utils/Dart%20CI/master?logo=github-actions&logoColor=white)](https://github.com/gameticharles/matrix/actions)
[![New Commits](https://img.shields.io/github/commits-since/gameticharles/matrix_utils/latest?logo=github&logoColor=white)](https://github.com/gameticharles/matrix_utils/network)

A Dart library that provides an easy-to-use Matrix class for performing various matrix operations.

## Features

- Matrix creation, filling and generation: Methods for filling the matrix with specific values or generating matrices with certain properties, such as zero, ones, identity, diagonal, list, or random matrices.
- Import and export matrices to and from other formats (e.g., CSV, JSON, binary)
- Matrix operations: Implement common matrix operations such as addition, subtraction, multiplication (element-wise and matrix-matrix), and division (element-wise) etc.
- Matrix transformation methods: Add methods for matrix transformations, such as transpose, inverse, and rank.
- Matrix manipulation (concatenate, sort, removeRow, removeRows,removeCol,removeCols, reshape,Swapping rows and columns etc. )
- Statistical methods: Methods for calculating statistical properties of the matrix, such as min, max, sum, mean, median, mode, skewness, standard deviation, and variance.
- Element-wise operations: Methods for performing element-wise operations on the matrix, such as applying a function to each element or filtering elements based on a condition.
- Solving linear systems of equations
- Most matrix decompositions are implemented like LU decomposition, QR decomposition, LQ decomposition, Cholesky, Singular Value Decomposition (SVD)  with different algorithms Crout's, Doolittle, Gauss Elimination Method, Gram Schmidt, Householder, Partial and Complete Pivoting, etc.
- Matrix slicing and partitioning: Methods for extracting sub-Matrices or slices from the matrix.
- Matrix concatenation and stacking: Methods for concatenating or stacking matrices horizontally or vertically.
- Matrix norms: Methods for calculating matrix norms, such as L1, L2 (Euclidean), and infinity norms.
- Determine the properties of a matrix.
- From the matrix, row and columns of the matrix are iterables and also iterate on every element.

## TODO

- Improve speed and performance

## Usage

### Import the library

```dart
import 'package:matrix_utils/matrix_utils.dart';
```

## Create a Matrix

You can create a Matrix object in different ways:

```dart
// Create a 2x2 Matrix from string 
Matrix a = Matrix("1 2 3; 4 5 6; 7 8 9");
print(a);
// Output:
// Matrix: 3x3
// ┌ 1 2 3 ┐
// │ 4 5 6 │
// └ 7 8 9 ┘

// Create a matrix from a list of lists
Matrix b = Matrix([
  [1, 2],
  [3, 4]
]);
print(b);
// Output:
// Matrix: 2x2
// ┌ 1 2 ┐
// └ 3 4 ┘

// Create a matrix from a list of diagonal objects
Matrix d = Matrix.fromDiagonal([1, 2, 3]);
print(d);
// Output:
// Matrix: 3x3
// ┌ 1 0 0 ┐
// │ 0 2 0 │
// └ 0 0 3 ┘

// Create a from a list of lists
Matrix c = [[1, '2', true],[3, '4', false]].toMatrix()
print(c);
// Output:
// Matrix: 2x3
// ┌ 1 2  true ┐
// └ 3 4 false ┘

// Create a 2x2 matrix with all zeros
Matrix zeros = Matrix.zeros(2, 2);
print(zeros)
// Output:
// Matrix: 2x2
// ┌ 0 0 ┐
// └ 0 0 ┘

// Create a 2x3 matrix with all ones
Matrix ones = Matrix.ones(2, 3);
print(ones)
// Output:
// Matrix: 2x3
// ┌ 1 1 1 ┐
// └ 1 1 1 ┘

// Create a 2x2 identity matrix
Matrix identity = Matrix.eye(2);
print(identity)
// Output:
// Matrix: 2x2
// ┌ 1 0 ┐
// └ 0 1 ┘

// Create a matrix that is filled with same object
Matrix e = Matrix.fill(2, 3, 7);
print(e);
// Output:
// Matrix: 2x3
// ┌ 7 7 7 ┐
// └ 7 7 7 ┘

// Create a matrix from linspace and create a diagonal matrix
Matrix f = Matrix.linspace(0, 10, 3);
print(f);
// Output:
// Matrix: 1x3
// [ 0.0 5.0 10.0 ]

// Create from a range or arrange at a step
var m = Matrix.range(6, start: 1, step: 2, isColumn: false);
print(m);
// Output:
// Matrix: 1x3
// [ 1  3  5 ]

// Create a matrix from a random seed with range 
var randomMatrix = Matrix.random(3, 4, min: 1, max: 10, isInt: true);
print(randomMatrix);
// Output:
// Matrix: 3x4
// ┌ 3  5  9  2 ┐
// │ 1  7  6  8 │
// └ 4  9  1  3 ┘

```

## Check Matrix Properties

Easy much easier to query the properties of a matrix.

```dart
Matrix A = Matrix([
    [4, 1, -1],
    [1, 4, -1],
    [-1, -1, 4]
  ]);

  print('\n\n$A\n');
  print('l1Norm: ${A.l1Norm()}');
  print('l2Norm: ${A.l2Norm()}');
  print('Rank: ${A.rank()}');
  print('Condition number: ${A.conditionNumber()}');
  print('Decomposition Condition number: ${A.decomposition.conditionNumber()}');
  A.matrixProperties().forEach((element) => print(' - $element'));

  // Output:
  // Matrix: 3x3
  // ┌  4  1 -1 ┐
  // │  1  4 -1 │
  // └ -1 -1  4 ┘
  // 
  // l1Norm: 6.0
  // l2Norm: 7.3484692283495345
  // Rank: 3
  // Condition number: 3.6742346141747673
  // Decomposition Condition number: 1.9999999999999998
  //  - Square Matrix
  //  - Full Rank Matrix
  //  - Symmetric Matrix
  //  - Non-Singular Matrix
  //  - Hermitian Matrix
  //  - Positive Definite Matrix
  //  - Diagonally Dominant Matrix
  //  - Strictly Diagonally Dominant Matrix
```

## Matrix Operations

Perform matrix arithmetic operations:

```dart
Matrix a = Matrix([
  [1, 2],
  [3, 4]
]);

Matrix b = Matrix([
  [5, 6],
  [7, 8]
]);

// Addition of two square matrices
Matrix sum = a + b;
print(sum);
// Output:
// Matrix: 2x2
// ┌  6  8 ┐
// └ 10 12 ┘

// Addition of a matrix and a scalar
print(a + 2);
// Output:
// Matrix: 2x2
// ┌ 3 4 ┐
// └ 5 6 ┘

// Subtraction of two square matrices
Matrix difference = a - b;
print(difference);
// Output:
// Matrix: 2x2
// ┌ -4 -4 ┐
// └ -4 -4 ┘

// Matrix Scaler multiplication
Matrix scaler = a * 2;
print(scaler);
// Output:
// Matrix: 2x2
// ┌ 2 4 ┐
// └ 6 8 ┘

// Matrix dot product
Matrix product = a * Column([4,5]);
print(product);
// Output:
// Matrix: 2x1
// ┌ 14.0 ┐
// └ 32.0 ┘

// Matrix division
Matrix division = b / 2;
print(division);
// Output:
// Matrix: 2x2
// ┌ 2.5 3.0 ┐
// └ 3.5 4.0 ┘

// NB: For element-wise division, use elementDivision()
Matrix elementDivision = a.elementDivide(b);
print(elementDivision);
// Output:
// Matrix: 2x2
// ┌                 0.2 0.3333333333333333 ┐
// └ 0.42857142857142855                0.5 ┘


// Matrix exponent
Matrix expo = b ^ 2;
print(expo);
// Output:
// Matrix: 2x2
// ┌ 67  78 ┐
// └ 91 106 ┘

// Negate Matrix
Matrix negated = -a;
print(negated);
// Output:
// Matrix: 2x2
// ┌ -1 -2 ┐
// └ -3 -4 ┘

// Element-wise operation with function
var result = a.elementWise(b, (x, y) => x * y);
print(result);
// Output:
// Matrix: 2x2
// ┌  5 12 ┐
// └ 21 32 ┘

var matrix = Matrix([[-1, 2], [3, -4]]);
var abs = matrix.abs();
print(abs);
// Output:
// Matrix: 2x2
// ┌ 1 2 ┐
// └ 3 4 ┘

// Matrix Reciprocal round to 2 decimal places
var matrix = Matrix([[1, 2], [3, 4]]);
var reciprocal = matrix.reciprocal();
print(reciprocal.round(2));
// Output:
// Matrix: 2x2
// ┌                1.0  0.5 ┐
// └ 0.3333333333333333 0.25 ┘

// Round the elements to a decimal place
print(reciprocal.round(2));
// Output:
// Matrix: 2x2
// ┌  1.0  0.5 ┐
// └ 0.33 0.25 ┘

// Matrix dot product
var matrixB = Matrix([[2, 0], [1, 2]]);
var result = matrix.dot(matrixB);
print(result);
// Output:
// Matrix: 2x2
// ┌  4 4 ┐
// └ 10 8 ┘

// Determinant of a matrix
var determinant = matrix.determinant();
print(determinant); // Output: -2.0

// Inverse of Matrix
var inverse = matrix.inverse();
print(inverse);
// Output:
// Matrix: 2x2
// ┌ -0.5  1.5 ┐
// └  1.0 -2.0 ┘

// Transpose of a matrix
var transpose = matrix.transpose();
print(transpose);
// Output:
// Matrix: 2x2
// ┌ 4.0 2.0 ┐
// └ 3.0 1.0 ┘

// Find the normalized matrix
var normalize = matrix.normalize();
print(normalize);
// Output:
// Matrix: 2x2
// ┌ 1.0 0.75 ┐
// └ 0.5 0.25 ┘

// Norm of a matrix
var norm = matrix.norm();
print(norm); // Output: 5.477225575051661

// Sum of all the elements in a matrix
var sum = matrix.sum();
print(sum); // Output: 10

// determine the trace of a matrix
var trace = matrix.trace();
print(trace); // Output: 5

```

More operations are available

```dart
var v = Matrix([
  [1, 2, 3],
  [4, 5, 6],
  [1, 3, 5]
]);
var b = Matrix([
  [7, 8, 9],
  [4, 6, 8],
  [1, 2, 3]
]);

var r = Row([7, 8, 9]);
var c = Column([7, 4, 1]);
var d = Diagonal([1, 2, 3]);

print(d);
// Output:
// 1 0 0
// 0 2 0
// 0 0 3

v[1][2] = 0;

var u = v[1][2] + r[0][1];
print(u); // 9

var z = v[0][0] + c[0][0];
print(z); // 8

var y = v[1][2] + b[1][1];
print(y); // 9

var a = Matrix();
a.copyFrom(y); // Copy another matrix

var k = v.row(1); // Get all elements in row 1
print(k); // [1,2,3]

var n = v.column(1); // Get all elements in column 1
print(n); // [1,4,1]

```

## Partition of Matrix

```dart
// create a matrix
  Matrix m = Matrix([
    [1, 2, 3, 4, 5],
    [6, 7, 8, 9, 10],
    [5, 7, 8, 9, 10]
  ]);

// Extract a submatrix with rows 1 to 2 and columns 1 to 2
Matrix sub = m.submatrix(rowRange: "1:2", colRange: "0:1");

Matrix sub = m.submatrix(rowStart: 1, rowEnd: 2, colStart: 0, colEnd: 1);

// submatrix will be:
// [
//   [6]
// ]

var sub = m.submatrix(rowList: [0, 2], colList: [0, 2, 4]);
// sub will be:
// [
//   [1, 3, 5],
//   [5, 8, 10]
// ]  

// Get a submatrix
Matrix subMatrix = m.subMatrix(0, 1, 1, 3);

```

## Manipulating the matrix

Manipulate the matrices

```dart
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
var l3 = Matrix().concatenate([l1, l2]);
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

var a3 = Matrix().concatenate([a2, a1], axis: 1);
print(a3);

a3 = a2.concatenate([a1], axis: 1);
print(a3);

// Reshape the matrix
var matrix = Matrix([[1, 2], [3, 4]]);
var reshaped = matrix.reshape(1, 4);
print(reshaped);
// Output:
// 1  2  3  4

// Sort the elements in a matrix
var matrix = Matrix([[3], [1], [4]]);
var sortedMatrix = matrix.sort(ascending: false);
print(sortedMatrix);
// Output:
// 4
// 3
// 1

// Remove a row
var matrixWithoutRow = matrix.removeRow(1);
print(matrixWithoutRow);
// Output:
// 1  2
// 5  6

```

## Solving Linear Systems of Equations

Use the solve method to solve a linear system of equations:

```dart
Matrix a = Matrix([[2, 1, 1], [1, 3, 2], [1, 0, 0]]);;

Matrix b = Matrix([[4], [5], [6]]);

// Solve the linear system Ax = b
Matrix x = a.linear.solve(b, method: LinearSystemMethod.gaussElimination);
print(x);
// Output:
// 6.0
// 15.0
// -23.0

```

You can also use the the decompositions to solve a linear system of equations

```dart
Matrix A = Matrix([
  [4, 1, -1],
  [1, 4, -1],
  [-1, -1, 4]
]);
Matrix b = Matrix([
  [6],
  [25],
  [14]
]);

//Solve using the Schur Decomposition
SchurDecomposition schur = A.decomposition.schurDecomposition();

//Solve using the QR Decomposition Householder
QRDecomposition qr = A.decomposition.qrDecompositionHouseholder();

// Solve for x using the object
var x = qr.solve(b).round();
print(x);

// Output:
// Matrix: 3x1
// ┌ 1 ┐
// │ 7 │
// └ 6 ┘

```

## Boolean Operations

Some functions in the library that results in boolean values

```dart
// Check contain or not
var matrix1 = Matrix([[1, 2], [3, 4]]);
var matrix2 = Matrix([[5, 6], [7, 8]]);
var matrix3 = Matrix([[1, 2, 3], [3, 4, 5], [5, 6, 7]]);
var targetMatrix = Matrix([[1, 2], [3, 4]]);

print(targetMatrix.containsIn([matrix1, matrix2])); // Output: true
print(targetMatrix.containsIn([matrix2, matrix3])); // Output: false

print(targetMatrix.notIn([matrix2, matrix3])); // Output: true
print(targetMatrix.notIn([matrix1, matrix2])); // Output: false

print(targetMatrix.isSubMatrix(matrix3)); // Output: true

```

Check Equality of Matrix

```dart
var m1 = Matrix([[1, 2], [3, 4]]);
var m2 = Matrix([[1, 2], [3, 4]]);
print(m1 == m2); // Output: true

print(m1.notEqual(m2)); // Output: false

```

Compare elements of Matrix

```dart
var m = Matrix.fromList([
    [2, 3, 3, 3],
    [9, 9, 8, 6],
    [1, 1, 2, 9]
  ]);
var result = Matrix.compare(m, '>', 2);
print(result);
// Output:
// Matrix: 3x4
// ┌ false  true  true true ┐
// │  true  true  true true │
// └ false false false true 

```

## Sorting Matrix

```dart
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
```

## Other Functions

The Matrix class provides various other functions for matrix manipulation and analysis.

```dart

// Swap rows
var matrix = Matrix([[1, 2], [3, 4]]);
matrix.swapRows(0, 1);
print(matrix);
// Output:
// Matrix: 2x2
// ┌ 3 4 ┐
// └ 1 2 ┘


// Swap columns
matrix.swapColumns(0, 1);
print(matrix);
// Output:
// Matrix: 2x2
// ┌ 4 3 ┐
// └ 2 1 ┘

// Index (row,column) of an element in the matrix 
var index = m.indexOf(3);
print(index);
// Output: [1, 0]

// Get the leading diagonal of the matrix
var m = Matrix([[1, 2], [3, 4]]);
var diag = m.diagonal();
print(diag);
// Output: [1, 4]

// Iterate through elements in the matrix using map function
var doubled = m.map((x) => x * 2);
print(doubled);
// Output:
// Matrix: 2x2
// ┌ 2 4 ┐
// └ 6 8 ┘

// // Iterate through elements in the matrix using foreach method
var m = Matrix([[1, 2], [3, 4]]);
m.forEach((x) => print(x));
// Output:
// 1
// 2
// 3
// 4

```

## Testing

Tests are located in the test directory. To run tests, execute dart test in the project root.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/gameticharles/matrix_utils/issues

## Author

Charles Gameti: [gameticharles@GitHub][github_cg].

[github_cg]: https://github.com/gameticharles

## License

This library is provided under the
[Apache License - Version 2.0][apache_license].

[apache_license]: https://www.apache.org/licenses/LICENSE-2.0.txt
