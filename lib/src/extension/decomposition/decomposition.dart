part of matrix_utils;

abstract class Decomposition {
  Matrix solve(Matrix b);
}

/// Provides matrix decomposition functions as an extension on Matrix.
class MatrixDecomposition {
  Matrix _matrix;

  /// Constructor for MatrixDecomposition. Takes a Matrix as an argument.
  MatrixDecomposition(this._matrix);

  /// LU Decomposition: Check whether A = LU
  /// Checks if the LU Decomposition is accurate within a given tolerance.
  ///
  /// [A]: The original matrix
  /// [lu]: The LUDecomposition object
  /// Returns `true` if the decomposition is accurate, `false` otherwise.
  static bool checkLUDecomposition(Matrix A, LUDecomposition lu) {
    return A.isAlmostEqual(lu.L * lu.U);
  }

  /// Cholesky Decomposition: Check whether A = L*L^T
  /// Checks if the Cholesky Decomposition is accurate within a given tolerance.
  ///
  /// [A]: The original matrix
  /// [chol]: The CholeskyDecomposition object
  /// Returns `true` if the decomposition is accurate, `false` otherwise.
  static bool checkCholeskyDecomposition(
      Matrix A, CholeskyDecomposition cholesky) {
    Matrix l = cholesky.L;
    Matrix lt = l.transpose();
    return A.isAlmostEqual(l * lt);
  }

  /// QR Decomposition: Check whether A = QR
  /// Checks if the QR Decomposition is accurate within a given tolerance.
  ///
  /// [A]: The original matrix
  /// [qr]: The QRDecomposition object
  /// Returns `true` if the decomposition is accurate, `false` otherwise.
  static bool checkQRDecomposition(Matrix A, QRDecomposition qr) {
    return A.isAlmostEqual(qr.Q * qr.R);
  }

  /// LQ Decomposition: Check whether A = LQ
  /// Checks if the LQ Decomposition is accurate within a given tolerance.
  ///
  /// [A]: The original matrix
  /// [lq]: The LQDecomposition object
  /// Returns `true` if the decomposition is accurate, `false` otherwise.
  static bool checkLQDecomposition(Matrix A, LQDecomposition lq) {
    return A.isAlmostEqual(lq.L * lq.Q);
  }

  /// Eigenvalue Decomposition: Check whether A = V * D * V.inv()
  /// Checks if the Eigenvalue Decomposition is accurate within a given tolerance.
  ///
  /// [A]: The original matrix
  /// [eig]: The EigenvalueDecomposition object
  /// Returns `true` if the decomposition is accurate, `false` otherwise.
  static bool checkEigenvalueDecomposition(
      Matrix A, EigenvalueDecomposition eig) {
    Matrix product = eig.V * eig.D * eig.V.inverse();
    return A.isAlmostEqual(product);
  }

  /// Schur Decomposition: Check whether A = Q * T * Q.inv()
  /// Checks if the Schur Decomposition is accurate within a given tolerance.
  ///
  /// [A]: The original matrix
  /// [schur]: The SchurDecomposition object
  /// Returns `true` if the decomposition is accurate, `false` otherwise.
  static bool checkSchurDecomposition(Matrix A, SchurDecomposition schur) {
    Matrix Q = schur.Q;
    Matrix T = schur.A;
    Matrix qInv = Q.inverse();
    Matrix product = Q * T * qInv;
    return A.isAlmostEqual(product);
  }

  /// Singular Value Decomposition: Check whether A = U * S * Vt
  /// Checks if the Singular Value Decomposition is accurate within a given tolerance.
  ///
  /// [A]: The original matrix
  /// [svd]: The SingularValueDecomposition object
  /// Returns `true` if the decomposition is accurate, `false` otherwise.
  static bool checkSingularValueDecomposition(
      Matrix A, SingularValueDecomposition svd) {
    Matrix U = svd.U;
    Matrix S = svd.S;
    Matrix vt = svd.V;
    Matrix product = U * S * vt;
    return A.isAlmostEqual(product);
  }

  /// Computes the condition number of the matrix using its singular value
  /// decomposition (SVD). The condition number is the ratio of the largest
  /// singular value to the smallest singular value. A high condition number
  /// indicates that the matrix is ill-conditioned, which can lead to numerical
  /// instability in some linear algebra operations like matrix inversion and
  /// solving linear systems.
  ///
  /// Generally, a condition number close to 1 indicates a well-conditioned matrix,
  /// while a large condition number indicates an ill-conditioned matrix. The threshold
  /// for considering a matrix as ill-conditioned varies depending on the application,
  /// but a common rule of thumb is that a matrix is ill-conditioned if its condition
  /// number is greater than 10^3 or 10^4.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1.0, 2.0, 3.0],
  ///   [4.0, 5.0, 6.0],
  ///   [7.0, 8.0, 9.0]
  /// ]);
  ///
  /// double cond = A.decomposition.conditionNumber();
  /// print('Condition number: $cond');
  /// ```
  double conditionNumber() {
    // Compute the singular value decomposition of the matrix
    var svd = _matrix.decomposition.singularValueDecomposition();

    // Find the largest and smallest singular values
    double maxSingularValue = (svd.S[0][0] as num).toDouble();
    double minSingularValue =
        (svd.S[_matrix.rowCount - 1][_matrix.columnCount - 1] as num)
            .toDouble();

    // Calculate the condition number
    double conditionNumber = maxSingularValue / minSingularValue;

    return conditionNumber;
  }

  /// Performs Schur decomposition of a square matrix.
  ///
  /// Returns an instance of SchurDecomposition containing the orthogonal matrix Q,
  /// and the upper quasi-triangular matrix T such that A = QTQ*.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  /// [1, 4, 8],
  /// [4, 3, 12],
  /// [8, 12, 11]
  /// ]);
  ///
  /// SchurDecomposition schur = A.decomposition.schurDecomposition();
  /// schur.Q.prettyPrint();
  /// schur.T.prettyPrint();
  /// ```
  SchurDecomposition schurDecomposition(
      {int maxIterations = 1000, double tolerance = 1e-10}) {
    if (_matrix.rowCount != _matrix.columnCount) {
      throw ArgumentError('Schur decomposition requires a square matrix');
    }
    var A = _Utils.toDoubleMatrix(_matrix);
    Matrix Q = Matrix.eye(A.rowCount);

    for (int i = 0; i < maxIterations; i++) {
      var qr = A.decomposition.qrDecompositionHouseholder();
      Matrix qK = qr.Q;
      Matrix R = qr.R;

      A = R * qK;
      Q = Q * qK;

      double offDiagonalFrobeniusNorm = 0.0;
      for (int row = 1; row < A.rowCount; row++) {
        for (int col = 0; col < row; col++) {
          offDiagonalFrobeniusNorm += A[row][col] * A[row][col];
        }
      }

      if (offDiagonalFrobeniusNorm <= tolerance * tolerance) {
        break;
      }
    }

    return SchurDecomposition(_matrix, Q, A);
  }

  /// Performs Cholesky decomposition of a symmetric positive definite matrix.
  ///
  /// Returns a lower triangular matrix L such that A = L*L^T.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  /// [4, 12, -16],
  /// [12, 37, -43],
  /// [-16, -43, 98]
  /// ]);
  ///
  /// Matrix L = A.choleskyDecomposition();
  /// L.prettyPrint();
  /// ```
  CholeskyDecomposition choleskyDecomposition() {
    if (_matrix.rowCount != _matrix.columnCount) {
      throw ArgumentError('Matrix must be square for Cholesky decomposition.');
    }

    Matrix L = Matrix.zeros(_matrix.rowCount, _matrix.columnCount);

    for (int i = 0; i < _matrix.rowCount; i++) {
      for (int j = 0; j <= i; j++) {
        double sum = 0.0;

        if (j == i) {
          for (int k = 0; k < j; k++) {
            sum += math.pow(L[j][k], 2);
          }
          L[j][j] = math.sqrt(_matrix[j][j] - sum);
        } else {
          for (int k = 0; k < j; k++) {
            sum += L[i][k] * L[j][k];
          }
          L[i][j] = (1.0 / L[j][j]) * (_matrix[i][j] - sum);
        }
      }
    }

    return CholeskyDecomposition(_matrix, L);
  }

  /// Performs QR Decomposition (Gram-Schmidt Method) decomposition of a matrix.
  ///
  /// Returns an instance of QRDecomposition containing the orthogonal matrix Q and
  /// the upper triangular matrix R.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  /// [12, -51, 4],
  /// [6, 167, -68],
  /// [-4, 24, -41]
  /// ]);
  ///
  /// QRDecomposition qr = A.qrDecompositionGramSchmidt();
  /// qr.Q.prettyPrint();
  /// qr.R.prettyPrint();
  /// ```
  QRDecomposition qrDecompositionGramSchmidt() {
    if (_matrix.rowCount < _matrix.columnCount) {
      throw ArgumentError(
          'Matrix must have more rows than columns for QR decomposition.');
    }

    //  Matrix Q = _matrix.linear.gramSchmidtOrthogonalization();
    // Matrix R = Matrix.zeros(_matrix.columnCount, _matrix.columnCount);

    // for (int i = 0; i < _matrix.columnCount; i++) {
    //   for (int j = i; j < _matrix.columnCount; j++) {
    //     R[i][j] = _Utils.vectorDotProduct(_Utils.toSDList(Q.column(i).asList),
    //         _Utils.toSDList(_matrix.column(j).asList));
    //   }
    // }
    // return QRDecomposition(Q, R);
    //-------------------------------
    Matrix Q =
        Matrix.zeros(_matrix.rowCount, _matrix.columnCount, isDouble: true);
    Matrix R =
        Matrix.zeros(_matrix.columnCount, _matrix.columnCount, isDouble: true);

    for (int k = 0; k < _matrix.columnCount; k++) {
      List<double> u = _Utils.toSDList(_matrix.column(k).asList);

      for (int i = 0; i < k; i++) {
        List<double> qI = _Utils.toSDList(Q.column(i).asList);
        double projectionScale = _Utils.vectorDotProduct(u, qI);
        R[i][k] = projectionScale;
        u = _Utils.vectorSubtract(u, _Utils.vectorScale(qI, projectionScale));
      }

      double normU = _Utils.vectorNorm(u);
      R[k][k] = normU;
      Q.setColumn(k, Column(u.map((x) => x / normU).toList()).asList);
    }
    return QRDecomposition(Q, R);
  }

  /// Computes the QR decomposition of the matrix using the Householder
  /// reflection method.
  ///
  /// QR decomposition is a factorization of a matrix A into a product A = QR
  /// of an orthogonal matrix Q and an upper triangular matrix R.
  ///
  /// This function uses the Householder reflection method for the decomposition.
  /// The Householder method is a numerically stable and efficient technique for
  /// computing the QR decomposition.
  ///
  /// Returns a QRDecomposition object containing matrices Q and R.
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  /// [12, -51, 4],
  /// [6, 167, -68],
  /// [-4, 24, -41]
  /// ]);
  ///
  /// QRDecomposition qr = A.qrDecompositionHouseholder();
  /// qr.Q.prettyPrint();
  /// qr.R.prettyPrint();
  /// ```
  QRDecomposition qrDecompositionHouseholder() {
    var A = _Utils.toDoubleMatrix(_matrix);
    Matrix Q = Matrix.eye(A.rowCount);
    Matrix R = A.copy();

    for (int k = 0; k < math.min(A.rowCount, A.columnCount); k++) {
      var columnVector = R.column(k).subMatrix(k, A.rowCount - 1);
      Matrix pk = _Utils.householderReflection(columnVector);
      Matrix P = Matrix.eye(A.rowCount);
      P.setSubMatrix(k, k, pk);

      R = P * R;
      Q = Q * P;
    }

    return QRDecomposition(Q, R);
  }

  /// Performs LQ decomposition of a matrix.
  ///
  /// Returns an instance of LQDecomposition containing the lower triangular matrix L
  /// and the orthogonal matrix Q.
  ///
  /// The LQ decomposition is a factorization of a matrix A, with A = LQ,
  /// where L is a lower triangular matrix and Q is an orthogonal matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [12, -51, 4],
  ///   [6, 167, -68],
  ///   [-4, 24, -41]
  /// ]);
  ///
  /// LQDecomposition lq = A.decomposition.lqDecomposition();
  /// lq.L.prettyPrint();
  /// lq.Q.prettyPrint();
  /// ```
  LQDecomposition lqDecomposition() {
    // Compute the QR decomposition of the transpose of the matrix
    var A = _Utils.toDoubleMatrix(_matrix);
    QRDecomposition qr =
        A.transpose().decomposition.qrDecompositionHouseholder();

    // L is the transpose of R from the QR decomposition
    Matrix L = qr.R.transpose();

    // Q is the transpose of Q from the QR decomposition
    Matrix Q = qr.Q.transpose();

    return LQDecomposition(Q, L);
  }

  /// Performs LU decomposition using Doolittle's Method without pivoting.
  ///
  /// Returns an instance of LUDecomposition containing the lower triangular matrix L
  /// and the upper triangular matrix U. It does not compute the permutation matrix P.
  ///
  /// Note: This method does not use pivoting and may result in numerical instability
  /// for matrices with zero or near-zero diagonal elements. Use the pivoting version
  /// for improved numerical stability.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 4],
  ///   [4, 8, 20],
  ///   [3, 6, 7]
  /// ]);
  ///
  /// LUDecomposition lu = A.luDecomposition();
  /// lu.L.prettyPrint();
  /// lu.U.prettyPrint();
  /// ```
  LUDecomposition luDecompositionDoolittle() {
    if (_matrix.rowCount != _matrix.columnCount) {
      throw ArgumentError('LU decomposition requires a square matrix');
    }
    var A = _Utils.toDoubleMatrix(_matrix);
    int n = A.rowCount;
    Matrix L = Matrix.eye(n);
    Matrix U = Matrix.zeros(n, n);

    for (int k = 0; k < n; k++) {
      for (int j = k; j < n; j++) {
        U[k][j] = A[k][j] - _Utils.sumLUk(L, U, k, k, j);
      }

      for (int i = k + 1; i < n; i++) {
        L[i][k] = (A[i][k] - _Utils.sumLUk(L, U, k, i, k)) / U[k][k];
      }
    }
    return LUDecomposition(L, U);
  }

  /// Performs LU decomposition using Doolittle's Method with partial (row) pivoting.
  ///
  /// Returns an instance of LUDecomposition containing the lower triangular matrix L,
  /// the upper triangular matrix U, and the permutation matrix P, which represents
  /// the row swaps performed during the decomposition process.
  ///
  /// This method improves numerical stability by swapping rows based on the largest
  /// pivot element in the current column, making it more robust than the non-pivoting
  /// version.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 4],
  ///   [4, 8, 20],
  ///   [3, 6, 7]
  /// ]);
  ///
  /// LUDecomposition lu = A.luDecompositionDoolittlePivoting();
  /// lu.L.prettyPrint();
  /// lu.U.prettyPrint();
  /// lu.P.prettyPrint();
  /// ```
  LUDecomposition luDecompositionDoolittlePartialPivoting() {
    var A = _Utils.toDoubleMatrix(_matrix);
    int n = A.rowCount;

    // Initialize L, U, and P
    Matrix L = Matrix.eye(n, isDouble: true);
    Matrix U = Matrix.zeros(n, n, isDouble: true);
    Matrix P = Matrix.eye(n, isDouble: true);

    for (int k = 0; k < n; k++) {
      // Find the largest pivot in the current column
      double maxVal = 0.0;
      int maxIndex = k;
      for (int i = k; i < n; i++) {
        if (A[i][k].abs() > maxVal) {
          maxVal = (A[i][k] as num).toDouble().abs();
          maxIndex = i;
        }
      }

      // Swap the rows in the permutation matrix
      P.swapRows(k, maxIndex);

      // Swap the rows in the matrix itself
      A.swapRows(k, maxIndex);

      for (int i = k; i < n; i++) {
        if (i == k) {
          for (int j = k; j < n; j++) {
            U[i][j] = A[i][j];
          }
        } else {
          double factor = A[i][k] / U[k][k];
          L[i][k] = factor;

          for (int j = k; j < n; j++) {
            A[i][j] = A[i][j] - factor * U[k][j];
          }
        }
      }
    }

    return LUDecomposition(L, U, P);
  }

  /// Performs LU decomposition using Crout's Method.
  ///
  /// Returns an instance of LUDecomposition containing the lower triangular matrix L
  /// and the upper triangular matrix U.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 4],
  ///   [4, 8, 20],
  ///   [3, 6, 7]
  /// ]);
  ///
  /// LUDecomposition lu = A.luDecompositionCrout();
  /// lu.L.prettyPrint();
  /// lu.U.prettyPrint();
  /// ```
  LUDecomposition luDecompositionCrout() {
    if (_matrix.rowCount != _matrix.columnCount) {
      throw ArgumentError('Matrix must be square for LU decomposition.');
    }
    var A = _Utils.toDoubleMatrix(_matrix);

    int n = A.rowCount;
    Matrix L = Matrix.eye(n);
    Matrix U = Matrix.zeros(n, n);

    for (int j = 0; j < n; j++) {
      for (int i = j; i < n; i++) {
        double sum = 0.0;
        for (int k = 0; k < j; k++) {
          sum += L[i][k] * U[k][j];
        }
        L[i][j] = A[i][j] - sum;
      }

      for (int i = j; i < n; i++) {
        double sum = 0.0;
        for (int k = 0; k < j; k++) {
          sum += L[j][k] * U[k][i];
        }
        U[j][i] = (A[j][i] - sum) / L[j][j];
      }
    }

    return LUDecomposition(L, U);
  }

  /// Performs LU decomposition using Gauss Elimination Method.
  ///
  /// Returns an instance of LUDecomposition containing the lower triangular matrix L,
  /// the upper triangular matrix U, and the permutation matrix P.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1 , 2, 4],
  ///   [4, 8, 20],
  ///   [3, 6, 7]
  /// ]);
  ///
  /// LUDecomposition lu = A.luDecompositionGauss();
  /// lu.L.prettyPrint();
  /// lu.U.prettyPrint();
  /// lu.P.prettyPrint();
  /// ```
  LUDecomposition luDecompositionGauss() {
    int n = _matrix.rowCount;
    _matrix = _Utils.toDoubleMatrix(_matrix);

    // Initialize L, U, and P
    Matrix L = Matrix.eye(n);
    Matrix U = Matrix.zeros(n, n);
    Matrix P = Matrix.eye(n);

    for (int k = 0; k < n; k++) {
      // Find the largest pivot in the current column
      double maxVal = 0.0;
      int maxIndex = k;
      for (int i = k; i < n; i++) {
        if (_matrix[i][k].abs() > maxVal) {
          maxVal = (_matrix[i][k] as num).toDouble().abs();
          maxIndex = i;
        }
      }
      // Swap the rows in the permutation matrix
      P.swapRows(k, maxIndex);

      // Swap the rows in the matrix itself
      _matrix.swapRows(k, maxIndex);

      for (int i = k + 1; i < n; i++) {
        double factor = _matrix[i][k] / _matrix[k][k];
        L[i][k] = factor;

        for (int j = k; j < n; j++) {
          if (j == k) {
            U[k][j] = _matrix[k][j];
          }
          _matrix[i][j] = _matrix[i][j] - factor * _matrix[k][j];
        }
      }
    }

    // Copy the resulting upper triangular matrix to U
    for (int i = 0; i < n; i++) {
      for (int j = i; j < n; j++) {
        U[i][j] = _matrix[i][j];
      }
    }

    return LUDecomposition(L, U, P);
  }

  /// Performs LU decomposition with complete pivoting.
  ///
  /// Returns an instance of LUDecomposition containing the lower triangular matrix L,
  /// the upper triangular matrix U, the permutation matrix P, and the matrix Q.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 4],
  ///   [4, 8, 20],
  ///   [3, 6, 7]
  /// ]);
  ///
  /// LUDecomposition lu = A.luDecompositionCompletePivoting();
  /// lu.L.prettyPrint();
  /// lu.U.prettyPrint();
  /// lu.P.prettyPrint();
  /// lu.Q.prettyPrint();
  /// ```
  LUDecomposition luDecompositionDoolittleCompletePivoting() {
    int n = _matrix.rowCount;

    // Initialize L, U, P, and Q
    Matrix L = Matrix.eye(n);
    Matrix U = Matrix.zeros(n, n);
    Matrix P = Matrix.eye(n);
    Matrix Q = Matrix.eye(n);

    for (int k = 0; k < n; k++) {
      // Find the largest pivot in the current submatrix
      double maxVal = 0.0;
      int maxRow = k;
      int maxCol = k;
      for (int i = k; i < n; i++) {
        for (int j = k; j < n; j++) {
          if (_matrix[i][j].abs() > maxVal) {
            maxVal = _matrix[i][j].abs();
            maxRow = i;
            maxCol = j;
          }
        }
      }

      // Swap the rows in the permutation matrix P
      P.swapRows(k, maxRow);

      // Swap the rows in the matrix itself
      _matrix.swapRows(k, maxRow);

      // Swap the columns in the permutation matrix Q
      Q.swapColumns(k, maxCol);

      // Swap the columns in the matrix itself
      _matrix.swapColumns(k, maxCol);

      for (int i = k; i < n; i++) {
        if (i == k) {
          for (int j = k; j < n; j++) {
            U[i][j] = _matrix[i][j];
          }
        } else {
          double factor = _matrix[i][k] / U[k][k];
          L[i][k] = factor;

          for (int j = k; j < n; j++) {
            _matrix[i][j] = _matrix[i][j] - factor * U[k][j];
          }
        }
      }
    }

    return LUDecomposition(L, U, P, Q);
  }

  /// Performs Singular Value Decomposition (SVD) of a matrix.
  ///
  /// Returns an instance of SVD containing the orthogonal matrices U and V, and the
  /// diagonal matrix Σ (Sigma-S) such that A = UΣV*.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  /// [3, 2, 2],
  /// [2, 3, -2]
  /// ]);
  ///
  /// SVD svd = A.singularValueDecomposition();
  /// svd.U.prettyPrint();
  /// svd.S.prettyPrint();
  /// svd.V.prettyPrint();
  /// ```
  SingularValueDecomposition singularValueDecomposition() {
    // Matrix A = _matrix.copy();

    // // Perform bidiagonalization
    // final bidiag = _Utils.bidiagonalize(A);
    // Matrix U = bidiag.U;
    // Matrix B = bidiag.B;
    // Matrix Vt = bidiag.V;

    // // Perform QR Iteration on bidiagonal matrix B
    // final svd = _Utils.qrIterationOnBidiagonal(B);
    // Matrix S = svd.S;
    // Matrix Ut = svd.U;
    // Matrix V = svd.V;

    // // Compute U by combining the bidiagonalization and QR iteration steps
    // U = U * Ut.transpose();

    // return SingularValueDecomposition(U, S, V);
    var svd = SVDs(_matrix);

    return SingularValueDecomposition(svd.U(), svd.S(), svd.V());

    // var svd = SVD(_matrix.toArray2D());

    // return SingularValueDecomposition(
    //     svd.U().toMatrix(), svd.S().toMatrix(), svd.V().toMatrix());
  }

  /// Performs Eigenvalue decomposition of a square matrix.
  ///
  /// Returns an instance of EigenvalueDecomposition containing the eigenvectors matrix V,
  /// the eigenvalues matrix D, and the inverse of eigenvectors matrix Vinv.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  /// [2, 1],
  /// [1, 2]
  /// ]);
  ///
  /// EigenvalueDecomposition eig = A.eigenvalueDecomposition();
  /// eig.V.prettyPrint();
  /// eig.D.prettyPrint();
  /// ```
  EigenvalueDecomposition eigenvalueDecomposition() {
    if (!_matrix.isSquareMatrix()) {
      throw ArgumentError(
          'Matrix must be square for eigenvalue decomposition.');
    }

    if (!_matrix.isSymmetricMatrix()) {
      throw ArgumentError(
          'Matrix must be symmetric for this eigenvalue decomposition implementation.');
    }

    int maxIterations = 1000;
    double tolerance = 1e-10;

    Matrix A = _matrix.copy();
    Matrix V = Matrix.eye(_matrix.rowCount);

    for (int k = 0; k < maxIterations; k++) {
      // Find the largest off-diagonal element in A
      int p = 0, q = 1;
      double maxOffDiagonal = (A[p][q] as num).toDouble().abs();
      for (int i = 0; i < A.rowCount; i++) {
        for (int j = i + 1; j < A.columnCount; j++) {
          if (A[i][j].abs() > maxOffDiagonal) {
            maxOffDiagonal = A[i][j].abs();
            p = i;
            q = j;
          }
        }
      }

      // Check for convergence
      if (maxOffDiagonal < tolerance) {
        return EigenvalueDecomposition(Diagonal(A.diagonal()), V);
      }

      // Compute the Jacobi rotation matrix
      double theta = 0.5 * math.atan2(2 * A[p][q], A[q][q] - A[p][p]);
      Matrix J = Matrix.eye(A.rowCount);
      J[p][p] = math.cos(theta);
      J[p][q] = -math.sin(theta);
      J[q][p] = math.sin(theta);
      J[q][q] = math.cos(theta);

      // Update A and V
      A = J.transpose() * A * J;
      V = V * J;
    }

    throw StateError(
        'Eigenvalue decomposition did not converge within the maximum number of iterations.');
  }

  /// Solves a linear equation system Ax = b using various decomposition methods.
  ///
  /// [b] is the right-hand side matrix in the equation Ax = b.
  /// [method] is the decomposition method used to solve the linear system. It can be one of the following:
  ///   - "crout" for LU Decomposition Crout's algorithm
  ///   - "doolittle" for LU Decomposition Doolittle algorithm
  ///   - "doolittle_pivoting" for LU Decomposition Doolittle algorithm with pivoting
  ///   - "gauss_elimination" for LU Decomposition Gauss Elimination Method
  ///   - "partial_pivoting" for LU Decomposition Partial Pivoting
  ///   - "complete_pivoting" for LU Decomposition Complete Pivoting
  ///   - "qr_gram_schmidt" for QR decomposition Gram Schmidt
  ///   - "qr_householder" for QR decomposition Householder
  ///   - "lq" for LQ decomposition
  ///   - "cholesky" for Cholesky Decomposition
  ///   - "eigenvalue" for Eigenvalue Decomposition
  ///   - "singular_value" for Singular Value Decomposition
  ///   - "schur" for Schur Decomposition
  ///   - "auto" (default) to automatically select a suitable method
  ///
  /// [ridgeAlpha] is the regularization parameter for Ridge Regression (L2 regularization).
  /// If ridgeAlpha > 0.0, Ridge Regression is used instead of the selected method.
  ///
  /// Returns the solution matrix x.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 4],
  ///   [4, 8, 20],
  ///   [3, 6, 7]
  /// ]);
  /// Matrix b = Matrix.fromList([
  ///   [15],
  ///   [68],
  ///   [27]
  /// ]);
  ///
  /// Matrix x = A.solve(b, method: "qr_householder");
  /// x.prettyPrint();
  /// ```
  Matrix solve(Matrix b, {String method = "auto", double ridgeAlpha = 0.0}) {
    Decomposition decomposition;
    double conditionNumber = _matrix.conditionNumber();
    if (conditionNumber > 1e12) {
      print(
          "Warning: The matrix is ill-conditioned (condition number = $conditionNumber). Results may not be accurate.");
    }

    if (ridgeAlpha > 0.0) {
      return _matrix.linear.ridgeRegression(b, ridgeAlpha);
    } else {
      switch (method.toLowerCase()) {
        case "crout":
          decomposition = _matrix.decomposition.luDecompositionCrout();
          break;
        case "doolittle":
          decomposition = _matrix.decomposition.luDecompositionDoolittle();
          break;
        case "doolittle_pivoting":
          decomposition =
              _matrix.decomposition.luDecompositionDoolittlePartialPivoting();
          break;
        case "doolittle_complete_pivoting":
          decomposition =
              _matrix.decomposition.luDecompositionDoolittleCompletePivoting();
          break;
        case "gauss_elimination":
          decomposition = _matrix.decomposition.luDecompositionGauss();
          break;
        case "qr_gram_schmidt":
          decomposition = _matrix.decomposition.qrDecompositionGramSchmidt();
          break;
        case "qr_householder":
          decomposition = _matrix.decomposition.qrDecompositionHouseholder();
          break;
        case "lq":
          decomposition = _matrix.decomposition.lqDecomposition();
          break;
        case "cholesky":
          decomposition = _matrix.decomposition.choleskyDecomposition();
          break;
        case "eigenvalue":
          decomposition = _matrix.decomposition.eigenvalueDecomposition();
          break;
        case "singular_value":
          decomposition = _matrix.decomposition.singularValueDecomposition();
          break;
        case "schur":
          decomposition = _matrix.decomposition.schurDecomposition();
          break;
        case "auto":
        default:
          if (_matrix.isSymmetricMatrix()) {
            decomposition = _matrix.decomposition.choleskyDecomposition();
          } else {
            decomposition = _matrix.decomposition.qrDecompositionGramSchmidt();
          }
          break;
      }

      return decomposition.solve(b);
    }
  }
}
