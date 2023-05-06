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
      return scale(other);
    } else {
      throw Exception('Invalid operand type');
    }
  }

  Matrix scale(num scaleFactor) {
    List<List<dynamic>> newData = [];

    for (int i = 0; i < rowCount; i++) {
      List<dynamic> row = [];
      for (int j = 0; j < columnCount; j++) {
        row.add(this[i][j] * scaleFactor);
      }
      newData.add(row);
    }

    return Matrix(newData);
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

  Matrix pow(num exponent) {
    return Matrix(_data
        .map((row) => row.map((cell) => math.pow(cell, exponent)).toList())
        .toList());
    // Matrix result = Matrix.zeros(rowCount, columnCount);

    // for (int i = 0; i < rowCount; i++) {
    //   for (int j = 0; j < columnCount; j++) {
    //     result[i][j] = pow(_data[i][j], exponent);
    //   }
    // }

    // return result;
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
    for (dynamic element in elements) {
      sum += absolute ? (element as num).abs() : (element as num);
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
    var diag = Matrix.fromDiagonal(diagonal());

    return diag.sum();
  }

  /// Calculates the L1 norm of the matrix.
  ///
  /// The L1 norm, also known as the maximum absolute column sum norm, is
  /// calculated by summing the absolute values of each element in each column
  /// and taking the maximum of these sums.
  ///
  /// Example:
  /// ```
  /// var mat = Matrix.fromList([
  ///   [2, -3],
  ///   [-1, 4],
  /// ]);
  /// print(mat.l1Norm()); // Output: 7.0
  /// ```
  ///
  /// Returns:
  /// A double representing the L1 norm of the matrix.
  double l1Norm() {
    double maxSum = 0.0;

    for (int j = 0; j < columnCount; j++) {
      double colSum = 0.0;
      for (int i = 0; i < rowCount; i++) {
        colSum += this[i][j].abs();
      }
      maxSum = math.max(maxSum, colSum);
    }

    return maxSum;
  }

  /// Calculates the L2 (Euclidean) norm of the matrix.
  ///
  /// The L2 norm, also known as the Euclidean norm or Frobenius norm, is
  /// calculated by summing the squares of each element and taking the square
  /// root of the result.
  ///
  /// Example:
  /// ```
  /// var mat = Matrix.fromList([
  ///   [2, -3],
  ///   [-1, 4],
  /// ]);
  /// print(mat.l2Norm()); // Output: 5.477225575051661
  /// ```
  ///
  /// Returns:
  /// A double representing the L2 norm of the matrix.
  double l2Norm() {
    double sum = 0.0;

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        sum += this[i][j] * this[i][j];
      }
    }

    return math.sqrt(sum);
  }

  /// Calculates the L2 norm or Frobenius norm of the matrix.
  ///
  /// Returns the Frobenius norm of the matrix.
  ///
  double norm() {
    return l2Norm();
  }

  /// Calculates the L2 norm or Frobenius norm of the matrix.
  ///
  /// Returns the Frobenius norm of the matrix.
  ///
  double norm2() {
    return l2Norm();
  }

  /// Calculates the Infinity norm of the matrix.
  ///
  /// The Infinity norm, also known as the maximum absolute row sum norm, is
  /// calculated by summing the absolute values of each element in each row and
  /// taking the maximum of these sums.
  ///
  /// Example:
  /// ```
  /// var mat = Matrix.fromList([
  ///   [2, -3],
  ///   [-1, 4],
  /// ]);
  /// print(mat.infinityNorm()); // Output: 5.0
  /// ```
  ///
  /// Returns:
  /// A double representing the Infinity norm of the matrix.
  double infinityNorm() {
    double maxSum = 0.0;

    for (int i = 0; i < rowCount; i++) {
      double rowSum = 0.0;
      for (int j = 0; j < columnCount; j++) {
        rowSum += this[i][j].abs();
      }
      maxSum = math.max(maxSum, rowSum);
    }

    return maxSum;
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

  /// Returns the conjugate transpose (also known as the Hermitian transpose) of the matrix.
  /// The conjugate transpose is obtained by first computing the conjugate of the matrix
  /// and then transposing it.
  ///
  /// If the matrix has complex elements, the conjugate transpose is computed by
  /// taking the complex conjugate of each element and transposing the resulting matrix.
  ///
  /// Example:
  /// ```
  /// var A = Matrix('1+2i 3-4i; 5+6i 7-8i');
  /// var B = A.conjugateTranspose();
  /// ```
  ///
  /// Returns a new [Matrix] object containing the conjugate transpose.
  Matrix conjugateTranspose() {
    return conjugate().transpose();
  }

  /// Computes the matrix of cofactors for a square matrix.
  /// Each element in the cofactor matrix is the determinant of the submatrix
  /// formed by removing the corresponding row and column from the original matrix,
  /// multiplied by the alternating sign pattern.
  ///
  /// Throws an [ArgumentError] if the matrix is not square.
  ///
  /// Example:
  /// ```
  /// var A = Matrix('1+2i 3-4i; 5+6i 7-8i');
  /// var B = A.conjugate();
  /// ```
  ///
  /// Returns a new [Matrix] object containing the cofactors.
  Matrix conjugate() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (this[i][j] is Complex) {
          result[i][j] = (this[i][j] as Complex).conjugate();
        } else {
          result[i][j] = this[i][j];
        }
      }
    }
    return result;
  }

  /// Computes the matrix of cofactors for a square matrix.
  /// Each element in the cofactor matrix is the determinant of the submatrix
  /// formed by removing the corresponding row and column from the original matrix,
  /// multiplied by the alternating sign pattern.
  ///
  /// Example:
  /// ```
  /// var A = Matrix('1 2 3; 4 5 6; 7 8 9');
  /// var B = A.cofactors();
  /// ```
  ///
  /// Throws an [ArgumentError] if the matrix is not square.
  ///
  /// Returns a new [Matrix] object containing the cofactors.
  Matrix cofactors() {
    if (!isSquareMatrix()) {
      throw ArgumentError('Cofactors can only be computed for square matrices');
    }

    Matrix cofactorMatrix = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        cofactorMatrix[i][j] =
            math.pow(-1, i + j) * subMatrix(i, j).determinant();
      }
    }
    return cofactorMatrix;
  }

  /// Computes the adjoint (also known as adjugate or adjunct) of a square matrix.
  /// The adjoint is obtained by transposing the cofactor matrix.
  ///
  /// Example:
  /// ```
  /// var A = Matrix('1 2 3; 4 5 6; 7 8 9');
  /// var B = A.adjoint();
  /// ```
  ///
  /// Throws an [ArgumentError] if the matrix is not square.
  ///
  /// Returns a new [Matrix] object containing the adjoint.
  Matrix adjoint() {
    return cofactors().transpose();
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
    _data = _Utils.toDoubleList(_data);

    if (n == 1) {
      return this[0][0];
    }

    if (n == 2) {
      return (_data[0][0] * _data[1][1]) - (_data[0][1] * _data[1][0]);
    }

    double det = 0;
    for (int p = 0; p < n; p++) {
      Matrix subMatrix = Matrix([
        for (int i = 1; i < n; i++)
          [
            for (int j = 0; j < n; j++)
              if (j != p) _data[i][j]
          ]
      ]);

      det += _data[0][p] * (p % 2 == 0 ? 1 : -1) * subMatrix.determinant();
    }

    return det;
  }

  Matrix ref() {
    Matrix result = _Utils.toDoubleMatrix(this);
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
      if (result[r][lead] != 0) {
        result.scaleRow(r, 1 / result[r][lead]);
      }
      for (i = r + 1; i < rowCount; i++) {
        result.addRow(r, i, -result[i][lead]);
      }
      lead++;
    }

    return result;
  }

  Matrix rref() {
    Matrix result = ref();
    int rowCount = result.rowCount;
    int columnCount = result.columnCount;

    for (int r = rowCount - 1; r >= 0; r--) {
      int nonZeroIndex = _getFirstNonZeroIndex(result[r]);

      if (nonZeroIndex != -1) {
        for (int i = r - 1; i >= 0; i--) {
          result.addRow(r, i, -result[i][nonZeroIndex]);
        }
      }
    }

    return result;
  }

  /// Scales the elements of the specified row by a given factor.
  ///
  /// This function multiplies all the elements in the row with the specified
  /// [rowIndex] by the given [scaleFactor].
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  /// A.scaleRow(1, 2);
  /// print(A);
  /// ```
  ///
  /// Output:
  /// ```
  /// 1 2 3
  /// 8 10 12
  /// 7 8 9
  /// ```
  ///
  /// Validation:
  /// Throws [RangeError] if [rowIndex] is not a valid row index in the matrix.
  void scaleRow(int rowIndex, double scaleFactor) {
    RangeError.checkValidIndex(rowIndex, this, "rowIndex", rowCount);

    for (int j = 0; j < columnCount; j++) {
      this[rowIndex][j] *= scaleFactor;
    }
  }

  /// Returns the row space of the matrix.
  ///
  /// The row space is the linear space formed by the linearly independent
  /// rows of the matrix.
  ///
  /// Example:
  ///
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [0, 1, 1],
  ///   [0, 0, 0]
  /// ]);
  /// print(A.getRowSpace());
  /// // Output:
  /// // 1  2  3
  /// // 0  1  1
  /// ```
  Matrix rowSpace() {
    Matrix rref = this.rref();
    List<List<dynamic>> rowSpace = [];

    for (int i = 0; i < rref.rowCount; i++) {
      bool isZeroRow = true;

      for (int j = 0; j < rref.columnCount; j++) {
        if (rref[i][j] != 0) {
          isZeroRow = false;
          break;
        }
      }

      if (!isZeroRow) {
        rowSpace.add(this[i]);
      }
    }

    return Matrix.fromList(rowSpace);
  }

  /// Returns the column space of the matrix.
  ///
  /// The column space is the linear space formed by the linearly independent
  /// columns of the matrix.
  ///
  /// Example:
  ///
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 0, 0],
  ///   [2, 1, 0],
  ///   [3, 1, 0]
  /// ]);
  /// print(A.getColumnSpace());
  /// // Output:
  /// // 1  0
  /// // 2  1
  /// // 3  1
  /// ```
  Matrix getColumnSpace() {
    Matrix transpose = this.transpose();
    return transpose.rowSpace().transpose();
  }

  /// Returns the null space of the matrix.
  ///
  /// The null space is the linear space formed by all vectors that, when
  /// multiplied by the matrix, result in the zero vector.
  ///
  /// Example:
  ///
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [0, 1, 1],
  ///   [0, 0, 0]
  /// ]);
  /// print(A.getNullSpace());
  /// // Output:
  /// // -2
  /// //  3
  /// //  0
  /// ```
  Matrix getNullSpace() {
    Matrix rref = this.rref();
    List<List<double>> nullSpace = [];

    int freeVarCount = rref.columnCount - rref.rank();

    for (int i = 0; i < freeVarCount; i++) {
      List<double> nullSpaceVector = List.filled(this.columnCount, 0.0);
      int freeVarIndex = rref.columnCount - freeVarCount + i;

      for (int j = 0; j < rref.rowCount; j++) {
        nullSpaceVector[j] = -rref[j][freeVarIndex];
      }

      nullSpaceVector[freeVarIndex] = 1;
      nullSpace.add(nullSpaceVector);
    }

    return Matrix(nullSpace);
  }

  /// Returns the nullity of the matrix.
  ///
  /// The nullity is the dimension of the null space of the matrix.
  ///
  /// Example:
  ///
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [0, 1, 1],
  ///   [0, 0, 0]
  /// ]);
  int getNullity() {
    return this.columnCount - this.rank();
  }

  /// Adds a multiple of one row to another row.
  ///
  /// This function multiplies the elements in the row with the specified
  /// [sourceIndex] by the given [scaleFactor] and adds the result to the
  /// elements in the row with the specified [targetIndex].
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  /// A.addRow(0, 2, -3);
  /// print(A);
  /// ```
  ///
  /// Output:
  /// ```
  ///  1  2  3
  ///  4  5  6
  /// -4 -2  0
  /// ```
  ///
  /// Validation:
  /// Throws [RangeError] if [sourceIndex] or [targetIndex] is not a valid row index in the matrix.
  void addRow(int sourceIndex, int targetIndex, double scaleFactor) {
    RangeError.checkValidIndex(sourceIndex, this, "sourceIndex", rowCount);
    RangeError.checkValidIndex(targetIndex, this, "targetIndex", rowCount);

    for (int j = 0; j < columnCount; j++) {
      this[targetIndex][j] += scaleFactor * this[sourceIndex][j];
    }
  }

  int _getFirstNonZeroIndex(List<dynamic> row) {
    for (int i = 0; i < row.length; i++) {
      if (row[i] != 0) {
        return i;
      }
    }
    return -1;
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

    Matrix adjugateMatrix = Matrix.fill(n, n, 0.0);

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
        newData[i][j] = (_data[i][j] * math.pow(10, decimalPlaces)).round() /
            math.pow(10, decimalPlaces);
      }
    }

    return Matrix(newData);
  }

  /// Computes the eigenvalues of the matrix using the QR algorithm.
  ///
  /// This implementation assumes that the matrix is symmetric and may not converge for non-symmetric matrices.
  ///
  /// * [maxIterations]: Maximum number of iterations for the QR algorithm (default: 1000).
  /// * [tolerance]: Tolerance for checking the convergence of the QR algorithm (default: 1e-10).
  ///
  /// Returns a list of eigenvalues.
  ///
  /// Example:
  /// ```
  /// var matrix = Matrix([
  ///   [1, 2, 3],
  ///   [2, 1, 2],
  ///   [3, 2, 1]
  /// ]);
  /// var eigenvalues = matrix.eigenvalues();
  /// print(eigenvalues); // [5.372281323269014, -2.3722813232690143, -1.0000000000000002]
  /// ```
  List<double> eigenvalues(
      {int maxIterations = 1000, double tolerance = 1e-10}) {
    return eigen(maxIterations: maxIterations, tolerance: tolerance).values;
  }

  /// Computes the eigenvectors of the matrix using the QR algorithm.
  ///
  /// This implementation assumes that the matrix is symmetric and may not converge for non-symmetric matrices.
  ///
  /// * [maxIterations]: Maximum number of iterations for the QR algorithm (default: 1000).
  /// * [tolerance]: Tolerance for checking the convergence of the QR algorithm (default: 1e-10).
  ///
  /// Returns a list of eigenvectors, each represented as a column matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([
  ///   [1, 2, 3],
  ///   [2, 1, 2],
  ///   [3, 2, 1]
  /// ]);
  /// var eigenvectors = matrix.eigenvectors();
  /// print(eigenvectors[0]); // Matrix([[0.5773502691896258], [0.5773502691896257], [0.5773502691896257]])
  /// ```
  List<Matrix> eigenvectors(
      {int maxIterations = 1000, double tolerance = 1e-10}) {
    return eigen(maxIterations: maxIterations, tolerance: tolerance).vectors;
  }

  /// Computes the eigenvalues and eigenvectors of the matrix using the QR algorithm.
  ///
  /// This implementation assumes that the matrix is symmetric and may not converge for non-symmetric matrices.
  ///
  /// * [maxIterations]: Maximum number of iterations for the QR algorithm (default: 1000).
  /// * [tolerance]: Tolerance for checking the convergence of the QR algorithm (default: 1e-10).
  ///
  /// Returns an `Eigen` object containing eigenvalues and eigenvectors.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([
  ///   [1, 2, 3],
  ///   [2, 1, 2],
  ///   [3, 2, 1]
  /// ]);
  /// var eigen = matrix.eigen();
  /// print(eigen.values); // [5.372281323269014, -2.3722813232690143, -1.0000000000000002]
  /// print(eigen.vectors[0]); // Matrix([[0.5773502691896258], [0.5773502691896257], [0.5773502691896257]])
  /// ```
  Eigen eigen({int maxIterations = 1000, double tolerance = 1e-10}) {
    if (!isSquareMatrix()) {
      throw ArgumentError(
          'Eigenvalues and eigenvectors can only be computed for square matrices');
    }
    if (!isSymmetricMatrix(tolerance: tolerance)) {
      throw ArgumentError(
          'This implementation only supports symmetric matrices');
    }

    int n = rowCount;
    Matrix A = _Utils.toDoubleMatrix(this);
    Matrix V = Matrix.eye(n, isDouble: true);
    Matrix A_prev;

    for (int i = 0; i < maxIterations; i++) {
      A_prev = A.copy();
      var qr = A.decomposition.qrDecompositionGramSchmidt();
      Matrix Q = qr.Q;
      Matrix R = qr.R;

      A = R * Q;
      V = V * Q;

      Matrix diff = A - A_prev;
      if (diff.infinityNorm() < tolerance) {
        break;
      }

      if (A.isUpperTriangular(tolerance) && A.isLowerTriangular(tolerance)) {
        break;
      }
    }

    List<double> eigenvalues = List.generate(n, (i) => A[i][i]);
    List<Matrix> eigenvectors = List.generate(n, (i) => V.column(i));

    return Eigen(eigenvalues, eigenvectors);
  }

  Eigen eigen1({int maxIterations = 1000, double tolerance = 1e-10}) {
    if (!isSquareMatrix()) {
      throw ArgumentError(
          'Eigenvalues and eigenvectors can only be computed for square matrices');
    }
    return _eigenJacobi(maxIterations, tolerance);

    // // Check the properties of the input matrix
    // if (isSymmetricMatrix(tolerance: tolerance)) {
    //   // Use the Divide and Conquer algorithm for symmetric matrices
    //   return _eigenDivideAndConquer(maxIterations, tolerance);
    // } else if (isHermitianMatrix(tolerance: tolerance) && isSparse()) {
    //   // Use the Lanczos algorithm for large Hermitian sparse matrices
    //   return _eigenLanczos(maxIterations, tolerance);
    // } else if (isDiagonalMatrix(tolerance: tolerance)) {
    //   // Use the Jacobi method for diagonal matrices
    //   return _eigenJacobi(maxIterations, tolerance);
    // } else if (hasDominantEigenvalue(tolerance: tolerance)) {
    //   // Use the Power Iteration method for matrices with a dominant eigenvalue
    //   return _eigenPowerIteration(maxIterations, tolerance);
    // } else {
    //   // Use the QR algorithm for general dense matrices
    //   return _eigenQR(maxIterations, tolerance);
    // }
  }

// Implement the QR algorithm
  Eigen _eigenQR(int maxIterations, double tolerance) {
    return Eigen([], []);
  }

// Implement the Divide and Conquer algorithm
  Eigen _eigenDivideAndConquer(int maxIterations, double tolerance) {
    return Eigen([], []);
  }

// Implement the Lanczos algorithm
  Eigen _eigenLanczos(int maxIterations, double tolerance) {
    return Eigen([], []);
  }

  // Implement the Jacobi method
  Eigen _eigenJacobi(int maxIterations, double tolerance) {
    if (!isSquareMatrix()) {
      throw ArgumentError(
          'Eigenvalues and eigenvectors can only be computed for square matrices');
    }

    if (!isSymmetricMatrix(tolerance: tolerance)) {
      throw ArgumentError('The Jacobi method only supports symmetric matrices');
    }

    int n = rowCount;
    Matrix A = copy();
    Matrix V = Matrix.eye(n, isDouble: true);

    for (int k = 0; k < maxIterations; k++) {
      // Find the largest off-diagonal element in A
      double maxOffDiagonal = 0.0;
      int p = 0, q = 0;
      for (int i = 0; i < n - 1; i++) {
        for (int j = i + 1; j < n; j++) {
          if ((A[i][j] as num).abs() > maxOffDiagonal) {
            maxOffDiagonal = (A[i][j] as num).toDouble().abs();
            p = i;
            q = j;
          }
        }
      }

      // Check for convergence
      if (maxOffDiagonal < tolerance) {
        break;
      }

      // Perform the Jacobi rotation
      double Apq = (A[p][q] as num).toDouble();
      double App = (A[p][p] as num).toDouble();
      double Aqq = (A[q][q] as num).toDouble();
      double phi = 0.5 * math.atan2(2 * Apq, Aqq - App);
      double c = math.cos(phi);
      double s = math.sin(phi);
      A[p][p] = c * c * App - 2 * s * c * Apq + s * s * Aqq;
      A[q][q] = s * s * App + 2 * s * c * Apq + c * c * Aqq;
      A[p][q] = A[q][p] = 0.0;

      for (int i = 0; i < n; i++) {
        if (i != p && i != q) {
          double Api = (A[p][i] as num).toDouble();
          double Aqi = (A[q][i] as num).toDouble();
          A[p][i] = A[i][p] = c * Api - s * Aqi;
          A[q][i] = A[i][q] = s * Api + c * Aqi;
        }
        double Vpi = c * V[p][i] - s * V[q][i];
        double Vqi = s * V[p][i] + c * V[q][i];
        V[p][i] = Vpi;
        V[q][i] = Vqi;
      }
    }

    // Extract eigenvalues and eigenvectors
    List<double> eigenvalues = List.generate(n, (i) => A[i][i]);
    List<Matrix> eigenvectors = List.generate(n, (i) => V.column(i));

    return Eigen(eigenvalues, eigenvectors);
  }

// Implement the Power Iteration method
  Eigen _eigenPowerIteration(int maxIterations, double tolerance) {
    return Eigen([], []);
  }

  // Performs a plane rotation (Givens rotation) on the matrix.
  Matrix rotate(int p, int q, double c, double s) {
    int n = rowCount;
    Matrix result = _Utils.toDoubleMatrix(this);

    for (int i = 0; i < n; i++) {
      double a_pi = c * this[i][p] - s * this[i][q];
      double a_qi = s * this[i][p] + c * this[i][q];
      result[i][p] = a_pi;
      result[i][q] = a_qi;
    }

    for (int i = 0; i < n; i++) {
      double a_ip = c * this[p][i] - s * this[q][i];
      double a_iq = s * this[p][i] + c * this[q][i];
      result[p][i] = a_ip;
      result[q][i] = a_iq;
    }

    return result;
  }

  /// Creates a tridiagonal matrix using the main diagonal, sub-diagonal, and
  /// super-diagonal elements of the current matrix.
  ///
  /// This function does not perform any actual tridiagonalization of the matrix.
  /// It just extracts the main diagonal, sub-diagonal, and super-diagonal elements
  /// from the input matrix and creates a new matrix with those elements.
  ///
  /// Example:
  /// ```dart
  /// var A = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  ///
  /// var tridiagonalA = A.tridiagonalize();
  /// tridiagonalA.prettyPrint();
  /// ```
  Matrix tridiagonalize() {
    List<dynamic> mainDiagonal = diagonal();
    List<dynamic> subDiagonal = diagonal(k: -1);
    List<dynamic> superDiagonal = diagonal(k: 1);

    Matrix tridiagonal = Matrix.zeros(rowCount, columnCount);

    for (int i = 0; i < rowCount; i++) {
      tridiagonal[i][i] = mainDiagonal[i];
      if (i > 0) {
        tridiagonal[i][i - 1] = subDiagonal[i - 1];
      }
      if (i < rowCount - 1) {
        tridiagonal[i][i + 1] = superDiagonal[i];
      }
    }

    return tridiagonal;
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
}
