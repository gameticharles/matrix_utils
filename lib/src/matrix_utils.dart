part of matrix_utils;

//class Matrix implements Iterable<List<dynamic>> {
class Matrix extends IterableMixin<List<dynamic>> {
  List<List<dynamic>> _data = const [];

  Iterable<List<dynamic>> get rows => _MatrixIterable(this, columnMajor: false);
  Iterable<List<dynamic>> get columns =>
      _MatrixIterable(this, columnMajor: true);

  Iterable<dynamic> get elements => _MatrixElementIterable(this);

  MatrixDecomposition get decomposition {
    return MatrixDecomposition(this);
  }

  LinearAlgebra get linear {
    return LinearAlgebra(this);
  }

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

      _data = input;

      int length = _data[0].length;
      for (var row in _data) {
        if (row.length != length) {
          throw Exception('Rows have different lengths');
        }
      }
    } else {
      throw Exception('Invalid input type');
    }
  }

  /// Converts the current Matrix object to an Array2D from SciDart library.
  Array2d toArray2D() {
    List<Array> array2DData = _data
        .map((row) => Array(row.map((e) => (e as num).toDouble()).toList()))
        .toList();
    return Array2d(array2DData);
  }

  /// Creates a Matrix object from a SciDart Array2D.
  ///
  /// Example:
  ///
  /// Array2d array2d = Array2d([
  ///   Array([4, 5, 6, 7]),
  ///   Array([9, 9, 8, 6]),
  ///   Array([1, 1, 2, 9])
  /// ]);
  ///
  /// Matrix mat = Matrix.fromArray2D(array2d);
  /// print(mat);
  ///
  /// Output:
  /// Matrix: 3x4
  /// ┌ 4 5 6 7 ┐
  /// │ 9 9 8 6 │
  /// └ 1 1 2 9 ┘
  static Matrix fromArray2D(Array2d array2d) {
    List<List<dynamic>> matrixData =
        array2d.map((array) => array.toList()).toList();
    return Matrix.fromList(matrixData);
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

  /// Creates a tridiagonal matrix with the given size and diagonal values.
  ///
  /// `n` is the size of the square matrix.
  /// `a` is the value to fill the first (upper) diagonal.
  /// `b` is the value to fill the second (main) diagonal.
  /// `c` is the value to fill the third (lower) diagonal.
  ///
  /// Returns a [Matrix] with the specified tridiagonal structure.
  ///
  /// Example:
  ///
  /// ```dart
  /// int n = 10;
  /// double a = -4;
  /// double b = 1;
  /// double c = 2;
  ///
  /// Matrix A = Matrix.tridiagonal(n, a, b, c);
  /// ```
  factory Matrix.tridiagonal(int n, double a, double b, double c) {
    List<List<double>> data =
        List.generate(n, (_) => List<double>.filled(n, 0));

    for (int i = 0; i < n; i++) {
      if (i - 1 >= 0) {
        data[i][i - 1] = a;
      }
      data[i][i] = b;
      if (i + 1 < n) {
        data[i][i + 1] = c;
      }
    }

    return Matrix.fromList(data);
  }

  /// Creates a matrix with random elements of type double or int.
  ///
  /// [rowCount]: The number of rows in the matrix.
  /// [columnCount]: The number of columns in the matrix.
  /// [min]: The minimum value for the random elements (inclusive). Default is 0.
  /// [max]: The maximum value for the random elements (exclusive). Default is 1.
  /// [isInt]: If true, generates random integers. If false, generates random doubles. Default is false.
  /// [random]: A `Random` object to generate random numbers. If not provided, a new `Random` object will be created.
  ///
  /// Example:
  /// ```dart
  /// var randomMatrix = Matrix.random(3, 4, min: 1, max: 10, isInt: true);
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
      bool isInt = false,
      math.Random? random}) {
    random ??= math.Random();
    List<List<dynamic>> data;

    if (isInt) {
      int intMin = min.toInt();
      int intMax = max.toInt();
      data = List.generate(
          rowCount,
          (_) => List.generate(
              columnCount, (_) => random!.nextInt(intMax - intMin) + intMin));
    } else {
      data = List.generate(
          rowCount,
          (_) => List.generate(
              columnCount, (_) => random!.nextDouble() * (max - min) + min));
    }

    return Matrix(data);
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
    if (rows <= 0 || cols <= 0) {
      throw Exception('Rows and columns must be greater than 0');
    }

    List<List<dynamic>> newData = [];

    for (int i = 0; i < rows; i++) {
      List<dynamic> row = [];
      for (int j = 0; j < cols; j++) {
        row.add(isDouble ? 0.0 : 0);
      }
      newData.add(row);
    }

    return Matrix(newData);
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
    if (rows <= 0 || cols <= 0) {
      throw Exception('Rows and columns must be greater than 0');
    }

    List<List<dynamic>> newData = [];

    for (int i = 0; i < rows; i++) {
      List<dynamic> row = [];
      for (int j = 0; j < cols; j++) {
        row.add(isDouble ? 1.0 : 1);
      }
      newData.add(row);
    }

    return Matrix(newData);
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
  factory Matrix.eye(int size, {bool isDouble = false}) {
    if (size <= 0) {
      throw Exception('Size must be a positive integer');
    }

    List<List<dynamic>> newData = [];

    for (int i = 0; i < size; i++) {
      List<dynamic> row = [];
      for (int j = 0; j < size; j++) {
        if (i == j) {
          row.add(isDouble ? 1.0 : 1);
        } else {
          row.add(isDouble ? 0.0 : 0);
        }
      }
      newData.add(row);
    }

    return Matrix(newData);
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
    if (rows < 1 || cols < 1) {
      throw Exception("Rows and columns must be greater than 0");
    }
    List<List<dynamic>> newData = [];

    for (int i = 0; i < rows; i++) {
      List<dynamic> row = [];
      for (int j = 0; j < cols; j++) {
        row.add(value);
      }
      newData.add(row);
    }

    return Matrix(newData);
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

  /// Compares each element of the matrix to the specified value using the given comparison operator.
  /// Returns a new Matrix with boolean values as a result of the comparison.
  ///
  /// [matrix]: The input Matrix to perform the comparison on.
  /// [operator]: A string representing the comparison operator ('>', '<', '>=', '<=', '==', '!=').
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
  static Matrix compare(Matrix matrix, String operator, num value) {
    List<List<bool>> result = [];

    for (int i = 0; i < matrix.rowCount; i++) {
      List<bool> row = [];
      for (int j = 0; j < matrix.columnCount; j++) {
        switch (operator) {
          case '>':
            row.add(matrix._data[i][j] > value);
            break;
          case '<':
            row.add(matrix._data[i][j] < value);
            break;
          case '>=':
            row.add(matrix._data[i][j] >= value);
            break;
          case '<=':
            row.add(matrix._data[i][j] <= value);
            break;
          case '==':
            row.add(matrix._data[i][j] == value);
            break;
          case '!=':
            row.add(matrix._data[i][j] != value);
            break;
          default:
            throw Exception('Invalid operator');
        }
      }
      result.add(row);
    }

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
  /// // Output: 3 4
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
  /// // 2
  /// // 4
  /// ```
  Column column(int index) => Column(_Utils.getColumn(this, index));

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

  /// Returns the indices of the first occurrence of the specified element in the matrix as a List<int>.
  /// Returns null if the element is not found.
  ///
  /// [element]: The element to search for in the matrix.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2], [3, 4]]);
  /// var index = m.indexOf(3);
  /// print(index);
  /// // Output: [1, 0]
  /// ```
  List<int>? indexOf(dynamic element) {
    for (int i = 0; i < rowCount; i++) {
      int index = _data[i].indexOf(element);
      if (index != -1) {
        return [i, index];
      }
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
  /// [alignment]: A string indicating the alignment of the elements in each column. Default is 'right'.
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
  @override
  String toString(
      {String separator = ' ',
      bool isPrettyMatrix = true,
      String alignment = 'right'}) {
    return _Utils.matString(this,
        separator: separator,
        isPrettyMatrix: isPrettyMatrix,
        alignment: alignment);
  }

  /// Print a string representation of the matrix with its shape and elements separated by the specified separator.
  ///
  /// [separator]: A string used to separate matrix elements in a row. Default is a space character (' ').
  /// [alignment]: A string indicating the alignment of the elements in each column. Default is 'right'.
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
      String alignment = 'right'}) {
    print(_Utils.matString(this,
        separator: separator,
        isPrettyMatrix: isPrettyMatrix,
        alignment: alignment));
  }

  /// Returns a List<List<dynamic>> representation of the matrix.
  @override
  List<List> toList({bool growable = true}) {
    return _data;
  }

  /// Returns a new Matrix where each element is the result of applying the provided function [f] to the corresponding element in the original matrix.
  ///
  /// [f]: A function that takes a single argument and returns a single value.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2], [3, 4]]);
  /// var doubled = m.map((x) => x * 2);
  /// print(doubled);
  /// // Output:
  /// // 2 4
  /// // 6 8
  /// ```
  // @override
  // Iterable<T> map<T>(T Function(List e) f) {
  //   List<List<dynamic>> newData =
  //       _data.map((row) => row.map((i) => f(i)).toList()).toList();
  //   return Iterable.castFrom(newData);
  // }

  /// Executes the provided function [f] for each element in the matrix.
  ///
  /// [f]: A function that takes a single argument and performs an action.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2], [3, 4]]);
  /// m.forEach((x) => print(x));
  /// // Output:
  /// // 1
  /// // 2
  /// // 3
  /// // 4
  /// ```
//   @override
//   void forEach(void Function(List element) action) {
//     for (var row in _data) {
//       for (var element in row) {
//         action(element);
//       }
//     }
//   }
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
