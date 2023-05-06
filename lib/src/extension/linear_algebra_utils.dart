part of matrix_utils;

/*
Linear Algebra Utilities:
   - Linear least squares
   - Eigenvalue and eigenvector calculation
   - System of linear equations solver with multiple methods (e.g., Jacobi, Gauss-Seidel, SOR, Conjugate Gradient)
   - Linear programming solver
   - Quadratic programming solver
   - Orthogonalization (Gram-Schmidt process)
 */

class LinearAlgebra {
  final Matrix _matrix;
  LinearAlgebra(this._matrix);

  /// Perform Gram-Schmidt orthogonalization on the matrix
  Matrix gramSchmidtOrthogonalization() {
    if (_matrix.rowCount < _matrix.columnCount) {
      throw ArgumentError(
          'Matrix must have more rows than columns for Gram-Schmidt orthogonalization.');
    }

    Matrix Q =
        Matrix.zeros(_matrix.rowCount, _matrix.columnCount, isDouble: true);

    for (int k = 0; k < _matrix.columnCount; k++) {
      List<double> u = _Utils.toSDList(_matrix.column(k).asList);

      for (int i = 0; i < k; i++) {
        List<double> q_i = _Utils.toSDList(Q.column(i).asList);
        double projectionScale = _Utils.vectorDotProduct(u, q_i);
        u = _Utils.vectorSubtract(u, _Utils.vectorScale(q_i, projectionScale));
      }

      double norm_u = _Utils.vectorNorm(u);
      Q.setColumn(k, Column(u.map((x) => x / norm_u).toList()).asList);
    }

    return Q;
  }

  // Gauss elimination method.
  Matrix gaussianEliminationSolve(Matrix b) {
    Matrix a = _Utils.toDoubleMatrix(_matrix);
    b = _Utils.toDoubleMatrix(b);
    a = _Utils.forwardElimination(a, b);
    return _Utils.backwardSubstitution(a, b);
  }

  // LU decomposition method.
  Matrix luDecompositionSolve(Matrix b) {
    Matrix a = Matrix(_matrix._data as List<List<num>>);
    var lu = a.decomposition.luDecomposition();
    Matrix l = lu.L;
    Matrix u = lu.U;

    // Solve Ly = b
    Matrix y = _Utils.forwardSubstitution(l, b);

    // Solve Ux = y
    Matrix x = _Utils.backwardSubstitution(u, y);

    return x;
  }

  // Solves linear equations using Gram-Schmidt orthogonalization.
  Matrix gramSchmidtSolve(Matrix b) {
    Matrix a = Matrix(_matrix._data as List<List<num>>);
    Matrix qt = gramSchmidtOrthogonalization(); // Get the orthogonal matrix Q
    Matrix q = qt.transpose(); // Transpose Q to get Qt
    Matrix r = qt * a; // Compute R (upper triangular matrix)

    Matrix qtB = qt * b; // Compute Qt * b
    return _Utils.backwardSubstitution(
        r, qtB); // Solve Rx = Qt * b using backward substitution
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
      return gaussianEliminationSolve(b);
    } else if (method == 'lu') {
      return luDecompositionSolve(b);
    } else if (method == 'gramSchmidt') {
      return gramSchmidtSolve(b);
    } else {
      throw Exception('Invalid method specified');
    }
  }
}
