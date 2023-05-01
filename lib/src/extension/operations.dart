part of matrix_utils;

extension MatrixOperationExtension on Matrix {
  /// Adds the given matrix to this matrix element-wise.
  ///
  /// [other]: The matrix to add to this matrix.
  ///
  /// Returns a new matrix containing the result of the element-wise addition.
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[1, 2], [3, 4]]);
  /// var matrixB = Matrix([[1, 1], [1, 1]]);
  /// var matrixC = matrixA + matrixB;
  /// print(matrixC);
  /// // Output:
  /// // 2  3
  /// // 4  5
  /// ```
  Matrix operator +(dynamic other) {
    if (other is Matrix) {
      if (rowCount != other.rowCount || columnCount != other.columnCount) {
        throw Exception('Cannot add matrices of different sizes');
      }

      List<List<dynamic>> newData = List.generate(rowCount,
          (i) => List.generate(columnCount, (j) => _data[i][j] + other[i][j]));

      return Matrix(newData);
    } else if (other is num) {
      List<List<dynamic>> newData = List.generate(rowCount,
          (i) => List.generate(columnCount, (j) => _data[i][j] + other));

      return Matrix(newData);
    } else {
      throw Exception('Invalid operand type');
    }
  }

  /// Subtracts the given matrix from this matrix element-wise.
  ///
  /// [other]: The matrix to subtract from this matrix.
  ///
  /// Returns a new matrix containing the result of the element-wise subtraction.
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[3, 4], [5, 6]]);
  /// var matrixB = Matrix([[1, 1], [1, 1]]);
  /// var matrixC = matrixA - matrixB;
  /// print(matrixC);
  /// // Output:
  /// // 2  3
  /// // 4  5
  /// ```
  Matrix operator -(dynamic other) {
    if (other is Matrix) {
      if (rowCount != other.rowCount || columnCount != other.columnCount) {
        throw Exception('Cannot subtract matrices of different sizes');
      }

      List<List<dynamic>> newData = List.generate(rowCount,
          (i) => List.generate(columnCount, (j) => _data[i][j] - other[i][j]));

      return Matrix(newData);
    } else if (other is num) {
      List<List<dynamic>> newData = List.generate(rowCount,
          (i) => List.generate(columnCount, (j) => _data[i][j] - other));

      return Matrix(newData);
    } else {
      throw Exception('Invalid operand type');
    }
  }

  /// Multiplies this matrix by a scalar value.
  ///
  /// [scalar]: The scalar value to multiply this matrix by.
  ///
  /// Returns a new matrix containing the result of the scalar multiplication.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix * 2;
  /// print(result);
  /// // Output:
  /// // 2  4
  /// // 6  8
  /// ```
  Matrix operator *(dynamic other) {
    if (other is Matrix) {
      if (columnCount != other.rowCount) {
        throw Exception('Cannot multiply matrices of incompatible sizes');
      }

      List<List<dynamic>> newData =
          List.generate(rowCount, (_) => List.filled(other.columnCount, 0.0));

      for (int i = 0; i < rowCount; i++) {
        for (int j = 0; j < other.columnCount; j++) {
          for (int k = 0; k < columnCount; k++) {
            newData[i][j] += _data[i][k] * other[k][j];
          }
        }
      }

      return Matrix(newData);
    } else if (other is num) {
      int rows = rowCount;
      int cols = columnCount;

      List<List<dynamic>> newData = [];

      for (int i = 0; i < rows; i++) {
        List<dynamic> row = [];
        for (int j = 0; j < cols; j++) {
          row.add(this[i][j] * other);
        }
        newData.add(row);
      }

      return Matrix(newData);
    } else {
      throw Exception('Invalid operand type');
    }
  }

  /// Divides this matrix by a scalar value.
  ///
  /// [divisor]: The scalar value to divide this matrix by.
  ///
  /// Returns a new matrix containing the result of the scalar division.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[2, 4], [6, 8]]);
  /// var result = matrix / 2;
  /// print(result);
  /// // Output:
  /// // 1  2
  /// // 3  4
  /// ```
  Matrix operator /(dynamic other) {
    if (other is num) {
      if (other == 0) {
        throw Exception('Cannot divide by zero');
      }

      List<List<dynamic>> newData = List.generate(rowCount,
          (i) => List.generate(columnCount, (j) => _data[i][j] / other));

      return Matrix(newData);
    } else {
      throw Exception(
          'Invalid operand type, division is only supported by scalar');
    }
  }

  /// Raises this matrix to the power of the given exponent using exponentiation by squaring.
  ///
  /// [exponent]: The non-negative integer exponent to raise this matrix to.
  ///
  /// Returns a new matrix containing the result of the exponentiation.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix ^ 2;
  /// print(result);
  /// // Output:
  /// // 7   10
  /// // 15  22
  /// ```
  Matrix operator ^(int exponent) {
    if (rowCount != columnCount) {
      throw Exception('Cannot exponentiate non-square matrix');
    }

    if (exponent < 0) {
      throw Exception('Exponent must be a non-negative integer');
    }

    Matrix result = Matrix.eye(rowCount);
    Matrix base = Matrix(_data.map((row) => List<dynamic>.from(row)).toList());

    while (exponent > 0) {
      if (exponent % 2 == 1) {
        result = result.dot(base);
      }
      base = base.dot(base);
      exponent ~/= 2;
    }

    return result;
  }

  /// Negates this matrix element-wise.
  ///
  /// Returns a new matrix containing the result of the element-wise negation.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = -matrix;
  /// print(result);
  /// // Output:
  /// // -1 -2
  /// // -3 -4
  /// ```
  Matrix operator -() {
    List<List<dynamic>> newData = List.generate(
        rowCount, (i) => List.generate(columnCount, (j) => -_data[i][j]));

    return Matrix(newData);
  }

  /// Multiplies the corresponding elements of this matrix and the given matrix.
  ///
  /// [other]: The matrix to element-wise multiply with this matrix.
  ///
  /// Returns a new matrix containing the result of the element-wise multiplication.
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[1, 2], [3, 4]]);
  /// var matrixB = Matrix([[2, 2], [2, 2]]);
  /// var result = matrixA.elementMultiply(matrixB);
  /// print(result);
  /// // Output:
  /// // 2  4
  /// // 6  8
  /// ```
  Matrix elementMultiply(Matrix other) {
    return elementWise(other, (a, b) => a * b);
  }

  /// Divides the corresponding elements of this matrix by the elements of the given matrix.
  ///
  /// [other]: The matrix to element-wise divide with this matrix.
  ///
  /// Returns a new matrix containing the result of the element-wise division.
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[2, 4], [6, 8]]);
  /// var matrixB = Matrix([[1, 2], [3, 4]]);
  /// var result = matrixA.elementDivide(matrixB);
  /// print(result);
  /// // Output:
  /// // 2  2
  /// // 2  2
  /// ```
  Matrix elementDivide(Matrix other) {
    return elementWise(other, (a, b) => a / b);
  }

  /// Applies the given binary function element-wise on this matrix and the given matrix.
  ///
  /// [other]: The matrix to element-wise apply the function with this matrix.
  /// [f]: The binary function to apply element-wise on the matrices.
  ///
  /// Returns a new matrix containing the result of the element-wise function application.
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[1, 2], [3, 4]]);
  /// var matrixB = Matrix([[2, 3], [4, 5]]);
  /// var result = matrixA.elementWise(matrixB, (a, b) => a * b);
  /// print(result);
  /// // Output:
  /// // 2  6
  /// // 12 20
  /// ```
  Matrix elementWise(Matrix other, dynamic Function(dynamic, dynamic) f) {
    if (rowCount != other.rowCount || columnCount != other.columnCount) {
      throw Exception(
          "Matrices must have the same shape for element-wise operation");
    }

    List<List<dynamic>> newData = List.generate(rowCount,
        (i) => List.generate(columnCount, (j) => f(this[i][j], other[i][j])));
    return Matrix(newData);
  }

  /// Calculates the sum of the elements in the matrix.
  ///
  /// [absolute]: If set to `true`, the absolute values of the elements are summed.
  ///
  /// Returns the sum of the elements in the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix.sum();
  /// print(result); // Output: 10
  /// ```
  double sum({bool absolute = false}) {
    if (toList().isEmpty) {
      throw Exception("Matrix is empty");
    }

    double sum = 0;

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        dynamic element = this[i][j];
        if (element is! num) {
          throw Exception("Matrix contains non-numeric elements");
        }
        if (absolute) {
          sum += (element < 0 ? -element : element);
        } else {
          sum += element;
        }
      }
    }

    return sum;
  }

  /// Calculates the trace of a square matrix.
  ///
  /// Returns the trace of the matrix (the sum of its diagonal elements).
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix.trace();
  /// print(result); // Output: 5
  /// ```
  double trace() {
    if (_data.isEmpty) {
      throw Exception("Matrix is empty");
    }

    if (rowCount != columnCount) {
      throw Exception("Matrix must be square to calculate the trace");
    }

    return diagonal().sum;
  }

  /// Calculates the Frobenius norm of the matrix.
  ///
  /// Returns the Frobenius norm of the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix.norm();
  /// print(result); // Output: 5.477225575051661
  /// ```
  double norm() {
    double sum = 0;
    for (var row in _data) {
      for (var element in row) {
        sum += element * element;
      }
    }
    return sqrt(sum);
  }

  /// Normalizes the matrix by dividing each element by the maximum element value.
  ///
  /// Returns a new normalized matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix.normalize();
  /// print(result);
  /// // Output:
  /// // 0.25 0.5
  /// // 0.75 1.0
  /// ```
  Matrix normalize() {
    if (_data.isEmpty) {
      throw Exception("Matrix is empty");
    }

    dynamic maxValue = _data[0][0];
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (_data[i][j] > maxValue) {
          maxValue = _data[i][j];
        }
      }
    }

    if (maxValue == 0) {
      throw Exception("Matrix is filled with zeros, cannot normalize");
    }

    List<List<dynamic>> newData = [];
    for (int i = 0; i < rowCount; i++) {
      List<dynamic> row = [];
      for (int j = 0; j < columnCount; j++) {
        row.add(_data[i][j] / maxValue);
      }
      newData.add(row);
    }

    return Matrix(newData);
  }

  /// Transposes the matrix by swapping rows and columns.
  ///
  /// Returns a new transposed matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix.transpose();
  /// print(result);
  /// // Output:
  /// // 1 3
  /// // 2 4
  /// ```
  Matrix transpose() {
    int rows = rowCount;
    int cols = columnCount;
    if (rows == 0) {
      throw Exception('Cannot transpose an empty matrix');
    }

    List<List<dynamic>> newData = List.generate(
        cols, (i) => List<dynamic>.filled(rows, null, growable: false));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        newData[j][i] = this[i][j];
      }
    }

    return Matrix(newData);
  }

  /// Calculates the determinant of a square matrix.
  ///
  /// Returns the determinant of the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix.determinant();
  /// print(result); // Output: -2
  /// ```
  double determinant() {
    int n = rowCount;
    if (n != columnCount) {
      throw Exception('Matrix must be square to calculate determinant');
    }

    if (n == 1) {
      return this[0][0];
    }

    if (n == 2) {
      return this[0][0] * this[1][1] - this[0][1] * this[1][0];
    }

    _data = _Utils.toDoubleMatrix(_data as List<List<num>>);

    double det = 0;
    for (int p = 0; p < n; p++) {
      Matrix subMatrix = Matrix([
        for (int i = 1; i < n; i++)
          [
            for (int j = 0; j < n; j++)
              if (j != p) this[i][j]
          ]
      ]);

      det += this[0][p] * (p % 2 == 0 ? 1 : -1) * subMatrix.determinant();
    }

    return det;
  }

  Matrix rref() {
    _data = _Utils.toDoubleMatrix(_data as List<List<num>>);
    var result = Matrix(_data);
    int lead = 0;
    int rowCount = result.rowCount;
    int columnCount = result.columnCount;

    for (int r = 0; r < rowCount; r++) {
      if (lead >= columnCount) {
        break;
      }
      int i = r;
      while (result[i][lead] == 0) {
        i++;
        if (i == rowCount) {
          i = r;
          lead++;
          if (lead == columnCount) {
            break;
          }
        }
      }
      result.swapRows(i, r);

      double lv = result[r][lead];
      for (int j = 0; j < columnCount; j++) {
        result[r][j] /= lv;
      }

      for (i = 0; i < rowCount; i++) {
        if (i != r) {
          lv = result[i][lead];
          for (int j = 0; j < columnCount; j++) {
            result[i][j] -= lv * result[r][j];
          }
        }
      }
      lead++;
    }

    return result;
  }

  /// Calculates the inverse of a square matrix.
  ///
  /// Returns the inverse matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix.inverse();
  /// print(result);
  /// // Output:
  /// // -2.0 1.0
  /// // 1.5 -0.5
  /// ```
  Matrix inverse() {
    int n = rowCount;
    if (n != columnCount) {
      throw Exception('Matrix must be square to calculate inverse');
    }

    double det = determinant();
    if (det == 0) {
      throw Exception('Matrix is singular and cannot be inverted');
    }

    Matrix adjugateMatrix = Matrix([
      for (int i = 0; i < n; i++) [for (int j = 0; j < n; j++) 0]
    ]);

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        Matrix subMatrix = Matrix([
          for (int p = 0; p < n; p++)
            if (p != i)
              [
                for (int q = 0; q < n; q++)
                  if (q != j) this[p][q]
              ]
        ]);

        adjugateMatrix[j][i] =
            ((i + j) % 2 == 0 ? 1 : -1) * subMatrix.determinant();
      }
    }

    Matrix inverseMatrix = adjugateMatrix * (1 / det);
    return inverseMatrix;
  }

  /// Calculates the dot product of two matrices.
  ///
  /// [other]: The matrix to be multiplied.
  ///
  /// Returns a new matrix that is the product of this matrix and [other].
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[1, 2], [3, 4]]);
  /// var matrixB = Matrix([[2, 0], [1, 2]]);
  /// var result = matrixA.dot(matrixB);
  /// print(result);
  /// // Output:
  /// // 4 4
  /// // 10 8
  /// ```
  Matrix dot(Matrix other) {
    int rowsA = rowCount;
    int colsA = columnCount;
    int rowsB = other.rowCount;
    int colsB = other.columnCount;

    if (colsA != rowsB) {
      throw Exception(
          'Cannot calculate dot product of matrices with incompatible shapes');
    }

    List<List<dynamic>> newData = [];

    for (int i = 0; i < rowsA; i++) {
      List<dynamic> row = [];
      for (int j = 0; j < colsB; j++) {
        dynamic sum = 0;
        for (int k = 0; k < colsA; k++) {
          sum += this[i][k] * other[k][j];
        }
        row.add(sum);
      }
      newData.add(row);
    }

    return Matrix(newData);
  }

  /// Calculates the element-wise reciprocal of the matrix.
  ///
  /// Returns a new matrix with the reciprocal of each element.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix.reciprocal();
  /// print(result);
  /// // Output:
  /// // 1.0 0.5
  /// // 0.3333333333333333 0.25
  /// ```
  Matrix reciprocal() {
    List<List<dynamic>> newData = List.generate(
        rowCount,
        (i) => List.generate(columnCount, (j) {
              if (_data[i][j] == 0) {
                throw Exception(
                    'Cannot take reciprocal of a matrix with zero elements');
              }
              return 1 / _data[i][j];
            }));

    return Matrix(newData);
  }

  /// Calculates the element-wise absolute value of the matrix.
  ///
  /// Returns a new matrix with the absolute value of each element.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[-1, 2], [3, -4]]);
  /// var result = matrix.abs();
  /// print(result);
  /// // Output:
  /// // 1 2
  /// // 3 4
  /// ```
  Matrix abs() {
    List<List<dynamic>> newData = List.generate(
        rowCount, (i) => List.generate(columnCount, (j) => _data[i][j].abs()));

    return Matrix(newData);
  }

  /// Rounds each element in the matrix to the specified number of decimal places.
  ///
  /// [decimalPlaces]: The number of decimal places to round to.
  ///
  /// Returns a new matrix with the rounded elements.
  ///
  /// Example:
  ///
  /// ```dart
  /// var matrix = Matrix([
  ///   [1.2345, 2.3456],
  ///   [3.4567, 4.5678]
  /// ]);
  ///
  /// var roundedMatrix = matrix.round(3);
  ///
  /// print(roundedMatrix);
  /// // Output:
  /// // 1.235  2.346
  /// // 3.457  4.568
  /// ```
  Matrix round(int decimalPlaces) {
    List<List<double>> newData = List.generate(
        rowCount, (i) => List<double>.generate(columnCount, (j) => 0));

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        newData[i][j] = (_data[i][j] * pow(10, decimalPlaces)).round() /
            pow(10, decimalPlaces);
      }
    }

    return Matrix(newData);
  }

  /// Checks if the current matrix is a submatrix of [parent].
  ///
  /// [parent]: The matrix in which to search for the current matrix.
  ///
  /// Returns `true` if the current matrix is a submatrix of [parent], otherwise `false`.
  ///
  /// Example:
  /// ```dart
  /// var parentMatrix = Matrix([[1, 2, 3], [4, 5, 6], [7, 8, 9]]);
  /// var subMatrix = Matrix([[5, 6], [8, 9]]);
  /// var result = subMatrix.isSubMatrix(parentMatrix);
  /// print(result); // Output: true
  /// ```
  bool isSubMatrix(Matrix parent) {
    for (int i = 0; i <= parent.rowCount - rowCount; i++) {
      for (int j = 0; j <= parent.columnCount - columnCount; j++) {
        bool found = true;
        for (int k = 0; k < rowCount && found; k++) {
          for (int l = 0; l < columnCount && found; l++) {
            if (parent[i + k][j + l] != this[k][l]) {
              found = false;
            }
          }
        }
        if (found) {
          return true;
        }
      }
    }
    return false;
  }

  /// Checks if the current matrix is contained in or is a submatrix of any matrix in [matrices].
  ///
  /// [matrices]: A list of matrices to check against.
  ///
  /// Returns `true` if the current matrix is contained in or is a submatrix of any matrix in [matrices], otherwise `false`.
  ///
  /// Example:
  /// ```dart
  /// var matrix1 = Matrix([[1, 2], [3, 4]]);
  /// var matrix2 = Matrix([[5, 6], [7, 8]]);
  /// var matrix3 = Matrix([[1, 2, 3], [3, 4, 5], [5, 6, 7]]);
  ///
  /// var targetMatrix = Matrix([[1, 2], [3, 4]]);
  /// print(targetMatrix.containsIn([matrix1, matrix2])); // Output: true
  /// print(targetMatrix.containsIn([matrix2, matrix3])); // Output: false
  /// ```
  bool containsIn(List<Matrix> matrices) {
    return matrices.any((matrix) => this == matrix || isSubMatrix(matrix));
  }

  /// Checks if the current matrix is not contained in and is not a submatrix of any matrix in [matrices].
  ///
  /// [matrices]: A list of matrices to check against.
  ///
  /// Returns `true` if the current matrix is not contained in and is not a submatrix of any matrix in [matrices], otherwise `false`.
  ///
  /// Example:
  /// ```dart
  /// var matrix1 = Matrix([[1, 2], [3, 4]]);
  /// var matrix2 = Matrix([[5, 6], [7, 8]]);
  /// var matrix3 = Matrix([[1, 2, 3], [3, 4, 5], [5, 6, 7]]);
  ///
  /// var targetMatrix = Matrix([[1, 2], [3, 4]]);
  /// print(targetMatrix.notIn([matrix2, matrix3])); // Output: true
  /// print(targetMatrix.notIn([matrix1, matrix2])); // Output: false
  /// ```
  bool notIn(List<Matrix> matrices) {
    return !containsIn(matrices);
  }

  // Gaussian elimination method.
  Matrix gaussianElimination(Matrix b) {
    Matrix a = Matrix(_data as List<List<num>>);
    a = _Utils.forwardElimination(a, b);
    return _Utils.backwardSubstitution(a, b);
  }

  // LU decomposition method.
  Matrix luDecomposition(Matrix b) {
    Matrix a = Matrix(_data as List<List<num>>);
    List<Matrix> lu = _Utils.luDecomposition(a);
    Matrix l = lu[0];
    Matrix u = lu[1];

    // Solve Ly = b
    Matrix y = _Utils.forwardSubstitution(l, b);

    // Solve Ux = y
    Matrix x = _Utils.backwardSubstitution(u, y);

    return x;
  }

  // QR algorithm for eigenvalues and eigenvectors
  List<dynamic> qrAlgorithm(Matrix A, int max_iterations, double tolerance) {
    if (A.rowCount != A.columnCount) {
      throw Exception("Matrix must be square");
    }

    int n = A.rowCount;
    Matrix Ak = A;

    for (int k = 0; k < max_iterations; k++) {
      List<Matrix> QR = _Utils.qrDecomposition(Ak);
      Matrix Q = QR[0];
      Matrix R = QR[1];
      Ak = _Utils.multiply(R, Q);

      // Check for convergence
      bool converged = true;
      for (int i = 1; i < n; i++) {
        for (int j = 0; j < i; j++) {
          if (Ak[i][j].abs() > tolerance) {
            converged = false;
            break;
          }
        }
        if (converged) {
          break;
        }
      }
      if (converged) {
        break;
      }
    }

    // Extract eigenvalues
    List<double> eigenvalues = List.filled(n, 0.0);
    for (int i = 0; i < n; i++) {
      eigenvalues[i] = Ak[i][i];
    }

    // Compute eigenvectors
    List<List<double>> eigenvectors =
        List.generate(n, (_) => List.filled(n, 0.0));
    for (int i = 0; i < n; i++) {
      eigenvectors[i][i] = 1.0;
    }

    for (int k = 0; k < max_iterations; k++) {
      List<Matrix> QR = _Utils.qrDecomposition(Matrix(eigenvectors));
      Matrix Q = QR[0];
      Matrix R = QR[1];
      eigenvectors = _Utils.multiply(eigenvectors.toMatrix(), Q).toList()
          as List<List<double>>;
    }

    Matrix eigenvectorsMatrix = Matrix(eigenvectors);

    return [eigenvalues, eigenvectorsMatrix];
  }

  /// Solves a linear system Ax = b using the specified [method].
  ///
  /// [b]: The right-hand side matrix.
  /// [method]: The method to use for solving the system. Options are 'lu' (LU decomposition, default) or 'gaussian' (Gaussian elimination).
  ///
  /// Returns a matrix x that satisfies Ax = b.
  ///
  /// Throws an exception if the current matrix is not square, if the row counts of the current matrix and [b] do not match, or if an invalid [method] is specified.
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[2, 1, 1], [1, 3, 2], [1, 0, 0]]);
  /// var matrixB = Matrix([[4], [5], [6]]);
  /// var result = matrixA.solve(matrixB, method: 'lu');
  /// print(result);
  /// // Output:
  /// // 6.0
  /// // 15.0
  /// // -23.0
  /// ```
  Matrix solve(Matrix b, {String method = 'gauss'}) {
    if (method == 'gauss') {
      return gaussianElimination(b);
    } else if (method == 'lu') {
      return luDecomposition(b);
    } else {
      throw Exception('Invalid method specified');
    }
  }
}
