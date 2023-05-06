part of matrix_utils;

/* TODO:
Matrix Functions:
   - Exponential, logarithmic, and trigonometric functions applied element-wise
   - Matrix rank approximation
   - Condition number estimation
   - Pseudoinverse calculation
   - Matrix power (generalized, not just integer powers)
 */

extension MatrixFunctions on Matrix {
  /// Element-wise sine
  Matrix sin() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.sin(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise cosine
  Matrix cos() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.cos(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise tangent
  Matrix tan() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.tan(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise arcsine
  Matrix asin() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.asin(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise arccosine
  Matrix acos() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.acos(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise arctangent
  Matrix atan() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.atan(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise atan2
  Matrix atan2(Matrix other) {
    if (rowCount != other.rowCount || columnCount != other.columnCount) {
      throw ArgumentError('Matrix dimensions must match for atan2');
    }

    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.atan2(this[i][j], other[i][j]);
      }
    }
    return result;
  }

  /// Element-wise sinh
  Matrix sinh() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = (this[i][j] as num).sinh();
      }
    }
    return result;
  }

  /// Element-wise cosh
  Matrix cosh() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = (this[i][j] as num).cosh();
      }
    }
    return result;
  }

  /// Element-wise tanh
  Matrix tanh() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = (this[i][j] as num).tanh();
      }
    }
    return result;
  }

  /// Element-wise asinh
  Matrix asinh() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = (this[i][j] as num).asinh();
      }
    }
    return result;
  }

  /// Element-wise acosh
  Matrix acosh() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = (this[i][j] as num).acosh();
      }
    }
    return result;
  }

  /// Element-wise atanh
  Matrix atanh() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = (this[i][j] as num).atanh();
      }
    }
    return result;
  }
}
