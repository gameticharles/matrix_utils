part of matrix_utils;

/// Class to store eigenvalues and eigenvectors of a matrix.
class Eigen {
  /// List of eigenvalues.
  final List<double> values;

  /// List of eigenvectors, each represented as a column matrix.
  final List<Matrix> vectors;

  /// Constructs an Eigen object from the given eigenvalues and eigenvectors.
  Eigen(this.values, this.vectors);

  /// Construct the Matrix from the given eigenvalues and eigenvectors
  /// M = S.J.S^-1
  ///
  /// where S is a matrix of the eigenvectors in row-major order
  /// s = [
  /// v1.transpose(),
  /// v2.transpose(),
  /// v3.transpose(),
  /// ...
  /// ]
  ///
  /// J = Diagonal(eigenvalues)
  Matrix get check {
    var S = Matrix(vectors.map((e) => e.flatten()).toList()).transpose();
    var J = Diagonal(values);
    return S * J * S.inverse();
  }

  /// Verifies the eigenvalues and eigenvectors by checking if A * x = λ * x
  /// for all eigenvalue-eigenvector pairs. Returns true if the verification
  /// is successful within the specified tolerance.
  // bool verify(Matrix A, {double tolerance = 1e-6}) {
  //   for (int i = 0; i < vectors.length; i++) {
  //     Matrix eigenvector = vectors[i].normalize();
  //     Matrix Ax = A * eigenvector;
  //     Matrix lambdaX = eigenvector * values[i];

  //     for (int j = 0; j < Ax.rowCount; j++) {
  //       if (((Ax[j][0] as num) - (lambdaX[j][0] as num)).abs() > tolerance) {
  //         return false;
  //       }
  //     }
  //   }

  //   return true;
  // }
  bool verify(Matrix A, {double tolerance = 1e-6}) {
    for (int i = 0; i < vectors.length; i++) {
      Matrix eigenvector = vectors[i];
      Matrix Ax = A * eigenvector;
      Matrix lambdaX = eigenvector * values[i];
      Matrix residual = Ax - lambdaX;

      if (residual.infinityNorm() > tolerance) {
        return false;
      }
    }

    return true;
  }
}
