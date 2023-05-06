part of matrix_utils;

class QRDecomposition {
  final Matrix Q;
  final Matrix R;

  QRDecomposition(this.Q, this.R);

  /// Checks if Q is an orthogonal matrix.
  bool get isOrthogonalMatrix => Q.isOrthogonalMatrix();

  /// Checks if R is an upper triangular matrix.
  bool get isUpperTriangular => R.isUpperTriangular();

  /// Checks the decomposition by reconstructing the original matrix.
  /// Returns the reconstructed matrix as Q * R.
  Matrix get checkMatrix => Q * R;

  /// Solves a linear equation system Ax = b for the given matrix b.
  /// Returns the solution matrix x.
  Matrix solve(Matrix b) {
    // Check if the matrix R is non-singular
    if (!R.isNonSingularMatrix()) {
      throw Exception("Matrix R is singular, cannot solve the linear system.");
    }

    // Compute Q^T * b
    Matrix y = Q.transpose() * b;

    // Solve Rx = Q^T * b using backward substitution
    Matrix x = _Utils.backwardSubstitution(R, y);

    return x;
  }
}

class EigenvalueDecomposition {
  final Matrix D;
  final Matrix V;

  EigenvalueDecomposition(this.D, this.V);

  /// Checks the decomposition by reconstructing the original matrix.
  /// Returns the reconstructed matrix as V * D * V.inverse().
  Matrix get checkMatrix => V * D * V.inverse();

  /// Verifies the eigenvalues and eigenvectors by checking if A * x = λ * x
  /// for all eigenvalue-eigenvector pairs. Returns true if the verification
  /// is successful within the specified tolerance.
  bool verify(Matrix A, {double tolerance = 1e-6}) {
    for (int i = 0; i < V.columnCount; i++) {
      Matrix eigenvector = V.column(i);
      Matrix Ax = A * eigenvector;
      Matrix lambdaX = eigenvector * D[i][i];

      for (int j = 0; j < Ax.rowCount; j++) {
        if ((Ax[j][0] - lambdaX[j][0]).abs() > tolerance) {
          return false;
        }
      }
    }
    return true;
  }
}

class CholeskyDecomposition {
  final Matrix L;

  CholeskyDecomposition(this.L);

  /// Checks if L is a lower triangular matrix.
  bool get isLowerTriangular => L.isLowerTriangular();

  /// Checks if the matrix is positive definite.
  bool get isPositiveDefiniteMatrix => L.isPositiveDefiniteMatrix();

  /// Checks the decomposition by reconstructing the original matrix.
  /// Returns the reconstructed matrix as L * L.transpose().
  Matrix get checkMatrix => L * L.transpose();

  Matrix solve(Matrix b) {
    // Check if the matrix is positive definite
    if (!isPositiveDefiniteMatrix) {
      throw Exception(
          "Matrix is not positive definite, cannot solve the linear system.");
    }

    // Solve Ly = b using forward substitution
    Matrix y = _Utils.forwardSubstitution(L, b);

    // Solve L^T * x = y using backward substitution
    Matrix x = _Utils.backwardSubstitution(L.transpose(), y);

    return x;
  }
}

class LQDecomposition {
  final Matrix Q;
  final Matrix L;

  LQDecomposition(this.Q, this.L);

  /// Checks if Q is an orthogonal matrix.
  bool get isOrthogonalMatrix => Q.isOrthogonalMatrix();

  /// Checks if L is a lower triangular matrix.
  bool get isLowerTriangular => L.isLowerTriangular();

  /// Checks the decomposition by reconstructing the original matrix.
  /// Returns the reconstructed matrix as L * Q.
  Matrix get checkMatrix => L * Q;

  Matrix solve(Matrix b) {
    // Check if the matrix L is non-singular
    if (!L.isNonSingularMatrix()) {
      throw Exception("Matrix L is singular, cannot solve the linear system.");
    }

    // Solve Ly = b using forward substitution
    Matrix y = _Utils.forwardSubstitution(L, b);

    // Solve Qx = y using backward substitution
    Matrix x = _Utils.backwardSubstitution(Q, y);

    return x;
  }
}

class SchurDecomposition {
  final Matrix Q;
  final Matrix A;

  SchurDecomposition(this.Q, this.A);

  /// Checks if Q is an orthogonal matrix.
  bool get isOrthogonalMatrix => Q.isOrthogonalMatrix();

  /// Checks the decomposition by reconstructing the original matrix.
  /// Returns the reconstructed matrix as Q * A * Q.transpose().
  Matrix get checkMatrix => Q * A * Q.transpose();
}

class LUDecomposition {
  final Matrix L;
  final Matrix U;
  final Matrix? P;
  final Matrix? Q;

  LUDecomposition(this.L, this.U, [this.P, this.Q]);

  /// Checks if the matrix U is non-singular.
  bool get isNonSingular => U.isNonSingularMatrix();

  /// Checks the decomposition by reconstructing the original matrix.
  /// If P and Q are not null, returns P * L * U * Q.
  /// If only P is not null, returns P * L * U.
  /// If both P and Q are null, returns L * U.
  Matrix get checkMatrix {
    if (P != null && Q != null) {
      return P! * L * U * Q!;
    } else if (P != null) {
      return P! * L * U;
    } else {
      return L * U;
    }
  }

  Matrix solve(Matrix b) {
    // Check if the matrix is non-singular
    if (!isNonSingular) {
      throw Exception("Matrix is singular, cannot solve the linear system.");
    }

    // If the matrix has been permuted, apply the permutation to b
    Matrix pb = P != null ? P! * b : b;

    // Solve LY = Pb using forward substitution
    Matrix y = _Utils.forwardSubstitution(L, pb);

    // Solve UX = Y using backward substitution
    Matrix x = _Utils.backwardSubstitution(U, y);

    return x;
  }
}

class SingularValueDecomposition {
  final Matrix U;
  final Matrix S;
  final Matrix V;

  SingularValueDecomposition(this.U, this.S, this.V);

  /// Checks if U is an orthogonal matrix.
  bool get isOrthogonalU => U.isOrthogonalMatrix();

  /// Checks if V is an orthogonal matrix.
  bool get isOrthogonalV => V.isOrthogonalMatrix();

  /// Checks the decomposition by reconstructing the original matrix.
  /// Returns the reconstructed matrix as U * S * V.transpose().
  Matrix get checkMatrix => U * S * V.transpose();

  /// Solves a linear equation system Ax = b for the given matrix b.
  /// Returns the solution matrix x.
  Matrix solve(Matrix b) {
    // Compute the pseudo-inverse of S
    Matrix sPseudoInverse = S.copy();
    for (int i = 0; i < sPseudoInverse.rowCount; i++) {
      for (int j = 0; j < sPseudoInverse.columnCount; j++) {
        if (sPseudoInverse[i][j] != 0) {
          sPseudoInverse[i][j] = 1 / sPseudoInverse[i][j];
        }
      }
    }

    // Compute x = V * S^+ * U^T * b
    Matrix x = V * sPseudoInverse * U.transpose() * b;

    return x;
  }
}

class Bidiagonalization {
  Matrix U;
  Matrix B;
  Matrix V;

  Bidiagonalization(this.U, this.B, this.V);
}
