part of matrix_utils;

extension MatrixStatsExtension on Matrix {
  /// Returns the smallest value in the matrix.
  ///
  /// Throws an exception if the matrix is empty.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[2, 3], [1, 4]]);
  /// print(matrix.min()); // Output: 1
  /// ```
  dynamic min() {
    int rows = rowCount;
    int cols = columnCount;
    if (rows == 0 || cols == 0) {
      throw Exception("Matrix is empty");
    }

    dynamic minValue = this[0][0];

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (this[i][j] < minValue) {
          minValue = this[i][j];
        }
      }
    }

    return minValue;
  }

  /// Finds the maximum absolute value in the matrix starting from the given row and column indices (inclusive).
  ///
  /// [startRow]: The starting row index for the search.
  /// [startCol]: The starting column index for the search.
  /// Returns a list containing the row and column indices of the maximum absolute value found in the matrix region.
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  /// List<int> maxIndices = A.findMaxInMatrixRegion(1, 1);
  /// print(maxIndices); // Output: [2, 2] (since the maximum value is 9)
  /// ```
  List<int> findMaxInMatrixRegion(int startRow, int startCol) {
    num maxValue = 0.0;
    int maxRow = startRow;
    int maxCol = startCol;

    for (int i = startRow; i < rowCount; i++) {
      for (int j = startCol; j < columnCount; j++) {
        if (this[i][j].abs() > maxValue) {
          maxValue = (this[i][j] as num).abs();
          maxRow = i;
          maxCol = j;
        }
      }
    }

    return [maxRow, maxCol];
  }

  /// Finds the minimum absolute value in the matrix starting from the given row and column indices (inclusive).
  ///
  /// [startRow]: The starting row index for the search.
  /// [startCol]: The starting column index for the search.
  /// Returns a list containing the row and column indices of the minimum absolute value found in the matrix region.
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  /// List<int> minIndices = A.findMinInMatrixRegion(1, 1);
  /// print(minIndices); // Output: [1, 1] (since the minimum value is 5)
  /// ```
  List<int> findMinInMatrixRegion(int startRow, int startCol) {
    num minValue = double.maxFinite;
    int minRow = startRow;
    int minCol = startCol;

    for (int i = startRow; i < rowCount; i++) {
      for (int j = startCol; j < columnCount; j++) {
        if (this[i][j].abs() < minValue) {
          minValue = (this[i][j] as num).abs();
          minRow = i;
          minCol = j;
        }
      }
    }

    return [minRow, minCol];
  }

  /// Returns the largest value in the matrix.
  ///
  /// Throws an exception if the matrix is empty.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[2, 3], [1, 4]]);
  /// print(matrix.max()); // Output: 4
  /// ```
  dynamic max() {
    int rows = rowCount;
    int cols = columnCount;
    if (rows == 0 || cols == 0) {
      throw Exception("Matrix is empty");
    }

    dynamic maxValue = this[0][0];

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (this[i][j] > maxValue) {
          maxValue = this[i][j];
        }
      }
    }

    return maxValue;
  }

  /// Returns the rank of the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [2, 4]]);
  /// print(matrix.rank()); // Output: 1
  /// ```
  int rank() {
    int rows = rowCount;
    int cols = columnCount;

    Matrix reducedMatrix = Matrix([
      for (int i = 0; i < rows; i++) [for (int j = 0; j < cols; j++) this[i][j]]
    ]);

    int rank = 0;
    bool rowAllZeros;

    for (int r = 0; r < rows; ++r) {
      if (reducedMatrix[r][rank] != 0) {
        for (int c = 0; c < rows; ++c) {
          // Changed 'cols' to 'rows'
          if (c != r) {
            double ratio = reducedMatrix[c][rank] / reducedMatrix[r][rank];
            for (int i = rank; i < cols; ++i) {
              reducedMatrix[c][i] -= ratio * reducedMatrix[r][i];
            }
          }
        }
        rank++;
      } else {
        rowAllZeros = true;
        for (int i = r + 1; i < rows; ++i) {
          if (reducedMatrix[i][rank] != 0) {
            List<dynamic> tmp = reducedMatrix[r];
            reducedMatrix[r] = reducedMatrix[i];
            reducedMatrix[i] = tmp;

            rowAllZeros = false;
            break;
          }
        }

        if (!rowAllZeros) {
          --r;
        }
      }

      if (rank == cols) {
        break;
      }
    }

    return rank;
  }

  /// Returns the mean (average) value of the elements in the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[2, 3], [1, 4]]);
  /// print(matrix.mean()); // Output: 2.5
  /// ```
  double mean() {
    double sum = 0;
    int count = 0;

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        sum += _data[i][j];
        count++;
      }
    }

    return sum / count;
  }

  /// Returns the median value of the elements in the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[2, 3], [1, 4]]);
  /// print(matrix.median()); // Output: 2.5
  /// ```
  double median() {
    List<double> elements = [];

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        elements.add(_data[i][j]);
      }
    }

    elements.sort();

    if (elements.length % 2 == 1) {
      return elements[elements.length ~/ 2];
    } else {
      return (elements[elements.length ~/ 2 - 1] +
              elements[elements.length ~/ 2]) /
          2.0;
    }
  }

  /// Returns the variance of the elements in the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[2, 3], [1, 4]]);
  /// print(matrix.variance()); // Output: 1.25
  /// ```
  double variance() {
    double meanValue = mean();
    double sum = 0;
    int count = 0;

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        double diff = _data[i][j] - meanValue;
        sum += diff * diff;
        count++;
      }
    }

    return sum / count;
  }

  /// Returns the standard deviation of the elements in the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[2, 3], [1, 4]]);
  /// print(matrix.standardDeviation()); // Output: 1.118033988749895
  /// ```
  double standardDeviation() {
    return math.sqrt(variance());
  }

  /// Returns the covariance matrix of the input matrix.
  ///
  /// Throws an exception if the matrix is empty.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// print(matrix.covarianceMatrix());
  /// // Output:
  /// // 4.0 4.0
  /// // 4.0 4.0
  /// ```
  Matrix covarianceMatrix() {
    if (rowCount == 0) {
      throw Exception("Matrix is empty");
    }

    int dimensions = columnCount;
    int n = rowCount;

    List<List<double>> means = [];
    for (int j = 0; j < dimensions; j++) {
      double sum = 0;
      for (int i = 0; i < n; i++) {
        sum += _data[i][j];
      }
      means.add(List<double>.filled(n, sum / n));
    }

    List<List<double>> centeredData = [];
    for (int i = 0; i < n; i++) {
      List<double> row = [];
      for (int j = 0; j < dimensions; j++) {
        row.add(_data[i][j] - means[j][i]);
      }
      centeredData.add(row);
    }

    List<List<double>> covMatrix =
        List.generate(dimensions, (_) => List<double>.filled(dimensions, 0));

    for (int i = 0; i < dimensions; i++) {
      for (int j = 0; j < dimensions; j++) {
        double sum = 0;
        for (int k = 0; k < n; k++) {
          sum += centeredData[k][i] * centeredData[k][j];
        }
        covMatrix[i][j] = sum / (n - 1);
      }
    }

    return Matrix(covMatrix);
  }

  /// Returns the Pearson correlation coefficient matrix of the input matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// print(matrix.pearsonCorrelationCoefficient());
  /// // Output:
  /// // 1.0 1.0
  /// // 1.0 1.0
  /// ```
  Matrix pearsonCorrelationCoefficient() {
    Matrix covMatrix = covarianceMatrix();
    List<double> stdDevs = [];

    for (int i = 0; i < covMatrix.rowCount; i++) {
      stdDevs.add(math.sqrt(covMatrix[i][i]));
    }

    List<List<double>> correlationMatrix =
        List.generate(rowCount, (_) => List<double>.filled(columnCount, 0));

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        correlationMatrix[i][j] = covMatrix[i][j] / (stdDevs[i] * stdDevs[j]);
      }
    }

    return Matrix(correlationMatrix);
  }

  /// Returns the skewness of the elements in the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// print(matrix.skewness()); // Output: 0.0
  /// ```
  double skewness() {
    double meanValue = mean();
    double sum = 0;
    int count = 0;

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        double diff = _data[i][j] - meanValue;
        sum += math.pow(diff, 3);
        count++;
      }
    }

    double skewness = sum / count;
    double standardDeviationCubed = math.pow(standardDeviation(), 3) as double;
    return skewness / standardDeviationCubed;
  }

  /// Returns the kurtosis of the elements in the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// print(matrix.kurtosis()); // Output: -1.2
  /// ```
  double kurtosis() {
    double meanValue = mean();
    double sum = 0;
    int count = 0;

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        double diff = _data[i][j] - meanValue;
        sum += math.pow(diff, 4);
        count++;
      }
    }

    double kurtosis = sum / count;
    double standardDeviationFourth = math.pow(standardDeviation(), 4) as double;
    return kurtosis / standardDeviationFourth - 3;
  }

  /// Returns the Row Echelon Form of the matrix.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9],
  /// ]);
  /// print(m.rowEchelonForm());
  /// // Output:
  /// // Matrix: 3x3
  /// // ┌ 1  2   3  ┐
  /// // │ 0  -3  -6 │
  /// // └ 0  0   0  ┘
  /// ```
  Matrix rowEchelonForm() {
    Matrix result = Matrix(_data as List<List<num>>);
    int lead = 0;

    for (int r = 0; r < rowCount; r++) {
      if (columnCount <= lead) {
        break;
      }

      int i = r;
      while (result[i][lead] == 0) {
        i++;
        if (rowCount == i) {
          i = r;
          lead++;
          if (columnCount == lead) {
            break;
          }
        }
      }

      result.swapRows(i, r);

      if (result[r][lead] != 0) {
        num div = result[r][lead];
        for (int j = 0; j < columnCount; j++) {
          result[r][j] /= div;
        }
      }

      for (int j = 0; j < rowCount; j++) {
        if (j != r) {
          num sub = result[j][lead];
          for (int k = 0; k < columnCount; k++) {
            result[j][k] -= sub * result[r][k];
          }
        }
      }

      lead++;
    }

    return result;
  }
}
