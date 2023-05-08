part of matrix_utils;

class LUs {
  //#region class variables
  /// Array for internal storage of decomposition.
  /// internal array storage.
  Matrix _LUMatrix = Matrix();

  /// Row and column dimensions, and pivot sign.
  /// - [_m] column dimension.
  /// - [_n] row dimension.
  /// - [_pivsign] pivot sign.
  int _m = 0, _n = 0, _pivsign = 1;

  /// Internal storage of pivot vector.
  /// - [_piv] pivot vector.
  Matrix _piv = Matrix();

  //#endregion

  //#region Constructor
  /// LU Decomposition
  /// Structure to access L, U and piv.
  /// - [A] Rectangular matrix
  LUs(Matrix A) {
    // Use a "left-looking", dot-product, Crout/Doolittle algorithm.
    _LUMatrix = _Utils.toDoubleMatrix(A.copy());
    _m = A.rowCount;
    _n = A.columnCount;
    _piv = Matrix.fill(1, _m, 0.0);
    for (var i = 0; i < _m; i++) {
      _piv[0][i] = i.toDouble();
    }
    _pivsign = 1;
    Matrix LUrowi = Matrix();
    var LUcolj = Matrix.fill(_m, 1, 0.0);

    // Outer loop.

    for (var j = 0; j < _n; j++) {
      // Make a copy of the j-th column to localize references.

      for (var i = 0; i < _m; i++) {
        LUcolj[i][0] = _LUMatrix[i][j];
      }

      // Apply previous transformations.

      for (var i = 0; i < _m; i++) {
        LUrowi = _Utils.toDoubleMatrix(_LUMatrix.row(i));

        // Most of the time is spent in the following dot product.

        var kmax = math.min(i, j);
        var s = 0.0;
        for (var k = 0; k < kmax; k++) {
          s += LUrowi[0][k] * LUcolj[k][0];
        }

        LUrowi[0][j] = LUcolj[i][0] -= s;
      }

      // Find pivot and exchange if necessary.

      var p = j;
      for (var i = j + 1; i < _m; i++) {
        if ((LUcolj[i][0] as num).abs() > (LUcolj[p][0] as num).abs()) {
          p = i;
        }
      }
      if (p != j) {
        for (var k = 0; k < _n; k++) {
          var t = _LUMatrix[p][k];
          _LUMatrix[p][k] = _LUMatrix[j][k];
          _LUMatrix[j][k] = t;
        }
        var k = (_piv[0][p] as num).toDouble();
        _piv[0][p] = _piv[0][j];
        _piv[0][j] = k;
        _pivsign = -_pivsign;
      }

      // Compute multipliers.
      if (j < _m && _LUMatrix[j][j] != 0.0) {
        for (var i = j + 1; i < _m; i++) {
          _LUMatrix[i][j] /= _LUMatrix[j][j];
        }
      }
    }
  }

//#region Temporary, experimental code.
/*
   \** LU Decomposition, computed by Gaussian elimination.
   <P>
   This constructor computes L and U with the "daxpy"-based elimination
   algorithm used in LINPACK and MATLAB.  In Java, we suspect the dot-product,
   Crout algorithm will be faster.  We have temporarily included this
   constructor until timing experiments confirm this suspicion.
   <P>
   @param  A             Rectangular matrix
   @param  linpackflag   Use Gaussian elimination.  Actual value ignored.
   @return               Structure to access L, U and piv.
   *\

   public LUDecomposition (Matrix A, int linpackflag) {
      // Initialize.
      LU = A.getArrayCopy();
      m = A.getRowDimension();
      n = A.getColumnDimension();
      piv = new int[m];
      for (int i = 0; i < m; i++) {
         piv[i] = i;
      }
      pivsign = 1;
      // Main loop.
      for (int k = 0; k < n; k++) {
         // Find pivot.
         int p = k;
         for (int i = k+1; i < m; i++) {
            if (Math.abs(LU[i][k]) > Math.abs(LU[p][k])) {
               p = i;
            }
         }
         // Exchange if necessary.
         if (p != k) {
            for (int j = 0; j < n; j++) {
               double t = LU[p][j]; LU[p][j] = LU[k][j]; LU[k][j] = t;
            }
            int t = piv[p]; piv[p] = piv[k]; piv[k] = t;
            pivsign = -pivsign;
         }
         // Compute multipliers and eliminate k-th column.
         if (LU[k][k] != 0.0) {
            for (int i = k+1; i < m; i++) {
               LU[i][k] /= LU[k][k];
               for (int j = k+1; j < n; j++) {
                  LU[i][j] -= LU[i][k]*LU[k][j];
               }
            }
         }
      }
   }
*/
//#endregion.

//#region Public Methods
  /// Is the matrix nonsingular?
  /// return true if U, and hence A, is nonsingular.
  bool isNonsingular() {
    for (var j = 0; j < _n; j++) {
      if (_LUMatrix[j][j] == 0) {
        return false;
      }
    }
    return true;
  }

  /// Return lower triangular factor
  /// return  L
  Matrix L() {
    var L = Matrix.fill(_m, _n, 0.0);
    for (var i = 0; i < _m; i++) {
      for (var j = 0; j < _n; j++) {
        if (i > j) {
          L[i][j] = _LUMatrix[i][j];
        } else if (i == j) {
          L[i][j] = 1.0;
        } else {
          L[i][j] = 0.0;
        }
      }
    }
    return L;
  }

  /// Return upper triangular factor
  /// return U
  Matrix U() {
    var U = Matrix.fill(_n, _n, 0.0);
    for (var i = 0; i < _n; i++) {
      for (var j = 0; j < _n; j++) {
        if (i <= j) {
          U[i][j] = _LUMatrix[i][j];
        } else {
          U[i][j] = 0.0;
        }
      }
    }
    return U;
  }

  /// Return pivot permutation vector
  /// return piv
  Row pivot() {
    var p = Row.fill(_m, 0.0);
    for (var i = 0; i < _m; i++) {
      p[i] = _piv[0][i];
    }
    return p;
  }

  /// Return pivot permutation vector as a one-dimensional double array
  /// return (double) piv
  Row doublePivot() {
    var val = Row.fill(_m, 0.0);
    for (var i = 0; i < _m; i++) {
      val[i] = _piv[0][i];
    }
    return val;
  }

  /// Determinant
  /// return det(A)
  /// exception FormatException Matrix must be square
  double det() {
    if (_m != _n) {
      throw FormatException('Matrix must be square.');
    }
    var d = _pivsign.toDouble();
    for (var j = 0; j < _n; j++) {
      d *= _LUMatrix[j][j];
    }
    return d;
  }

  /// Solve A*X = B
  /// - [B] A Matrix with as many rows as A and any number of columns.
  /// so that L*U*X = B(piv,:)
  /// - [FormatException] Matrix row dimensions must agree or Matrix is singular.
  Matrix solve(Matrix B) {
    if (B.rowCount != _m) {
      throw FormatException('Matrix row dimensions must agree.');
    }
    if (!isNonsingular()) {
      throw FormatException('Matrix is singular.');
    }

    // Copy right hand side with pivoting
    var nx = B.columnCount;
    var X = B.submatrix(
        rowList: _piv.flatten().map((e) => (e as num).toInt()).toList(),
        colStart: 0,
        colEnd: nx - 1);

    // Solve L*Y = B(piv,:)
    for (var k = 0; k < _n; k++) {
      for (var i = k + 1; i < _n; i++) {
        for (var j = 0; j < nx; j++) {
          X[i][j] -= X[k][j] * _LUMatrix[i][k];
        }
      }
    }
    // Solve U*X = Y;
    for (var k = _n - 1; k >= 0; k--) {
      for (var j = 0; j < nx; j++) {
        X[k][j] /= _LUMatrix[k][k];
      }
      for (var i = 0; i < k; i++) {
        for (var j = 0; j < nx; j++) {
          X[i][j] -= X[k][j] * _LUMatrix[i][k];
        }
      }
    }
    return X;
  }
}
