part of matrix_utils;

/// The `Matrix` class provides a structure for two-dimensional arrays of data,
/// along with various utility methods for manipulating these arrays.
///
/// The class extends `IterableMixin` allowing iteration over the rows or columns of the matrix.
class Matrix extends IterableMixin<List<dynamic>> {
  /// Private field to hold the actual data of the matrix.
  List<List<dynamic>> _data = const [];

  /// Getter to retrieve row-wise iteration over the matrix.
  /// It returns an iterable of rows, where each row is a list of elements.
  ///
  /// Example usage:
  /// ```
  /// final matrix = Matrix([[1, 2], [3, 4]]);
  /// matrix.rows.forEach(print); // Prints [1, 2] then [3, 4]
  /// ```
  Iterable<List<dynamic>> get rows => _MatrixIterable(this, columnMajor: false);

  /// Getter to retrieve column-wise iteration over the matrix.
  /// It returns an iterable of columns, where each column is a list of elements.
  ///
  /// Example usage:
  /// ```
  /// final matrix = Matrix([[1, 2], [3, 4]]);
  /// matrix.columns.forEach(print); // Prints [[1], [3]] then [[2], [4]]
  /// ```
  Iterable<List<dynamic>> get columns =>
      _MatrixIterable(this, columnMajor: true);

  /// Getter to retrieve an iterable over all elements in the matrix,
  /// regardless of their row or column.
  ///
  /// Example usage:
  /// ```
  /// final matrix = Matrix([[1, 2], [3, 4]]);
  /// matrix.elements.forEach(print); // Prints 1, 2, 3, 4
  /// ```
  Iterable<dynamic> get elements => _MatrixElementIterable(this);

  /// Getter to retrieve the MatrixDecomposition object associated with the matrix.
  /// This object provides methods for various matrix decompositions, like LU, QR etc.
  MatrixDecomposition get decomposition {
    return MatrixDecomposition(this);
  }

  /// Getter to retrieve the LinearSystemSolvers object associated with the matrix.
  /// This object provides methods for solving linear systems of equations represented by the matrix.
  LinearSystemSolvers get linear {
    return LinearSystemSolvers(this);
  }

  /// Static getter to retrieve the MatrixFactory object.
  /// This object provides methods for generating special kinds of matrices like diagonal, identity etc.
  static MatrixFactory get factory => MatrixFactory();

  /// Overrides the iterator getter to provide a MatrixIterator.
  /// This iterator iterates over the rows of the matrix.
  @override
  Iterator<List<dynamic>> get iterator => MatrixIterator(this);

  // Define a constant for the colon (:) for easier usage
  static const String colon = ':';

  /// Constructs a Matrix object from a List<List<dynamic>> or a String.
  /// If input is null or not provided, an empty Matrix is created.
  ///
  /// [input]: List<List<dynamic>> or String representing the matrix data.
  ///
  /// Example:
  /// ```dart
  /// Matrix([
  ///   [1, 2],
  ///   [3, 4]
  /// ]);
  ///
  /// Matrix("1 2; 3 4");
  /// ```
  Matrix([dynamic input]) {
    if (input == null) {
      _data = const [];
    } else if (input is String) {
      _data = _Utils.parseMatrixString(input);
    } else if (input is List<List<dynamic>>) {
      // if (input is List<List<num>>) {
      // _data = _Utils.toDoubleMatrix(input);
      // } else {
      // _data = input;
      // }

      int length = input[0].length;
      for (var row in input) {
        if (row.length != length) {
          throw Exception('Rows have different lengths');
        }
      }
      _data = input;
    } else {
      throw Exception('Invalid input type');
    }
  }

  /// Returns the number of rows in the matrix.
  int get rowCount => _data.length;

  /// Returns the number of columns in the matrix.
  int get columnCount => _data.isEmpty ? 0 : _data[0].length;

  /// Returns the dimensions of the matrix as a List<int> in the format [rowCount, columnCount].
  List<int> get shape => [_data.length, _data[0].length];

  /// Assigns the value to the specified row index of the matrix.
  operator []=(int index, List<dynamic> value) {
    if (_data.isNotEmpty && value.length != _data[0].length) {
      throw Exception('Row has different length than the other rows');
    }
    if (index < 0 || index >= _data.length) {
      throw Exception('Index is out of range');
    }
    _data[index] = value;
  }

  /// Retrieves the specified row from the matrix.
  List<dynamic> operator [](int index) {
    if (index < 0 || index >= _data.length) {
      throw Exception('Index is out of range');
    }
    return _data[index];
  }

  /// Compares two matrices for inequality. Returns true if the matrices have different dimensions or any elements are not equal, otherwise false.
  ///
  /// [other]: The other Matrix object to compare.
  ///
  /// Example:
  /// ```dart
  /// var m1 = Matrix([[1, 2], [3, 4]]);
  /// var m2 = Matrix([[1, 2], [3, 5]]);
  /// print(m1.equal(m2)); // Output: false
  ///```
  bool equal(Object other) => (this == other);

  /// Compares two matrices for inequality. Returns true if the matrices have different dimensions or any elements are not equal, otherwise false.
  ///
  /// [other]: The other Matrix object to compare.
  ///
  /// Example:
  /// ```dart
  /// var m1 = Matrix([[1, 2], [3, 4]]);
  /// var m2 = Matrix([[1, 2], [3, 5]]);
  /// print(m1.notEqual(m2)); // Output: true
  ///```
  bool notEqual(Object other) => !(this == other);

  /// Creates a square Matrix with the specified diagonal elements.
  ///
  /// [diagonal]: List<dynamic> containing the diagonal elements.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix.fromDiagonal([1, 2, 3]);
  /// print(m);
  /// // Output:
  /// // Matrix: 3x3
  /// // ┌ 1 0 0 ┐
  /// // │ 0 2 0 │
  /// // └ 0 0 3 ┘
  /// ```
  factory Matrix.fromDiagonal(List<dynamic> diagonal) {
    if (diagonal.isEmpty) {
      throw Exception('Diagonal cannot be null or empty');
    }
    int n = diagonal.length;
    List<List<dynamic>> data = List.generate(
        n, (i) => List.generate(n, (j) => i == j ? diagonal[i] : 0));
    return Matrix(data);
  }

  /// Creates a matrix from the given list of lists.
  ///
  /// [list]: The input list of lists containing elements to populate the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix.fromList([[1, 2], [3, 4], [5, 6]]);
  /// print(matrix);
  /// // Output:
  /// // Matrix: 3x2
  /// // ┌ 1  2 ┐
  /// // │ 3  4 │
  /// // └ 5  6 ┘
  /// ```
  factory Matrix.fromList(List<List<dynamic>> list) {
    return Matrix(list);
  }

  /// Constructs a new Matrix from a flattened list.
  ///
  /// This function takes a single-dimensional list and the desired number of
  /// rows and columns and returns a new Matrix with those dimensions, populated
  /// with the elements from the source list.
  ///
  /// The function fills the Matrix in row-major order, which means that it
  /// fills the first row from left to right, then moves on to the next row,
  /// and so on.
  ///
  /// Throws an `ArgumentError` if the provided list does not contain exactly
  /// `rows * cols` elements.
  ///
  /// - [source]: A single-dimensional list containing the elements to populate
  ///             the new Matrix.
  /// - [rows]: The number of rows the new Matrix should have.
  /// - [cols]: The number of columns the new Matrix should have.
  ///
  /// Example:
  /// ```dart
  /// final source = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
  /// final matrix = Matrix.fromFlattenedList(source, 3, 5);
  /// print(matrix);
  /// // Output:
  /// // 1 2 3 4 5
  /// // 6 7 8 9 0
  /// // 0 0 0 0 0
  /// ```
  factory Matrix.fromFlattenedList(List<dynamic> source, int rows, int cols) {
    int sourceIndex = 0;
    List<List<dynamic>> data = List.generate(
        rows,
        (_) => List.generate(cols,
            (_) => sourceIndex < source.length ? source[sourceIndex++] : 0));

    return Matrix(data);
  }

  /// Constructs a Matrix from a list of Column vectors.
  ///
  /// All columns must have the same number of rows. Otherwise, an exception will be thrown.
  ///
  /// Example:
  /// ```dart
  /// var col1 = Column([1, 2, 3]);
  /// var col2 = Column([4, 5, 6]);
  /// var col3 = Column([7, 8, 9]);
  /// var matrix = Matrix.fromColumns([col1, col2, col3]);
  /// print(matrix);
  /// ```
  ///
  /// Output:
  /// ```
  /// 1 4 7
  /// 2 5 8
  /// 3 6 9
  /// ```
  factory Matrix.fromColumns(List<Column> columns, {bool resize = false}) {
    final numRows = columns[0].rowCount;
    for (Column col in columns) {
      if (col.rowCount != numRows) {
        throw Exception('All columns must have the same number of rows');
      }
    }

    List<List<dynamic>> data =
        List.generate(numRows, (i) => List.filled(columns.length, 0));
    for (int j = 0; j < columns.length; j++) {
      for (int i = 0; i < numRows; i++) {
        data[i][j] = columns[j].getValueAt(i);
      }
    }
    return Matrix(data);

    // List<List<dynamic>> data =
    //     columns.map((col) => col.columns.first.flatten).toList();
    // return Matrix(data).transpose();

    //return Matrix.concatenate(columns, axis: 1, resize: resize);
  }

  /// Constructs a Matrix from a list of Row vectors.
  ///
  /// All rows must have the same number of columns. Otherwise, an exception will be thrown.
  ///
  /// Example:
  /// ```dart
  /// var row1 = Row([1, 2, 3]);
  /// var row2 = Row([4, 5, 6]);
  /// var row3 = Row([7, 8, 9]);
  /// var matrix = Matrix.fromRows([row1, row2, row3]);
  /// print(matrix);
  /// ```
  ///
  /// Output:
  /// ```
  /// 1 2 3
  /// 4 5 6
  /// 7 8 9
  /// ```
  factory Matrix.fromRows(List<Row> rows, {bool resize = false}) {
    final numCols = rows[0].columnCount;
    for (Row row in rows) {
      if (row.columnCount != numCols) {
        throw Exception('All rows must have the same number of columns');
      }
    }

    return Matrix(rows.map((row) => row.rows.first).toList());
    //return Matrix.concatenate(rows, axis: 0, resize: resize);
  }

  /// Concatenates a list of matrices along the specified axis.
  ///
  /// The `matrices` list must contain at least one matrix. If `resize` is true,
  /// the matrices will be resized to match the size of the largest matrix along
  /// the axis of concatenation. If `resize` is false, the matrices must have the
  /// same size along the axis of concatenation, otherwise an exception will be thrown.
  ///
  /// The `axis` parameter determines the axis along which the matrices will be concatenated.
  /// If `axis` is 0, the matrices will be concatenated vertically (i.e., one below the other).
  /// If `axis` is 1, the matrices will be concatenated horizontally (i.e., one next to the other).
  ///
  /// Example:
  /// ```dart
  /// var matrix1 = Matrix([[1, 2], [3, 4]]);
  /// var matrix2 = Matrix([[5, 6], [7, 8]]);
  /// var concatenated = Matrix.concatenate([matrix1, matrix2], axis: 0);
  /// print(concatenated);
  /// ```
  ///
  /// Output:
  /// ```dart
  /// 1 2
  /// 3 4
  /// 5 6
  /// 7 8
  /// ```
  factory Matrix.concatenate(List<Matrix> matrices,
      {int axis = 0, bool resize = false}) {
    if (matrices.isEmpty) {
      throw Exception("Matrices list cannot be null or empty");
    }

    if (axis != 0 && axis != 1) {
      throw Exception("Invalid axis: Axis must be either 0 or 1");
    }

    Matrix first = matrices[0];
    int commonSize = (axis == 0 ? first.columnCount : first.rowCount);

    if (!resize) {
      for (var matrix in matrices) {
        if ((axis == 0 && matrix.columnCount != commonSize) ||
            (axis == 1 && matrix.rowCount != commonSize)) {
          throw Exception("Incompatible matrices for concatenation");
        }
      }
    }

    if (axis == 0) {
      List<List<dynamic>> data = [];
      for (Matrix matrix in matrices) {
        if (resize) {
          // Copy and resize rows
          for (List<dynamic> row in matrix) {
            data.add(row + List<dynamic>.filled(commonSize - row.length, 0));
          }
        } else {
          // Directly concatenate original rows
          data.addAll(matrix);
        }
      }
      return Matrix(data);
    } else {
      // axis == 1
      int maxRows = matrices.map((matrix) => matrix.rowCount).reduce(math.max);
      List<List<dynamic>> data = List.generate(maxRows, (_) => []);
      for (Matrix matrix in matrices) {
        for (int i = 0; i < maxRows; i++) {
          if (i < matrix.rowCount) {
            if (resize) {
              // Copy and resize row
              data[i] += matrix[i] +
                  List<dynamic>.filled(commonSize - matrix[i].length, 0);
            } else {
              // Directly concatenate original row
              data[i] += matrix[i];
            }
          } else {
            // Add padding row
            data[i] += List<dynamic>.filled(commonSize, 0);
          }
        }
      }
      return Matrix(data);
    }
  }

  /// Creates a matrix with random elements of type double or int.
  ///
  /// [rowCount]: The number of rows in the matrix.
  /// [columnCount]: The number of columns in the matrix.
  /// [min]: The minimum value for the random elements (inclusive). Default is 0.
  /// [max]: The maximum value for the random elements (exclusive). Default is 1.
  /// [isDouble]: If true, generates random doubles. If false, generates random integers. Default is true.
  /// [random]: A `Random` object to generate random numbers. If not provided, a new `Random` object will be created.
  /// [seed]: An optional seed for the random number generator for reproducible randomness. If not provided, the randomness is not reproducible.
  ///
  /// Example:
  /// ```dart
  /// var randomMatrix = Matrix.random(3, 4, min: 1, max: 10, isDouble: false);
  /// print(randomMatrix);
  /// // Output:
  /// // Matrix: 3x4
  /// // ┌ 3  5  9  2 ┐
  /// // │ 1  7  6  8 │
  /// // └ 4  9  1  3 ┘
  /// ```
  factory Matrix.random(int rowCount, int columnCount,
      {double min = 0,
      double max = 1,
      bool isDouble = true,
      math.Random? random,
      int? seed}) {
    return Matrix.factory.create(MatrixType.general, rowCount, columnCount,
        min: min, max: max, random: random, seed: seed, isDouble: isDouble);
  }

  /// Creates a Matrix of the specified dimensions with all elements set to 0.
  ///
  /// [rows]: Number of rows.
  /// [cols]: Number of columns.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix.zeros(2, 3);
  /// print(m);
  /// // Output:
  /// // Matrix: 2x3
  /// // ┌ 0 0 0 ┐
  /// // └ 0 0 0 ┘
  /// ```
  factory Matrix.zeros(int rows, int cols, {bool isDouble = false}) {
    return Matrix.factory
        .create(MatrixType.zeros, rows, cols, isDouble: isDouble);
  }

  /// Creates a Matrix of the specified dimensions with all elements set to 1.
  ///
  /// [rows]: Number of rows.
  /// [cols]: Number of columns.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix.ones(2, 3);
  /// print(m);
  /// // Output:
  /// // Matrix: 2x3
  /// // ┌ 1 1 1 ┐
  /// // └ 1 1 1 ┘
  /// ```
  factory Matrix.ones(int rows, int cols, {bool isDouble = false}) {
    return Matrix.factory
        .create(MatrixType.ones, rows, cols, isDouble: isDouble);
  }

  /// Creates a square identity Matrix of the specified size.
  ///
  /// [size]: Number of rows and columns.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix.eye(3);
  /// print(m);
  /// // Output:
  /// // Matrix: 3x3
  /// // ┌ 1 0 0 ┐
  /// // │ 0 1 0 │
  /// // └ 0 0 1 ┘
  /// ```
  // Method to create an identity matrix.
  factory Matrix.eye(int size, {bool isDouble = false}) {
    return Matrix.factory
        .create(MatrixType.identity, size, size, isDouble: isDouble);
  }

  /// Method to create a scalar matrix.
  /// Example:
  /// ```dart
  /// var m = Matrix.scalar(3);
  /// print(m);
  /// // Output:
  /// // Matrix: 3x3
  /// // ┌ 3 0 0 ┐
  /// // │ 0 3 0 │
  /// // └ 0 0 3 ┘
  /// ```
  factory Matrix.scalar(int size, dynamic value) {
    if (value is! num) {
      throw ArgumentError('Value must be a number (int or double)');
    }

    return Matrix.factory.create(MatrixType.identity, size, size,
        value: value, isDouble: value is double);
  }

  /// Creates a Matrix of the specified dimensions with all elements set to the specified value.
  ///
  /// [rows]: Number of rows.
  /// [cols]: Number of columns.
  /// [value]: Value to fill the matrix with.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix.fill(2, 3, 7);
  /// print(m);
  /// // Output:
  /// // Matrix: 2x3
  /// // ┌ 7 7 7 ┐
  /// // └ 7 7 7 ┘
  /// ```
  factory Matrix.fill(int rows, int cols, dynamic value) {
    return Matrix.factory.create(MatrixType.general, rows, cols,
        value: value, isDouble: value is double);
  }

  /// Creates a row Matrix with equally spaced values between the start and end values (inclusive).
  ///
  /// [start]: Start value.
  /// [end]: End value.
  /// [number]: Number of equally spaced points. Default is 50.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix.linespace(0, 10, 3);
  /// print(m);
  /// // Output:
  /// // Matrix: 1x3
  /// // [ 0 5 10 ]
  /// ```
  factory Matrix.linspace(int start, int end, [int number = 50]) {
    if (start.runtimeType != end.runtimeType) {
      throw Exception('Start and end must be of the same type');
    }

    if (number <= 0) {
      throw Exception('Number must be a positive integer');
    }

    List<List<dynamic>> data = [];

    double step = (end - start) / (number - 1);
    List<dynamic> row = [];
    for (int i = 0; i < number; i++) {
      row.add(start + i * step);
    }
    data.add(row);

    return Matrix(data);
  }

  /// Creates a Matrix with values in the specified range, incremented by the specified step size.
  ///
  /// [end]: End value (exclusive).
  /// [start]: Start value. Default is 1.
  /// [steps]: Step size. Default is 1.
  /// [isColumn]: If true, creates a column matrix. Default is false (creates a row matrix).
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix.range(6,  start: 1, step: 2, isColumn: true);
  /// print(m);
  /// // Output:
  /// // Matrix: 3x1
  /// // ┌ 1 ┐
  /// // | 3 |
  /// // └ 5 ┘
  /// ```
  factory Matrix.range(int end,
      {int start = 1, int step = 1, bool isColumn = false}) {
    if (start >= end) {
      throw Exception('Start must be less than end');
    }

    if (step <= 0) {
      throw Exception('Step must be a positive integer');
    }

    List<dynamic> range = [];
    for (int i = start; i < end; i += step) {
      range.add(i);
    }

    if (isColumn) {
      return Matrix(range.map((x) => [x]).toList());
    } else {
      return Matrix([range]);
    }
  }

  /// Alias for Matrix.range.
  factory Matrix.arrange(int end,
      {int start = 1, int step = 1, bool isColumn = false}) {
    return Matrix.range(end, start: start, step: step, isColumn: isColumn);
  }

  /// Computes the distance between two matrices.
  ///
  /// The method supports several types of matrix distances, defined by the `MatrixDistanceType` enum.
  /// These include:
  /// - Frobenius: The square root of the sum of the absolute squares of its elements, often used when matrices have the same dimensions.
  /// - Manhattan: The sum of the absolute values of its elements.
  /// - Chebyshev: The maximum absolute row or column sum norm.
  /// - Spectral: The largest singular value of the matrix, i.e., the square root of the largest eigenvalue of the matrix's hermitian transpose multiplied by the matrix.
  /// - Trace: The sum of the absolute values of eigenvalues (also equals to the sum of absolute values of singular values).
  ///
  /// The distance is computed as the norm of the difference between the two matrices, `m1` and `m2`.
  ///
  /// [m1]: The first matrix.
  /// [m2]: The second matrix.
  /// [distanceType]: The type of matrix distance to compute. Default is `DistanceType.frobenius`.
  ///
  /// Throws an `Exception` if an invalid distance type is provided.
  ///
  /// Example:
  /// ```dart
  /// var m1 = Matrix([[1, 2], [3, 4]]);
  /// var m2 = Matrix([[5, 6], [7, 8]]);
  /// print(Matrix.distance(m1, m2, distanceType: DistanceType.frobenius));
  /// // Output: 8.0
  /// ```
  ///
  /// Returns the computed distance between `m1` and `m2` according to `distanceType`.
  static num distance(Matrix m1, Matrix m2,
      {Distance distance = Distance.frobenius}) {
    switch (distance) {
      case Distance.frobenius:
        return (m1 - m2).norm();
      case Distance.manhattan:
        return (m1 - m2).norm(Norm.manhattan);
      case Distance.chebyshev:
        return (m1 - m2).norm(Norm.chebyshev);
      case Distance.spectral:
        return (m1 - m2).norm(Norm.spectral);
      case Distance.trace:
        return (m1 - m2).norm(Norm.trace);
      case Distance.cosine:
      // // Flatten the matrices and compute cosine distance
      // return Vector.fromList(_Utils.toSDList(m1.flatten())).distance(
      //     Vector.fromList(_Utils.toSDList(m2.flatten())),
      //     distanceType: DistanceType.cosine);
      case Distance.hamming:
      // // Flatten the matrices and compute hamming distance
      // return Vector.fromList(_Utils.toSDList(m1.flatten())).distance(
      //     Vector.fromList(_Utils.toSDList(m2.flatten())),
      //     distanceType: DistanceType.hamming);
      default:
        throw Exception('Invalid distance type');
    }
  }

  /// Compares each element of the matrix to the specified value using the given comparison operator.
  /// Returns a new Matrix with boolean values as a result of the comparison.
  ///
  /// [matrix]: The input Matrix to perform the comparison on.
  /// [operator]: A string representing the comparison operator ('>', '<', '>=', '<=', '==', '!=', '~=').
  /// Also performs a comparison on the element type ('is' and 'is!')
  /// [value]: The value to compare each element to.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2], [3, 4]]);
  /// var result = Matrix.compare(m, '>', 2);
  /// print(result);
  /// // Output:
  /// // Matrix: 2x2
  /// // ┌ false false ┐
  /// // └ true true   ┘
  /// ```
  static Matrix compare(Matrix matrix, String operator, dynamic value,
      {double tolerance = 1e-6}) {
    _Utils.defaultTolerance = tolerance;

    if (!_Utils.comparisonFunctions.containsKey(operator)) {
      throw Exception('Invalid operator');
    }

    var compareFunc = _Utils.comparisonFunctions[operator];

    var result = matrix
        .map((row) => row.map((item) => compareFunc!(item, value)).toList())
        .toList();

    return Matrix(result);
  }

  /// Returns the row at the specified index as a Row object.
  ///
  /// [index]: Index of the row.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2], [3, 4]]);
  /// var row = m.row(1);
  /// print(row);
  /// // Output:
  /// // Matrix: 1x2
  /// // [ 3 4 ]
  /// ```
  Row row(int index) => Row(_data[index]);

  /// Returns the column at the specified index as a Column object.
  ///
  /// [index]: Index of the column.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2], [3, 4]]);
  /// var col = m.column(1);
  /// print(col);
  /// // Output:
  /// // Matrix: 2x1
  /// // ┌ 2 ┐
  /// // └ 4 ┘
  /// ```
  Column column(int index) => Column(_data.map((row) => row[index]).toList());

  /// Extracts the diagonal elements from the matrix based on the given offset.
  ///
  /// The function accepts an optional integer parameter `k` which represents the
  /// offset from the leading diagonal. A positive value of `k` extracts the
  /// super-diagonal elements, while a negative value extracts the sub-diagonal
  /// elements.
  ///
  /// Example:
  /// ```dart
  /// var A = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  ///
  /// var mainDiagonal = A.diagonal(); // [1, 5, 9]
  /// var subDiagonal = A.diagonal(k: -1); // [4, 8]
  /// var superDiagonal = A.diagonal(k: 1); // [2, 6]
  /// ```
  List<dynamic> diagonal({int k = 0}) {
    List<dynamic> diagonal = [];
    int n = _data.length;

    if (k > 0) {
      for (int i = 0; i < n - k; i++) {
        diagonal.add(_data[i][i + k]);
      }
    } else if (k < 0) {
      for (int i = 0; i < n + k; i++) {
        diagonal.add(_data[i - k][i]);
      }
    } else {
      for (int i = 0; i < n; i++) {
        diagonal.add(_data[i][i]);
      }
    }

    return diagonal;
  }

  /// Returns the indices of occurrences of the specified element in the matrix.
  /// If [findAll] is set to true, returns a List<List<int>> of all indices where the element was found.
  /// If [findAll] is false or not provided, returns a List<int> of the first occurrence.
  /// Returns null if the element is not found.
  ///
  /// [element]: The element to search for in the matrix.
  /// [findAll]: Whether to find all occurrences of the element.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2, 1], [3, 1, 4], [1, 5, 6]]);
  /// var singleIndex = m.indicesOf(1);
  /// print(singleIndex);
  /// // Output: [0, 0]
  /// var allIndices = m.indicesOf(1, findAll: true);
  /// print(allIndices);
  /// // Output: [[0, 0], [0, 2], [1, 1], [2, 0]]
  /// ```
  dynamic indexOf(dynamic element, {bool findAll = false}) {
    List<List<int>> allIndices = [];

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < _data[i].length; j++) {
        if (_data[i][j] == element) {
          if (!findAll) {
            return [i, j];
          }
          allIndices.add([i, j]);
        }
      }
    }

    if (findAll) {
      return allIndices.isNotEmpty ? allIndices : null;
    }

    return null;
  }

  /// Compares two matrices for equality. Returns true if the matrices have the same dimensions and all elements are equal, otherwise false.
  ///
  /// [other]: The other Matrix object to compare.
  ///
  /// Example:
  /// ```dart
  /// var m1 = Matrix([[1, 2], [3, 4]]);
  /// var m2 = Matrix([[1, 2], [3, 4]]);
  /// print(m1 == m2); // Output: true
  /// ```
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Matrix otherMatrix = other as Matrix;
    if (rowCount != otherMatrix.rowCount ||
        columnCount != otherMatrix.columnCount) {
      return false;
    }
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (_data[i][j] != otherMatrix[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  // @override  //performance optimization
  // int get hashCode {
  //   const int numberOfElements = 10;
  //   int rowStride = rowCount < numberOfElements ? 1 : rowCount ~/ numberOfElements;
  //   int colStride = columnCount < numberOfElements ? 1 : columnCount ~/ numberOfElements;
  //   int result = 17;
  //   for (int i = 0; i < rowCount; i += rowStride) {
  //     for (int j = 0; j < columnCount; j += colStride) {
  //       result = result * 31 + this[i, j].hashCode;
  //     }
  //   }
  //   result = result * 31 + rowCount.hashCode;   // Include rowCount in hash computation
  //   result = result * 31 + columnCount.hashCode; // Include columnCount in hash computation
  //   return result;
  // }

  @override
  int get hashCode {
    int result = 17;
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result = 37 * result + _data[i][j].hashCode;
      }
    }
    return result;
  }

  /// Returns a string representation of the matrix with its shape and elements separated by the specified separator.
  ///
  /// [separator]: A string used to separate matrix elements in a row. Default is a space character (' ').
  /// [alignment]: An enum indicating the alignment of the elements in each column. Default is MatrixAlign.right.
  /// [isPrettyMatrix]: A bool indicating the output matrix string should have square around it. Default is true.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2], [3, 4]]);
  /// print(m.toString(separator: ' ', isPrettyMatrix : true, alignment: MatrixAlign.right));
  /// // Output:
  /// // Matrix: 2x2
  /// // ┌ 1 2 ┐
  /// // └ 3 4 ┘
  /// ```
  @override
  String toString(
      {String separator = ' ',
      bool isPrettyMatrix = true,
      MatrixAlign alignment = MatrixAlign.right}) {
    return _Utils.matString(this,
        separator: separator,
        isPrettyMatrix: isPrettyMatrix,
        alignment: alignment);
  }

  /// Print a string representation of the matrix with its shape and elements separated by the specified separator.
  ///
  /// [separator]: A string used to separate matrix elements in a row. Default is a space character (' ').
  /// [alignment]: An enum indicating the alignment of the elements in each column. Default is MatrixAlign.right.
  /// [isPrettyMatrix]: A bool indicating the output matrix string should have square around it. Default is true.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2], [3, 4]]);
  /// print(m.toString(separator: ' ', alignment: 'right'));
  /// // Output:
  /// // Matrix: 2x2
  /// // ┌ 1 2 ┐
  /// // └ 3 4 ┘
  /// ```
  void prettyPrint(
      {String separator = ' ',
      bool isPrettyMatrix = true,
      MatrixAlign alignment = MatrixAlign.right}) {
    print(_Utils.matString(this,
        separator: separator,
        isPrettyMatrix: isPrettyMatrix,
        alignment: alignment));
  }
}

class _MatrixIterable extends IterableBase<List<dynamic>> {
  final Matrix _matrix;
  final bool _columnMajor;

  _MatrixIterable(this._matrix, {columnMajor = false})
      : _columnMajor = columnMajor;

  @override
  Iterator<List<dynamic>> get iterator =>
      MatrixIterator(_matrix, columnMajor: _columnMajor);
}

class _MatrixElementIterable extends IterableBase<dynamic> {
  final Matrix _matrix;

  _MatrixElementIterable(this._matrix);

  @override
  Iterator<dynamic> get iterator => MatrixElementIterator(_matrix);
}
