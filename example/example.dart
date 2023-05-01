import 'package:matrix_utils/matrix_utils.dart';

void main() {
  var mat = Matrix.random(5, 4);
  print(mat.round(3));

  mat = Matrix.fromList([
    [2, 3, 3, 3],
    [9, 9, 8, 6],
    [1, 1, 2, 9]
  ]);

  // Rank
  print(mat.rank()); // Output: 3

  // Change element value
  mat[0][0] = 3;

  // Access item
  print(mat[1][2]); // 8

  // Access row
  print(mat[0]);
  print(mat.row(0));

  // Access column
  print(mat.column(0)); //TODO

  // Row echelon form
  //print(mat.rref());

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

  // Shape
  print(m.shape);

  // flatten
  print(m.flatten());

  // transpose
  print(m.transpose());

  // addition
  var add = Matrix([
        [1, 1],
        [1, 1]
      ]) +
      Matrix([
        [2, 2],
        [2, 2]
      ]);
  print(add);

  // subtration
  var sub = [
        [1, 1],
        [1, 1]
      ].toMatrix() -
      [
        [2, 2],
        [2, 2]
      ].toMatrix();
  print(sub);

  // division

  var div = Matrix([
    [1, 1],
    [1, 1]
  ]).elementDivide(Matrix([
    [2, 0],
    [2, 2]
  ]));
  print(div);

  // dot operation

  var dot = [
    [1, 2],
    [3, 4]
  ].toMatrix().dot([
        [11, 12],
        [13, 14]
      ].toMatrix());
  print(dot);

  // arange

  var arange = Matrix.range(10);
  print(arange);

  // zeros
  var zeros = Matrix.zeros(2, 2);
  print(zeros);

  //ones
  var ones = Matrix.ones(2, 3);
  print(ones);

  //sum
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

  var newArray = sliceArray.slice(0, 2, 1, 4);
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

  var matrix = Matrix([
    [1, 2],
    [3, 4]
  ]);

// Matrix dot product
  var matrixB = Matrix([
    [2, 0],
    [1, 2]
  ]);
  var determinant = matrix.determinant();
  print(determinant); // Output: -2

  // // Eigen values and EigenVectors
  // Matrix A = Matrix.fromList([
  //   [2, 3, 3, 3],
  //   [9, 9, 8, 6],
  //   [1, 1, 2, 9],
  //   [0, 1, 1, 1]
  // ]);

  // List<dynamic> result = Matrix().qrAlgorithm(A, 100, 1e-10);
  // List<double> eigenvalues = result[0];
  // Matrix eigenvectors = result[1];

  // print("Eigenvalues:");
  // print(eigenvalues);

  // print("Eigenvectors:");
  // print(eigenvectors);
}
