# Matrix Library for Dart

[![pub package](https://img.shields.io/pub/v/matrix_utils.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/matrix_utils)
[![Null Safety](https://img.shields.io/badge/null-safety-brightgreen)](https://dart.dev/null-safety)
[![likes](https://img.shields.io/pub/likes/matrix_utils)](https://pub.dartlang.org/packages/matrix_utils/score)
[![points](https://img.shields.io/pub/points/matrix_utils)](https://pub.dartlang.org/packages/matrix_utils/score)
[![popularity](https://img.shields.io/pub/popularity/matrix_utils)](https://pub.dartlang.org/packages/matrix_utils/score)
[![sdk version](https://badgen.net/pub/sdk-version/matrix_utils)](https://pub.dartlang.org/packages/matrix_utils)

[![Last Commits](https://img.shields.io/github/last-commit/gameticharles/matrix_utils?ogo=github&logoColor=white)](https://github.com/gameticharles/matrix_utils/commits/master)
[![Pull Requests](https://img.shields.io/github/issues-pr/gameticharles/matrix_utils?ogo=github&logoColor=white)](https://github.com/gameticharles/matrix_utils/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/gameticharles/matrix_utils?ogo=github&logoColor=white)](https://github.com/gameticharles/matrix_utils)
[![License](https://img.shields.io/github/license/gameticharles/matrix_utils?ogo=github&logoColor=white)](https://github.com/gameticharles/matrix_utils/blob/main/LICENSE)

[![stars](https://img.shields.io/github/stars/gameticharles/matrix_utils)](https://github.com/gameticharles/matrix_utils/stargazers)
[![forks](https://img.shields.io/github/forks/gameticharles/matrix_utils)](https://github.com/gameticharles/matrix_utils/network/members)
[![CI](https://img.shields.io/github/workflow/status/gameticharles/matrix_utils/Dart%20CI/master?logo=github-actions&logoColor=white)](https://github.com/gameticharles/matrix/actions)

A Dart library that provides an easy-to-use Matrix class for performing various matrix operations and linear algebra.

> ## ⚠️ Note
> 
> A more robust version of this library is available in **[advance_math](https://pub.dev/packages/advance_math)**.
> 
> *This package will soon be updated to reflect the stable features found in **advance_math***.


## Features

- Matrix creation, filling and generation: Methods for filling the matrix with specific values or generating matrices with certain properties, such as zero, ones, identity, diagonal, list, or random matrices.
- Import and export matrices to and from other formats (e.g., CSV, JSON, binary)
- Matrix operations: Implement common matrix operations such as addition, subtraction, multiplication (element-wise and matrix-matrix), and division (element-wise) etc.
- Matrix transformation methods: Add methods for matrix transformations, such as transpose, inverse, pseudoInverse, and rank etc.
- Matrix manipulation (concatenate, sort, removeRow, removeRows, removeCol, removeCols, reshape, swapping rows and columns etc. )
- Statistical methods: Methods for calculating statistical properties of the matrix, such as min, max, sum, mean, median, mode, skewness, standard deviation, and variance.
- Element-wise operations: Methods for performing element-wise operations on the matrix, such as applying a function to each element or filtering elements based on a condition.
- Solving linear systems of equations
- Solve matrix decompositions like LU decomposition, QR decomposition, LQ decomposition, Cholesky, Singular Value Decomposition (SVD)  with different algorithms Crout's, Doolittle, Gauss Elimination Method, Gram Schmidt, Householder, Partial and Complete Pivoting, etc.
- Matrix slicing and partitioning: Methods for extracting sub-Matrices or slices from the matrix.
- Matrix concatenation and stacking: Methods for concatenating or stacking matrices horizontally or vertically.
- Matrix norms: Methods for calculating matrix norms, such as L1, L2 (Euclidean), and infinity norms.
- Determine the properties of a matrix.
- From the matrix, row and columns of the matrix are iterables and also iterate on every element.
- Supports vectors, complex numbers and complex vectors with most of the basic functionalities and operations.

## TODO

- Improve speed and performance

## Usage

### Import the library

```dart
import 'package:matrix_utils/matrix_utils.dart';
```

## Create a Matrix

You can create a Matrix object in different ways:

Create a 2x2 Matrix from string

```dart
Matrix a = Matrix("1 2 3; 4 5 6; 7 8 9");
print(a);
// Output:
// Matrix: 3x3
// ┌ 1 2 3 ┐
// │ 4 5 6 │
// └ 7 8 9 ┘
```

Create a matrix from a list of lists

```dart
Matrix b = Matrix([[1, 2], [3, 4]]);
print(b);
// Output:
// Matrix: 2x2
// ┌ 1 2 ┐
// └ 3 4 ┘
```

Create a matrix from a list of diagonal objects

```dart
Matrix d = Matrix.fromDiagonal([1, 2, 3]);
print(d);
// Output:
// Matrix: 3x3
// ┌ 1 0 0 ┐
// │ 0 2 0 │
// └ 0 0 3 ┘
```

Create a matrix from a flattened array

```dart
final source = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
final ma = Matrix.fromFlattenedList(source, 2, 6);
print(ma);
// Output:
// Matrix: 2x6
// ┌ 1 2 3 4 5 6 ┐
// └ 7 8 9 0 0 0 ┘
```

Create a matrix from list of columns

```dart
var col1 = Column([1, 2, 3]);
var col2 = Column([4, 5, 6]);
var col3 = Column([7, 8, 9]);
var matrix = Matrix.fromColumns([col1, col2, col3]);
print(matrix);
// Output:
// Matrix: 3x3
// ┌ 1 4 7 ┐
// | 2 5 8 |
// └ 3 6 9 ┘
```

Create a matrix from list of rows

```dart
var row1 = Row([1, 2, 3]);
var row2 = Row([4, 5, 6]);
var row3 = Row([7, 8, 9]);
var matrix = Matrix.fromRows([row1, row2, row3]);
print(matrix);
// Output:
// Matrix: 3x3
// ┌ 1 2 3 ┐
// | 4 5 6 |
// └ 7 8 9 ┘
```

Create a from a list of lists

```dart
Matrix c = [[1, '2', true],[3, '4', false]].toMatrix()
print(c);
// Output:
// Matrix: 2x3
// ┌ 1 2  true ┐
// └ 3 4 false ┘
```

Create a 2x2 matrix with all zeros

```dart
Matrix zeros = Matrix.zeros(2, 2);
print(zeros)
// Output:
// Matrix: 2x2
// ┌ 0 0 ┐
// └ 0 0 ┘
```

Create a 2x3 matrix with all ones

```dart
Matrix ones = Matrix.ones(2, 3);
print(ones)
// Output:
// Matrix: 2x3
// ┌ 1 1 1 ┐
// └ 1 1 1 ┘
```

Create a 2x2 identity matrix

```dart
Matrix identity = Matrix.eye(2);
print(identity)
// Output:
// Matrix: 2x2
// ┌ 1 0 ┐
// └ 0 1 ┘
```

Create a matrix that is filled with same object

```dart
Matrix e = Matrix.fill(2, 3, 7);
print(e);
// Output:
// Matrix: 2x3
// ┌ 7 7 7 ┐
// └ 7 7 7 ┘
```

Create a matrix from linspace and create a diagonal matrix

```dart
Matrix f = Matrix.linspace(0, 10, 3);
print(f);
// Output:
// Matrix: 1x3
// [ 0.0 5.0 10.0 ]
```

Create from a range or arrange at a step

```dart
var m = Matrix.range(6, start: 1, step: 2, isColumn: false);
print(m);
// Output:
// Matrix: 1x3
// [ 1  3  5 ]
```

Create a random matrix within arange of values

```dart
var randomMatrix = Matrix.random(3, 4, min: 1, max: 10, isDouble: true);
print(randomMatrix);
// Output:
// Matrix: 3x4
// ┌ 3  5  9  2 ┐
// │ 1  7  6  8 │
// └ 4  9  1  3 ┘
```

Create a specific random matrix from the  matrix factory 

```dart
var randomMatrix = Matrix.factory
  .create(MatrixType.general, 5, 4, min: 0, max: 3, isDouble: true);
print('\n${randomMatrix.round(3)}');
```

Create a specific type of matrix from a random seed with range

```dart
randMat = Matrix.factory.create(MatrixType.general, 5, 4,
    min: 0, max: 3, seed: 12, isDouble: true);
print('\n${randMat.round(3)}');

// Output:
// Matrix: 5x4
// ┌ 1.949 1.388 2.833 1.723 ┐
// │ 0.121 1.954 2.386 2.407 │
// │ 2.758  2.81 1.026 0.737 │
// │ 1.951  0.37 0.075 0.069 │
// └ 2.274 1.932 2.659 0.196 ┘
```

```dart
var randomMatrix = Matrix.factory
    .create(MatrixType.sparse, 5, 5, min: 0, max: 2, seed: 12, isDouble: true);

print('\nProperties of the Matrix:\n${randomMatrix.round(3)}\n');
randomMatrix.matrixProperties().forEach((element) => print(' - $element'));

// Properties of the Matrix:
// Matrix: 5x5
// ┌ 0.0 1.149   0.0 0.0   0.0 ┐
// │ 0.0   0.0 0.925 0.0 1.302 │
// │ 0.0   0.0   0.0 0.0   0.0 │
// │ 0.0   0.0   0.0 0.0   0.0 │
// └ 0.0   0.0   0.0 0.0   0.0 ┘
//
//  - Square Matrix
//  - Upper Triangular Matrix
//  - Singular Matrix
//  - Vandermonde Matrix
//  - Nilpotent Matrix
//  - Sparse Matrix
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

## Matrix Copy

Copy another original matrix

```dart
var a = Matrix();
a.copy(y); // Copy another matrix
```

Copy the elements of the another matrix and resize the current matrix

```dart
var matrixA = Matrix([[1, 2], [3, 4]]);
var matrixB = Matrix([[5, 6], [7, 8], [9, 10]]);
matrixA.copyFrom(matrixB, resize: true);
print(matrixA);
// Output:
// 5  6
// 7  8
// 9 10
```

Copy the elements of the another matrix but retain the current matrix size

```dart
var matrixA = Matrix([[1, 2, 3], [4, 5, 6], [7, 8, 9]]);
var matrixB = Matrix([[10, 11], [12, 13]]);
matrixA.copyFrom(matrixB, retainSize: true);
print(matrixA);
// Output:
// 10 11 3
// 12 13 6
// 7  8  9
```

## Matrix Interoperability

To convert a matrix to a json-serializable map one may use toJson method:

### to<->from JSON

You can serialize the matrix to a json-serializable map and deserialize back to a matrix object.

```dart
final matrix = Matrix.fromList([
    [11.0, 12.0, 13.0, 14.0],
    [15.0, 16.0, 0.0, 18.0],
    [21.0, 22.0, -23.0, 24.0],
    [24.0, 32.0, 53.0, 74.0],
  ]);

// Convert to JSON representation
final serialized = matrix.toJson();
```

To restore a serialized matrix one may use Matrix.fromJson constructor:

```dart
final matrix = Matrix.fromJson(serialized);
```

### to<->from CSV

You can write csv file and read it back to a matrix object.

```dart
String csv = '''
1.0,2.0,3.0
4.0,5.0,6.0
7.0,8.0,9.0
''';
Matrix matrix = await Matrix.fromCSV(csv: csv);
print(matrix);

// Alternatively, read the CSV from a file:
Matrix matrixFromFile = await Matrix.fromCSV(inputFilePath: 'input.csv');
print(matrixFromFile);

// Output:
// Matrix: 3x3
// ┌ 1.0 2.0 3.0 ┐
// │ 4.0 5.0 6.0 │
// └ 7.0 8.0 9.0 ┘
```

Write to a csv file 

``` dart
String csv = matrix.toCSV(outputFilePath: 'output.csv');
print(csv);

// Output:
// ```
// 1.0,2.0,3.0
// 4.0,5.0,6.0
// 7.0,8.0,9.0
// ```
```

### to<->from Binary Data

You can serialize the matrix to a json-serializable map and deserialize back to a matrix object.

```dart
ByteData bd1 = matrix.toBinary(jsonFormat: false); // Binary format
ByteData bd2 = matrix.toBinary(jsonFormat: true); // JSON format
```

To restore a serialized matrix one may use Matrix.fromBinary constructor:

```dart
Matrix m1 = Matrix.fromBinary(bd1, jsonFormat: false); // Binary format
Matrix m2 = Matrix.fromBinary(bd2, jsonFormat: true); // JSON format
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

## Assessing the elements of a matrix

Matrix can be accessed as components

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
```

Change or use element value

```dart
v[1][2] = 0;

var u = v[1][2] + r[0][1];
print(u); // 9

var z = v[0][0] + c[0][0];
print(z); // 8

var y = v[1][2] + b[1][1];
print(y); // 9

var k = v.row(1); // Get all elements in row 1
print(k); // [1,2,3]

var n = v.column(1); // Get all elements in column 1
print(n); // [1,4,1]
```

Index (row,column) of an element in the matrix

```dart
var mat = Matrix.fromList([
  [2, 3, 3, 3],
  [9, 9, 8, 6],
  [1, 1, 2, 9]
]);

var index = mat.indexOf(8);
print(index);
// Output: [1, 2]

var indices = mat.indexOf(3, findAll: true);
print(indices);
// Output: [[0, 1], [0, 2], [0, 3]]
```

Access Row and Column

```dart
var mat = Matrix.fromList([
  [2, 3, 3, 3],
  [9, 9, 8, 6],
  [1, 1, 2, 9]
]);

print(mat[0]);
print(mat.row(0));

// Access column
print(mat.column(0));

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

// Delete row
print(mat.removeRow(0));

// Delete column
print(mat.removeColumn(0));

// Delete rows
mat.removeRows([0, 1]);

// Delete columns
mat.removeColumns([0, 2]);
```

### Iterable objects from a matrix

You can get the iterable from a matrix object. Consider the matrix below:

```dart
var mat = Matrix.fromList([
  [2, 3, 3, 3],
  [9, 9, 8, 6],
  [1, 1, 2, 9]
]);
```

Iterate through the rows of the matrix using the default iterator

```dart
for (List<dynamic> row in mat.rows) {
  print(row);
}
```

Iterate through the columns of the matrix using the column iterator

```dart
for (List<dynamic> column in mat.columns) {
  print(column);
}
```

Iterate through the elements of the matrix using the element iterator

```dart
for (dynamic element in mat.elements) {
  print(element);
}
```

Iterate through elements in the matrix using foreach method

```dart
var m = Matrix([[1, 2], [3, 4]]);
m.forEach((x) => print(x));
// Output:
// 1
// 2
// 3
// 4
```

## Partition of Matrix

```dart
// create a matrix
  Matrix m = Matrix([
    [1, 2, 3, 4, 5],
    [6, 7, 8, 9, 10],
    [5, 7, 8, 9, 10]
  ]);

// Extract a subMatrix with rows 1 to 2 and columns 1 to 2
Matrix sub = m.subMatrix(rowRange: "1:2", colRange: "0:1");

Matrix sub = m.subMatrix(rowStart: 1, rowEnd: 2, colStart: 0, colEnd: 1);

// submatrix will be:
// [
//   [6]
// ]

sub = m.subMatrix(rowList: [0, 2], colList: [0, 2, 4]);
// sub will be:
// [
//   [1, 3, 5],
//   [5, 8, 10]
// ]

sub = m.subMatrix(columnIndices: [4, 4, 2]);
 print("\nsub array: $sub");
// sub array: Matrix: 3x3
// ┌  5  5 3 ┐
// │ 10 10 8 │
// └ 10 10 8 ┘

// Get a submatrix
Matrix subMatrix = m.slice(0, 1, 1, 3);
```

## Manipulating the matrix

Manipulate the matrices

1. concatenate on axis 0

```dart
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
// Output:
// Matrix: 7x3
// ┌ 1 1 1 ┐
// │ 1 1 1 │
// │ 1 1 1 │
// │ 0 0 0 │
// │ 0 0 0 │
// │ 0 0 0 │
// └ 0 0 0 ┘
```

2. concatenate on axis 1

```dart
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

a3 = a2.concatenate([a1], axis: 1);
print(a3);
// Output:
// Matrix: 3x14
// ┌ 0 0 0 0 0 0 0 0 0 0 1 1 1 1 ┐
// │ 0 0 0 0 0 0 0 0 0 0 1 1 1 1 │
// └ 0 0 0 0 0 0 0 0 0 0 1 1 1 1 ┘
```

Reshape the matrix

```dart
var matrix = Matrix([[1, 2], [3, 4]]);
var reshaped = matrix.reshape(1, 4);
print(reshaped);
// Output:
// 1  2  3  4
```

## Solving Linear Systems of Equations

Use the solve method to solve a linear system of equations:

```dart
Matrix a = Matrix([[2, 1, 1], [1, 3, 2], [1, 0, 0]]);;

Matrix b = Matrix([[4], [5], [6]]);

// Solve the linear system Ax = b
Matrix x = a.linear.solve(b, method: LinearSystemMethod.gaussElimination);
print(x.round(1));
// Output:
// Matrix: 3x1
// ┌   6.0 ┐
// │  15.0 │
// └ -23.0 ┘
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
// └ false false false true ┘
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

## Other Functions of matrices

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
```

## Vectors, Complex Numbers, and ComplexVectors

This library provides efficient and easy-to-use classes for representing and manipulating vectors, complex numbers, and complex vectors in Dart. This document serves as an introduction to these classes, featuring a variety of examples to demonstrate their usage.

### Vectors

Vectors are a fundamental concept in mathematics and physics. They represent quantities that have both magnitude and direction.

This library allows you to create vectors, access and modify their elements, and perform vector operations such as addition, subtraction, and dot product.

```dart
// Creating a new vector
Vector v = Vector(3);
print(v);  // Output: [0, 0, 0]

// Setting and getting elements
v[0] = 1;
v[1] = 2;
v[2] = 3;
print(v[0]);  // Output: 1
print(v);  // Output: [1, 2, 3]

// Performing vector operations
Vector u = Vector.fromList([4, 5, 6]);
Vector sum = v + u;
Vector diff = v - u;
double dotProduct = v.dot(u);
print(sum);  // Output: [5, 7, 9]
print(diff);  // Output: [-3, -3, -3]
print(dotProduct);  // Output: 32

// Norm and normalization
double norm = v.norm();
Vector normalized = v.normalize();
print(norm);  // Output: 3.7416573867739413
print(normalized);  // Output: [0.2672612419124244, 0.5345224838248488, 0.8017837257372732]

// Extraction
var u1 = Vector.fromList([5, 0, 2, 4]);
var v1 = u1.getVector(['x', 'x', 'y']);
print(v1); // Output: [5.0, 5.0, 0.0)]
print(v1.runtimeType); // Vector3

u1 = Vector.fromList([5, 0, 2]);
v1 = u1.subVector(range: '1:2');
print(v1); // Output: [5.0, 5.0, 0.0, 2.0]
print(v1.runtimeType); // Vector4

var v = Vector.fromList([1, 2, 3, 4, 5]);
var subVector = v.subVector(indices: [0, 2, 4, 1, 1]);
print(subVector);  // Output: [1.0, 3.0, 5.0, 2.0, 2.0]
print(subVector.runtimeType); // Vector
```

### Complex Numbers

Complex numbers extend the concept of the one-dimensional number line to the two-dimensional complex plane by using the number i, where i^2 = -1.

Complex numbers are crucial in many areas of mathematics and engineering.

The Complex class in this library lets you create complex numbers, access their real and imaginary parts, and obtain their conjugate.

```dart
// Creating a new complex number
Complex z = Complex(3, 2);
print(z);  // Output: 3 + 2i

// Accessing the real and imaginary parts
print(z.real);  // Output: 3
print(z.imaginary);  // Output: 2

// Conjugation
Complex conjugate = z.conjugate();
print(conjugate);  // Output: 3 - 2i

```

### Complex vectors

ComplexVectors are a type of vector where the elements are complex numbers. They are especially important in quantum mechanics and signal processing.

The ComplexVector class provides ways to create complex vectors, perform operations on them such as addition, and calculate their norm and normalized form.

```dart
// Creating a new complex vector
ComplexVector cv = ComplexVector(2);
cv[0] = Complex(1, 2);
cv[1] = Complex(3, 4);
print(cv);  // Output: [(1 + 2i), (3 + 4i)]

// Accessing elements
print(cv[0]);  // Output: 1 + 2i

// Vector operations (example: addition)
ComplexVector cv2 = ComplexVector.fromList([Complex(5, 6), Complex(7, 8)]);
ComplexVector sum = cv + cv2;
print(sum);  // Output: [(6 + 8i), (10 + 12i)]

// Norm and normalization
double norm = cv.norm();
ComplexVector normalized = cv.normalize();
print(norm);  // Output: 5.477225575051661
print(normalized);  // Output: [(0.18257418583505536 + 0.3651483716701107i), (0.5477225575051661 + 0.7302967433402214i)]
```

The above sections provide a basic introduction to vectors, complex numbers, and complex vectors. The full API of these classes offers even more possibilities, including conversions to other forms of vectors, multiplication by scalars, and more. These classes aim to make mathematical programming in Dart efficient, flexible, and enjoyable.

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
