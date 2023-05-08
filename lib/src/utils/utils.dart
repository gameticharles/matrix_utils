part of matrix_utils;

/* TODO:


Performance Optimizations:
   - Implement parallel processing techniques to improve the performance of computationally intensive operations (e.g., matrix multiplication, decompositions)
   - Optimize existing methods using efficient algorithms or data structures

*/

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
  static List<List<double>> toDoubleList(List<List<dynamic>> input) {
    return input
        .map((row) => row.map((value) => (value as num).toDouble()).toList())
        .toList();
  }

  /// Convert a dynamic matrix to double matrix
  static Matrix toDoubleMatrix(Matrix input) {
    return Matrix(toDoubleList(input._data));
  }

  ///Convert a dynamic list to double list
  static List<double> toSDList(List<dynamic> list) {
    return list.map((e) {
      if (e is num) {
        return e.toDouble();
      } else {
        throw ArgumentError('List element is not of type num');
      }
    }).toList();
  }

  // Helper method for computing bidiagonalize.
  static Bidiagonalization bidiagonalize(Matrix A) {
    int m = A.rowCount;
    int n = A.columnCount;

    Matrix U = Matrix.eye(m);
    Matrix B = A.copy();
    Matrix V = Matrix.eye(n);

    for (int k = 0; k < math.min(m - 1, n); k++) {
      // Compute Householder reflection for the k-th column of B
      var columnVector = B.subMatrix(k, m - 1, k, k);

      Matrix Pk = _Utils.householderReflection(columnVector);
      Matrix P = Matrix.eye(m);
      P.setSubMatrix(k, k, Pk);

      // Update B and U
      B = P * B;
      U = U * P;

      if (k < n - 1) {
        // Compute Householder reflection for the k-th row of B
        var rowVector = Column(B.subMatrix(k, k, k, n - 1).flatten());

        Matrix Qk = _Utils.householderReflection(rowVector);
        Matrix Q = Matrix.eye(n);

        Q.setSubMatrix(k, k, Qk);

        // Update B and V
        B = B * Q;
        V = V * Q;
      }
    }

    return Bidiagonalization(U, B, V);
  }

  // Helper method for QR Iteration on bidiagonal matrix B.
  static SingularValueDecomposition qrIterationOnBidiagonal(Matrix B) {
    int m = B.rowCount;
    int n = B.columnCount;

    Matrix U = Matrix.eye(m);
    Matrix V = Matrix.eye(n);

    double eps = 1e-10;
    int maxIterations = 1000;

    for (int iteration = 0; iteration < maxIterations; iteration++) {
      bool converged = true;

      for (int k = 0; k < n - 1; k++) {
        if (B[k + 1][k].abs() > eps * (B[k][k].abs() + B[k + 1][k + 1].abs())) {
          converged = false;

          // Perform QR iteration on submatrix (B[k:n, k:n])
          Matrix subB = B.subMatrix(k, n - 1, k, n - 1);
          QRDecomposition subQR =
              subB.decomposition.qrDecompositionGramSchmidt();
          Matrix subQ = subQR.Q;
          Matrix subR = subQR.R;

          // Update B, U, and V
          B.setSubMatrix(k, k, subR * subQ);
          // multiplySubMatrix(U, k, m - 1, k, n - 1, subQ);
          // multiplySubMatrix(V, k, n - 1, k, n - 1, subQ);

          U.setSubMatrix(k, k, U.subMatrix(k, m - 1, k, n - 1) * subQ);
          V.setSubMatrix(k, k, V.subMatrix(k, n - 1, k, n - 1) * subQ);
        }
      }

      if (converged) {
        break;
      }
    }

    // Extract singular values and singular vectors
    Matrix S = Diagonal(B.diagonal());
    Matrix uSvd = U.subMatrix(0, m - 1, 0, n - 1);
    Matrix vSvd = V;

    return SingularValueDecomposition(uSvd, S, vSvd);
  }

  static void multiplySubMatrix(Matrix A, int rowStart, int rowEnd,
      int colStart, int colEnd, Matrix other) {
    Matrix subMatrix = A.subMatrix(rowStart, rowEnd, colStart, colEnd);
    Matrix product = subMatrix * other;
    A.setSubMatrix(rowStart, colStart, product);
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

  // Column norm helper function
  static double columnNorm(List<dynamic> column) {
    return math.sqrt(column.map((e) {
      var r = (e as num).toDouble();
      return r * r;
    }).reduce((sum, e) => sum + e));
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

  // Helper function to get the sum
  static double sumLUk(Matrix L, Matrix U, int k, int row, int col) {
    double sum = 0;
    for (int p = 0; p < k; p++) {
      sum += L[row][p] * U[p][col];
    }
    return sum;
  }

  static int getFirstNonZeroIndex(List<dynamic> row) {
    for (int i = 0; i < row.length; i++) {
      if (row[i] != 0) {
        return i;
      }
    }
    return -1;
  }

  // Project vector a onto vector b
  static List<double> project(List<double> a, List<double> b) {
    double scaleFactor = vectorDotProduct(a, b) / vectorDotProduct(b, b);
    return vectorScale(b, scaleFactor);
  }

  // Subtract vector b from vector a
  static List<double> vectorSubtract(List<double> a, List<double> b) {
    return List.generate(a.length, (i) => a[i] - b[i]);
  }

  // Scale vector a by scalar b
  static List<double> vectorScale(List<double> a, double b) {
    return a.map((e) => e * b).toList();
  }

  // 2. Compute the Householder reflection of a matrix
  // static Matrix householderReflection(List<double> v) {
  //   int n = v.length;
  //   Matrix I = Matrix.eye(n);
  //   Matrix vvT =
  //       Matrix.fromList(v.map((e) => [e]).toList()) * Matrix.fromList([v]);
  //   Matrix P = I - (vvT * (2.0 / vectorDotProduct(v, v)));
  //   return P;
  // }
  // Calculate the Householder reflection matrix for a given vector
  static Matrix householderReflection1(Matrix columnVector) {
    int n = columnVector.rowCount;
    Matrix e1 = Matrix.zeros(n, 1);
    e1[0][0] = 1;

    // Check if the matrix is filled with zeros and return the identity matrix if true
    if (columnVector.infinityNorm() == 0.0) {
      return Matrix.eye(n);
    }

    Matrix u =
        (columnVector + e1) * columnVector.norm2() * columnVector[0][0].sign;

    Matrix P =
        Matrix.eye(n) - ((u * u.transpose()) * (2 / math.pow(u.norm2(), 2)));

    return P;
  }

// Calculate the Householder reflection matrix for a given vector
  static Matrix householderReflection(Matrix columnVector) {
    int n = columnVector.rowCount;
    Matrix e1 = Matrix.zeros(n, 1);
    e1[0][0] = 1;

    // Check if the matrix is filled with zeros and return the identity matrix if true
    if (columnVector.infinityNorm() == 0.0) {
      return Matrix.eye(n);
    }

    Matrix u =
        (columnVector + e1) * columnVector.norm2() * columnVector[0][0].sign;

    Matrix P =
        Matrix.eye(n) - ((u * u.transpose()) * (2 / math.pow(u.norm2(), 2)));

    return P;
  }

  // 3. Compute the Givens rotation of a matrix
  static List<double> givensRotation(double a, double b) {
    double r = math.sqrt(a * a + b * b);
    double c = a / r;
    double s = -b / r;

    return [c, s];
  }

  // 4. Apply Givens rotation to a matrix
  static void applyGivensRotation(
      Matrix m, int row1, int row2, List<double> cS) {
    double c = cS[0];
    double s = cS[1];

    for (int j = 0; j < m.columnCount; j++) {
      double temp1 = m[row1][j];
      double temp2 = m[row2][j];

      m[row1][j] = c * temp1 - s * temp2;
      m[row2][j] = s * temp1 + c * temp2;
    }
  }

  // 5. Compute the dot product of two vectors
  static double vectorDotProduct(List<double> v1, List<double> v2) {
    return v1
        .asMap()
        .entries
        .map((entry) => entry.value * v2[entry.key])
        .reduce((a, b) => a + b);
  }

  // 6. Compute the norm of a vector
  static double vectorNorm(List<double> v) {
    return math.sqrt(v.map((value) => value * value).reduce((a, b) => a + b));
  }

  /// Returns a string representation of the matrix with its shape and elements separated by the specified separator.
  ///
  /// [separator]: A string used to separate matrix elements in a row. Default is a space character (' ').
  /// [alignment]: A string indicating the alignment of the elements in each column. Default is 'right'.
  /// [isPrettyMatrix]: A boolean indicating whether the matrix is pretty or not (as lists). Default is true
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2], [3, 4]]);
  /// print(m.toString(separator: ' ', isPrettyMatrix = true alignment: 'right'));
  /// // Output:
  /// // Matrix: 2x2
  /// // ┌ 1 2 ┐
  /// // └ 3 4 ┘
  /// ```
  static String matString(Matrix m,
      {String separator = ' ',
      bool isPrettyMatrix = true,
      MatrixAlign alignment = MatrixAlign.right}) {
    List<int> columnWidths = List.generate(m.columnCount, (_) => 0);
    List<String> rows = [];

    for (var row in m._data) {
      row.asMap().forEach((index, element) => columnWidths[index] =
          math.max(columnWidths[index], element.toString().length));
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

    String matToString = '';

    if (isPrettyMatrix) {
      String top = '┌ ${rows[0]} ┐';
      String middle = m.rowCount > 2
          ? rows.sublist(1, m.rowCount - 1).map((row) => '│ $row │').join('\n')
          : '';
      String bottom = '└ ${rows[m.rowCount - 1]} ┘';
      matToString =
          middle.isNotEmpty ? '$top\n$middle\n$bottom' : '$top\n$bottom';
    } else {
      String matrixRepresentation = rows.map((row) => ' [ $row ]').join('\n');
      matToString = '[\n$matrixRepresentation\n]';
    }

    return 'Matrix: ${m.rowCount}x${m.columnCount}\n$matToString';
  }
}
