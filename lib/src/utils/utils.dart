part of matrix_utils;

class _Utils {
  static List<List<dynamic>> parseMatrixString(String input) {
    return input
        .split(';')
        .map((rowString) => rowString
            .trim()
            .split(RegExp(r'\s+'))
            .map((elem) => num.parse(elem))
            .toList())
        .toList();
  }

// Helper function to parse index ranges
  static List<int> parseRange(String range, int maxIndex) {
    final rangeParts = range.split(':');
    final start = rangeParts.isNotEmpty && rangeParts[0].isNotEmpty
        ? int.parse(rangeParts[0])
        : 0;
    final end = rangeParts.length > 1 && rangeParts[1].isNotEmpty
        ? int.parse(rangeParts[1])
        : maxIndex - 1;
    return [start, end];
  }

  ///Convert the integer matrix to double type
  static List<List<num>> toDoubleMatrix(List<List<num>> input) {
    return input
        .map((row) => row.map((value) => value.toDouble()).toList())
        .toList();
  }

// Column norm helper function
  static double columnNorm(List<dynamic> column) {
    return sqrt(column.map((e) => e * e).reduce((sum, e) => sum + e));
  }

  /// Returns the column at the given [index] as a list of dynamic elements.
  ///
  /// This is a private helper function used internally in the Matrix class.
  ///
  /// Example:
  /// ```dart
  /// // Assuming a matrix instance with the following content:
  /// // [[1, 2, 3],
  /// //  [4, 5, 6],
  /// //  [7, 8, 9]]
  /// List<dynamic> column = _getColumn(1);
  /// print(column); // Output: [2, 5, 8]
  /// ```
  static List<dynamic> getColumn(Matrix m, int index) {
    List<dynamic> column = [];

    for (int i = 0; i < m.rowCount; i++) {
      column.add(m[i][index]);
    }

    return column;
  }

// Helper method for solving a linear system using backward substitution.
  static Matrix backwardSubstitution(Matrix upper, Matrix y) {
    int rowCount = upper.rowCount;
    int colCount = y.columnCount;
    Matrix x = Matrix.zeros(rowCount, colCount);

    for (int i = rowCount - 1; i >= 0; i--) {
      for (int j = 0; j < colCount; j++) {
        x[i][j] = y[i][j];
        for (int k = i + 1; k < rowCount; k++) {
          x[i][j] -= upper[i][k] * x[k][j];
        }
        x[i][j] /= upper[i][i];
      }
    }

    return x;
  }

// Helper method for solving a linear system using forward substitution.
  static Matrix forwardSubstitution(Matrix lower, Matrix b) {
    int rowCount = lower.rowCount;
    int colCount = b.columnCount;
    Matrix y = Matrix.zeros(rowCount, colCount);

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < colCount; j++) {
        y[i][j] = b[i][j];
        for (int k = 0; k < i; k++) {
          y[i][j] -= lower[i][k] * y[k][j];
        }
        y[i][j] /= lower[i][i];
      }
    }

    return y;
  }

// Helper method for forward elimination.
  static Matrix forwardElimination(Matrix a, Matrix b,
      {bool forLUDecomposition = false}) {
    int rowCount = a.rowCount;

    for (int k = 0; k < rowCount - 1; k++) {
      for (int i = k + 1; i < rowCount; i++) {
        double factor = a[i][k] / a[k][k];
        if (forLUDecomposition) {
          a[i][k] = factor;
        }
        for (int j = k + 1; j < rowCount; j++) {
          a[i][j] -= factor * a[k][j];
        }
        for (int j = 0; j < b.columnCount; j++) {
          b[i][j] -= factor * b[k][j];
        }
      }
    }

    return a;
  }

// Helper method for LU decomposition.
  static List<Matrix> luDecomposition(Matrix a) {
    int rowCount = a.rowCount;
    Matrix l = Matrix.eye(rowCount);
    Matrix u = Matrix(a.toList() as List<List<num>>);

    for (int k = 0; k < rowCount - 1; k++) {
      for (int i = k + 1; i < rowCount; i++) {
        double factor = u[i][k] / u[k][k];
        l[i][k] = factor;
        for (int j = k + 1; j < rowCount; j++) {
          u[i][j] -= factor * u[k][j];
        }
      }
    }

    return [l, u];
  }

// Helper function for matrix multiplication
  static Matrix multiply(Matrix A, Matrix B) {
    int rowsA = A.rowCount;
    int colsA = A.columnCount;
    int rowsB = B.rowCount;
    int colsB = B.columnCount;

    if (colsA != rowsB) {
      throw Exception(
          "Matrix dimensions are not compatible for multiplication");
    }

    List<List<dynamic>> result =
        List.generate(rowsA, (_) => List.filled(colsB, 0.0));

    for (int i = 0; i < rowsA; i++) {
      for (int j = 0; j < colsB; j++) {
        double sum = 0.0;
        for (int k = 0; k < colsA; k++) {
          sum += A[i][k] * B[k][j];
        }
        result[i][j] = sum;
      }
    }

    return Matrix(result);
  }

  // QR decomposition using Gram-Schmidt process
  static List<Matrix> qrDecomposition(Matrix A) {
    int m = A.rowCount;
    int n = A.columnCount;

    Matrix Q = Matrix.fill(m, n, 0.0);
    Matrix R = Matrix.fill(n, n, 0.0);

    for (int k = 0; k < n; k++) {
      List<dynamic> u = A.column(k).toList().map((e) => e).toList();

      for (int i = 0; i < k; i++) {
        R[i][k] = Q.column(i).dot(A.column(k));
        for (int j = 0; j < m; j++) {
          u[j] -= R[i][k] * Q[j][i];
        }
      }
      R[k][k] = columnNorm(u);
      for (int j = 0; j < m; j++) {
        Q[j][k] = u[j] / R[k][k];
      }
    }

    return [Q, R];
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
  static String matString(Matrix m,
      {String separator = ' ', String alignment = 'right'}) {
    List<int> columnWidths = List.generate(m.columnCount, (_) => 0);
    List<String> rows = [];

    for (var row in m._data) {
      row.asMap().forEach((index, element) => columnWidths[index] =
          max(columnWidths[index], element.toString().length));
    }

    rows = m._data
        .map((row) => row
            .asMap()
            .entries
            .map((entry) => alignment == 'left'
                ? entry.value.toString().padRight(columnWidths[entry.key])
                : entry.value.toString().padLeft(columnWidths[entry.key]))
            .join(separator))
        .toList();

    if (m.rowCount == 1) {
      return 'Matrix: ${m.rowCount}x${m.columnCount}\n[ ${rows[0]} ]';
    }

    String top = '┌ ${rows[0]} ┐';
    String middle = m.rowCount > 2
        ? rows.sublist(1, m.rowCount - 1).map((row) => '│ $row │').join('\n')
        : '';
    String bottom = '└ ${rows[m.rowCount - 1]} ┘';

    return 'Matrix: ${m.rowCount}x${m.columnCount}\n${middle.isNotEmpty ? '$top\n$middle\n$bottom' : '$top\n$bottom'}';
  }
}
