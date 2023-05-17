part of matrix_utils;

extension MatrixManipulationExtension on Matrix {
  /// Concatenates the given list of matrices with the current matrix along the specified axis.
  ///
  /// [matrices]: List of matrices to be concatenated.
  /// [axis]: 0 for concatenating along rows, and 1 for concatenating along columns (default is 0).
  /// [resize]: If true, resizes the matrices so that they have the same dimensions before concatenation (default is false).
  ///
  /// Returns a new concatenated matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[1, 2], [3, 4]]);
  /// var matrixB = Matrix([[5, 6]]);
  /// var result = matrixA.concatenate([matrixB]);
  /// print(result);
  /// // Output:
  /// // 1  2
  /// // 3  4
  /// // 5  6
  /// ```
  Matrix concatenate(List<Matrix> matrices,
      {int axis = 0, bool resize = false}) {
    if (matrices.isEmpty) {
      throw Exception("Matrices list cannot be null or empty");
    }

    if (axis != 0 && axis != 1) {
      throw Exception("Invalid axis: Axis must be either 0 or 1");
    }

    Matrix result = this;

    for (Matrix other in matrices) {
      if (!resize &&
          ((axis == 0 && columnCount != other.columnCount) ||
              (axis == 1 && rowCount != other.rowCount))) {
        throw Exception("Incompatible matrices for concatenation");
      }

      int maxRowCount =
          axis == 1 ? math.max(rowCount, other.rowCount) : rowCount;
      int maxColumnCount =
          axis == 0 ? math.max(columnCount, other.columnCount) : columnCount;

      List<List<dynamic>> resizedDataA = List.generate(
          maxRowCount, (i) => List<dynamic>.filled(maxColumnCount, 0));
      List<List<dynamic>> resizedDataB = List.generate(
          maxRowCount, (i) => List<dynamic>.filled(maxColumnCount, 0));

      if (resize) {
        for (int i = 0; i < rowCount; i++) {
          for (int j = 0; j < columnCount; j++) {
            resizedDataA[i][j] = result[i][j];
          }
        }

        for (int i = 0; i < other.rowCount; i++) {
          for (int j = 0; j < other.columnCount; j++) {
            resizedDataB[i][j] = other[i][j];
          }
        }
      } else {
        resizedDataA = result.toList();
        resizedDataB = other.toList();
      }

      List<List<dynamic>> newData = [];

      if (axis == 0) {
        newData.addAll(resizedDataA);
        newData.addAll(resizedDataB);
      } else {
        for (int i = 0; i < maxRowCount; i++) {
          List<dynamic> newRow = [];
          newRow.addAll(resizedDataA[i]);
          newRow.addAll(resizedDataB[i]);
          newData.add(newRow);
        }
      }

      result = Matrix(newData);
    }

    return result;
  }

  /// Reshapes the matrix to have the specified number of rows and columns.
  ///
  /// [newRowCount]: The new number of rows.
  /// [newColumnCount]: The new number of columns.
  ///
  /// Returns a new matrix with the specified shape.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var reshaped = matrix.reshape(1, 4);
  /// print(reshaped);
  /// // Output:
  /// // 1  2  3  4
  /// ```
  Matrix reshape(int newRowCount, int newColumnCount) {
    if (rowCount * columnCount != newRowCount * newColumnCount) {
      throw Exception("Incompatible dimensions for reshape");
    }

    List<dynamic> elements = toList().expand((row) => row).toList();
    List<List<dynamic>> newData = List.generate(newRowCount,
        (_) => List<dynamic>.filled(newColumnCount, null, growable: false));

    int k = 0;
    for (int i = 0; i < newRowCount; i++) {
      for (int j = 0; j < newColumnCount; j++) {
        newData[i][j] = elements[k++];
      }
    }

    return Matrix(newData);
  }

  /// Reshapes the matrix to have the specified shape provided in the form of a list.
  ///
  /// [newShape]: List of integers representing the new shape (rows and columns).
  ///
  /// Returns a new matrix with the specified shape.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var reshaped = matrix.reshapeList([1, 4]);
  /// print(reshaped);
  /// // Output:
  /// // 1  2  3  4
  /// ```
  Matrix reshapeList(List<int> newShape) {
    int newRows = newShape[0];
    int newCols = newShape[1];
    int totalElements = rowCount * columnCount;
    if (newRows * newCols != totalElements) {
      throw Exception('Cannot reshape matrix to specified shape');
    }

    List<List<dynamic>> newData = [];

    for (int i = 0; i < newRows; i++) {
      List<dynamic> row = [];
      for (int j = 0; j < newCols; j++) {
        int index = i * newCols + j;
        int rowIndex = index ~/ _data[0].length;
        int colIndex = index % _data[0].length;
        row.add(_data[rowIndex][colIndex]);
      }
      newData.add(row);
    }

    return Matrix(newData);
  }

  static int compareTo(List<dynamic> a, List<dynamic> b) {
    for (int i = 0; i < a.length; i++) {
      int comparison = a[i].compareTo(b[i]);
      if (comparison != 0) {
        return comparison;
      }
    }
    return 0;
  }

  /// Sorts the matrix in ascending or descending order.
  ///
  /// [ascending]: If true, sorts the matrix in ascending order; if false, sorts it in descending order (default is true).
  ///
  /// Returns a new matrix with sorted values.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[3], [1], [4]]);
  /// var sortedMatrix = matrix.sort(ascending: false);
  /// print(sortedMatrix);
  /// // Output:
  /// // 4
  /// // 3
  /// // 1
  /// ```
  Matrix sort({List<int>? columnIndices, bool ascending = true}) {
    if (toList().isEmpty || this[0].isEmpty) {
      throw Exception('Matrix is empty');
    }

    Matrix sortedMatrix = Matrix([
      for (int i = 0; i < rowCount; i++)
        [for (int j = 0; j < columnCount; j++) this[i][j]]
    ]);

    // Sort all elements in ascending or descending order
    if (columnIndices == null || columnIndices.isEmpty) {
      List<dynamic> elements =
          sortedMatrix.toList().expand((row) => row).toList();

      elements.sort((a, b) => ascending ? a.compareTo(b) : b.compareTo(a));

      int k = 0;
      for (int i = 0; i < rowCount; i++) {
        for (int j = 0; j < columnCount; j++) {
          sortedMatrix[i][j] = elements[k++];
        }
      }
    } else {
      // Validate column indices
      for (int columnIndex in columnIndices) {
        if (columnIndex < 0 || columnIndex >= columnCount) {
          throw Exception('Invalid column index for sorting');
        }
      }

      sortedMatrix._data.sort((a, b) {
        for (int columnIndex in columnIndices) {
          int comparison = a[columnIndex].compareTo(b[columnIndex]);
          if (comparison != 0) {
            return ascending ? comparison : -comparison;
          }
        }
        return 0;
      });
    }

    return sortedMatrix;
  }

  /// Removes the row at the specified index from the matrix.
  ///
  /// [rowIndex]: The index of the row to be removed.
  ///
  /// Returns a new matrix with the specified row removed.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// var matrixWithoutRow = matrix.removeRow(1);
  /// print(matrixWithoutRow);
  /// // Output:
  /// // 1  2
  /// // 5  6
  /// ```
  Matrix removeRow(int rowIndex) {
    if (rowIndex < 0 || rowIndex >= rowCount) {
      throw Exception("Row index out of range");
    }

    List<List<dynamic>> newData = List.from(toList());
    newData.removeAt(rowIndex);

    return Matrix(newData);
  }

  /// Removes the rows at the specified indices from the matrix.
  ///
  /// [rowIndices]: A list of indices of the rows to be removed.
  ///
  /// Returns a new matrix with the specified rows removed.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// var matrixWithoutRows = matrix.removeRows([0, 2]);
  /// print(matrixWithoutRows);
  /// // Output:
  /// // 3  4
  /// ```
  Matrix removeRows(List<int> rowIndices) {
    rowIndices.sort((a, b) => b.compareTo(a));

    List<List<dynamic>> newData = List.from(toList());

    for (int rowIndex in rowIndices) {
      if (rowIndex < 0 || rowIndex >= rowCount) {
        throw Exception("Row index out of range");
      }
      newData.removeAt(rowIndex);
    }

    return Matrix(newData);
  }

  /// Removes the column at the specified index from the matrix.
  ///
  /// [columnIndex]: The index of the column to be removed.
  ///
  /// Returns a new matrix with the specified column removed.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// var matrixWithoutColumn = matrix.removeColumn(1);
  /// print(matrixWithoutColumn);
  /// // Output:
  /// // 1
  /// // 3
  /// // 5
  /// ```
  Matrix removeColumn(int columnIndex) {
    if (columnIndex < 0 || columnIndex >= columnCount) {
      throw Exception("Column index out of range");
    }

    List<List<dynamic>> newData = List.generate(rowCount,
        (_) => List<dynamic>.filled(columnCount - 1, null, growable: false));

    for (int i = 0; i < rowCount; i++) {
      int k = 0;
      for (int j = 0; j < columnCount; j++) {
        if (j == columnIndex) continue;
        newData[i][k++] = this[i][j];
      }
    }

    return Matrix(newData);
  }

  /// Removes the columns at the specified indices from the matrix.
  ///
  /// [columnIndices]: A list of indices of the columns to be removed.
  ///
  /// Returns a new matrix with the specified columns removed.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2, 3], [4, 5, 6], [7, 8, 9]]);
  /// var matrixWithoutColumns = matrix.removeColumns([0, 2]);
  /// print(matrixWithoutColumns);
  /// // Output:
  /// // 2
  /// // 5
  /// // 8
  /// ```
  Matrix removeColumns(List<int> columnIndices) {
    columnIndices.sort((a, b) => b.compareTo(a));

    List<List<dynamic>> newData = List.generate(
        rowCount,
        (_) => List<dynamic>.filled(columnCount - columnIndices.length, null,
            growable: false));

    for (int i = 0; i < rowCount; i++) {
      int k = 0;
      for (int j = 0; j < columnCount; j++) {
        if (columnIndices.contains(j)) continue;
        newData[i][k++] = this[i][j];
      }
    }

    return Matrix(newData);
  }

  /// Sets the specified row in the matrix with the new values provided in new Values.
  ///
  /// [rowIndex]: The row index to update
  /// [newValues]: The new values
  ///
  /// Return a new matrix with the specific row updated
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix.fromList([[1, 2], [3, 4]]);
  /// matrix.updateRow(0, [5, 6]);
  /// print(matrix);
  /// // Output:
  /// // Matrix: 2x2
  /// // ┌ 5 6 ┐
  /// // └ 3 4 ┘
  /// ```
  Matrix setRow(int rowIndex, List<dynamic> newValues) {
    var newData = _data;
    newData[rowIndex] = newValues;
    return Matrix(newData);
  }

  /// Sets the specified column in the matrix with the new values provided in new Values.
  ///
  /// [columnIndex]: The row index to update
  /// [newValues]: The new values
  ///
  /// Return a new matrix with the specific row updated
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix.fromList([[1, 2], [3, 4]]);
  /// matrix.setColumn(1, [5, 6]);
  /// print(matrix);
  /// // Output:
  /// // Matrix: 2x2
  /// // ┌ 1 5 ┐
  /// // └ 3 6 ┘
  /// ```
  Matrix setColumn(int columnIndex, List<dynamic> newValues) {
    if (rowCount != newValues.length) {
      throw Exception(
          'The new column must have the same number of rows as the matrix');
    }
    var newData = _data;
    for (int i = 0; i < rowCount; i++) {
      newData[i][columnIndex] = newValues[i];
    }

    return Matrix(newData);
  }

  /// Inserts a new row at the specified position in the matrix with the values provided in new Values.
  ///
  /// [rowIndex]: The row index to insert into the matrix
  /// [newValues]: The new values
  ///
  /// Return a new matrix with the inserted row in the matrix
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix.fromList([[1, 2], [3, 4]]);
  /// matrix.insertRow(1, [5, 6]);
  /// print(matrix);
  /// // Output:
  /// // Matrix: 3x2
  /// // ┌ 1 2 ┐
  /// // | 5 6 |
  /// // └ 3 4 ┘
  /// ```
  Matrix insertRow(int rowIndex, List<dynamic> newValues) {
    var newData = _data;
    newData.insert(rowIndex, newValues);
    return Matrix(newData);
  }

  /// Inserts a new column at the specified position in the matrix with the values provided in new Values.
  ///
  /// [columnIndex]: The row index to insert into the matrix
  /// [newValues]: The new values
  ///
  /// Return a new matrix with the inserted row in the matrix
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix.fromList([[1, 2], [3, 4]]);
  /// matrix.insertColumn(1, [5, 6]);
  /// print(matrix);
  /// // Output:
  /// // Matrix: 2x3
  /// // ┌ 1 5 2 ┐
  /// // └ 3 6 4 ┘
  /// ```
  Matrix insertColumn(int columnIndex, List<dynamic> newValues) {
    if (rowCount != newValues.length) {
      throw Exception(
          'The new column must have the same number of rows as the matrix');
    }
    var newData = _data;

    for (int i = 0; i < rowCount; i++) {
      newData[i].insert(columnIndex, newValues[i]);
    }

    return Matrix(newData);
  }

  /// Appends new rows to the matrix with the values provided in [newRows].
  ///
  /// [newRows]: A list of rows or a Matrix to append to the matrix
  ///
  /// Returns a new matrix with the appended rows
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix.fromList([[1, 2], [3, 4]]);
  /// matrix = matrix.appendRows(Matrix.fromList([[5, 6], [7, 8]]));
  /// print(matrix);
  /// // Output:
  /// // Matrix: 4x2
  /// // ┌ 1 2 ┐
  /// // | 3 4 |
  /// // | 5 6 |
  /// // └ 7 8 ┘
  /// ```
  Matrix appendRows(dynamic newRows) {
    List<List<dynamic>> rowsToAdd;
    if (newRows is Matrix) {
      rowsToAdd = newRows.toList();
    } else if (newRows is List<List<dynamic>>) {
      rowsToAdd = newRows;
    } else {
      throw Exception('Invalid input type');
    }

    if (columnCount != rowsToAdd[0].length) {
      throw Exception(
          'The new rows must have the same number of columns as the matrix');
    }
    var newData = List<List<dynamic>>.from(_data);
    newData.addAll(rowsToAdd);
    return Matrix(newData);
  }

  /// Appends new columns to the matrix with the values provided in [newColumns].
  ///
  /// [newColumns]: A list of columns or a Matrix to append to the matrix
  ///
  /// Returns a new matrix with the appended columns
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix.fromList([[1, 2], [3, 4]]);
  /// matrix = matrix.appendColumns(Matrix.fromList([[5, 6], [7, 8]]));
  /// print(matrix);
  /// // Output:
  /// // Matrix: 2x4
  /// // ┌ 1 2 5 7 ┐
  /// // └ 3 4 6 8 ┘
  /// ```
  Matrix appendColumns(dynamic newColumns) {
    List<List<dynamic>> columnsToAdd;
    if (newColumns is Matrix) {
      columnsToAdd = newColumns.transpose().toList();
    } else if (newColumns is List<List<dynamic>>) {
      columnsToAdd = newColumns;
    } else {
      throw Exception('Invalid input type');
    }

    if (rowCount != columnsToAdd[0].length) {
      throw Exception(
          'The new columns must have the same number of rows as the matrix');
    }
    var newData = List<List<dynamic>>.from(_data);

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnsToAdd.length; j++) {
        newData[i].add(columnsToAdd[j][i]);
      }
    }

    return Matrix(newData);
  }

  /// Retrieves the element of the matrix at the specified row and column indices.
  ///
  /// [row]: The row index of the element.
  /// [col]: The column index of the element.
  ///
  /// Returns the element at the specified row and column indices.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// var element = matrix.elementAt(1, 0);
  /// print(element);
  /// // Output: 3
  /// ```
  dynamic elementAt(int row, int col) {
    if (row < 0 || row >= rowCount || col < 0 || col >= columnCount) {
      throw Exception('Index out of range');
    }
    return this[row][col];
  }

  /// Replaces the elements in the specified rows and columns with the given value.
  ///
  /// [rows]: A list of row indices to replace.
  /// [cols]: A list of column indices to replace.
  /// [value]: The value to replace the elements with.
  ///
  /// Returns a new matrix with the specified elements replaced.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// var matrixReplaced = matrix.replace([0, 2], [1], 0);
  /// print(matrixReplaced);
  /// // Output:
  /// // 1  0
  /// // 3  4
  /// // 5  0
  /// ```
  Matrix replace(List<int> rows, List<int> cols, dynamic value) {
    List<List<dynamic>> newData = List.from(toList());
    for (int row in rows) {
      if (row >= rowCount || row < 0) {
        throw Exception('Invalid row index');
      }
      for (int col in cols) {
        if (col >= columnCount || col < 0) {
          throw Exception('Invalid column index');
        }
        newData[row][col] = value;
      }
    }
    return Matrix(newData);
  }

  /// Flattens the matrix into a single row.
  ///
  /// Returns a new `Row` containing all elements of the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// var flattenedMatrix = matrix.flatten();
  /// print(flattenedMatrix);
  /// // Output: 1  2  3  4  5  6
  /// ```
  List<dynamic> flatten() {
    //List<dynamic> list = rowIterable.expand((x) => x).toList();
    List<dynamic> newData = [
      for (int i = 0; i < rowCount; i++)
        for (int j = 0; j < columnCount; j++) this[i][j]
    ];
    return newData;
  }

  /// Reverses the matrix along the specified axis.
  ///
  /// [axis]: The axis along which to reverse the matrix (0 for rows, 1 for columns).
  ///
  /// Returns a new matrix reversed along the specified axis.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// var matrixReversed = matrix.reverse(1);
  /// print(matrixReversed);
  /// // Output:
  /// // 2  1
  /// // 4  3
  /// // 6  5
  /// ```
  Matrix reverse(int axis) {
    if (axis == 0) {
      List<List<dynamic>> newData = [];

      for (int i = rowCount - 1; i >= 0; i--) {
        newData.add(this[i]);
      }

      return Matrix(newData);
    } else if (axis == 1) {
      List<List<dynamic>> newData = [];

      for (int i = 0; i < rowCount; i++) {
        List<dynamic> row = [];
        for (int j = columnCount - 1; j >= 0; j--) {
          row.add(this[i][j]);
        }
        newData.add(row);
      }

      return Matrix(newData);
    } else {
      throw Exception('Invalid axis');
    }
  }

  /// Returns a copy of the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// var matrixCopy = matrix.copy();
  /// print(matrixCopy);
  /// // Output:
  /// // 1  2
  /// // 3  4
  /// // 5  6
  /// ```
  Matrix copy() {
    return this;
  }

  /// Copies the elements from another matrix into this matrix.
  ///
  /// [other]: The matrix to copy elements from.
  /// [resize]: Optional boolean flag to resize the current matrix to the shape of the other matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[1, 2], [3, 4]]);
  /// var matrixB = Matrix([[5, 6], [7, 8], [9, 10]]);
  /// matrixA.copyFrom(matrixB, resize: true);
  /// print(matrixA);
  /// // Output:
  /// // 5  6
  /// // 7  8
  /// // 9 10
  /// ```
  void copyFrom(Matrix other, {bool resize = false}) {
    if (!resize &&
        (rowCount != other.rowCount || columnCount != other.columnCount)) {
      throw Exception("Matrices have different shapes");
    }

    int newRowCount = resize ? other.rowCount : rowCount;
    int newColumnCount = resize ? other.columnCount : columnCount;

    if (resize) {
      _data = List.generate(
          newRowCount, (i) => List<dynamic>.filled(newColumnCount, 0));
    }

    int copyRowCount = math.min(rowCount, other.rowCount);
    int copyColumnCount = math.min(columnCount, other.columnCount);

    for (int i = 0; i < copyRowCount; i++) {
      for (int j = 0; j < copyColumnCount; j++) {
        this[i][j] = other[i][j];
      }
    }
  }

  /// Extracts a subMatrix from the given matrix using the specified row and column indices or ranges.
  ///
  /// - [rowIndices]: Optional list of integers representing the row indices to include in the subMatrix.
  /// - [columnIndices]: Optional list of integers representing the column indices to include in the subMatrix.
  /// - [rowRange]: Optional string representing the row range (e.g. "1:3").
  /// - [colRange]: Optional string representing the column range (e.g. "1:3").
  /// - [rowStart]: Optional start index of the row range.
  /// - [rowEnd]: Optional end index of the row range.
  /// - [colStart]: Optional start index of the column range.
  /// - [colEnd]: Optional end index of the column range.
  ///
  /// Returns a new matrix containing the specified subMatrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2, 3], [4, 5, 6], [7, 8, 9]]);
  /// var subMatrix = matrix.subMatrix(rowList: [0, 2], colList: [1, 2]);
  /// print(subMatrix);
  /// // Output:
  /// // 2  3
  /// // 8  9
  /// ```
  Matrix subMatrix(
      {List<int>? rowIndices,
      List<int>? columnIndices,
      String rowRange = '',
      String colRange = '',
      int? rowStart,
      int? rowEnd,
      int? colStart,
      int? colEnd}) {
    // If no row indices are provided, default to all rows
    // If rowStart or rowEnd is provided, use these to create the list
    final rowIndices_ = rowIndices ??
        (rowStart != null && rowEnd != null
            ? List.generate(rowEnd - rowStart + 1, (i) => rowStart + i)
            : (rowRange.isNotEmpty
                ? _Utils.parseRange(rowRange, rowCount)
                : List.generate(rowCount, (i) => i)));

    // If no column indices are provided, default to all columns
    // If colStart or colEnd is provided, use these to create the list
    final colIndices_ = columnIndices ??
        (colStart != null && colEnd != null
            ? List.generate(colEnd - colStart + 1, (i) => colStart + i)
            : (colRange.isNotEmpty
                ? _Utils.parseRange(colRange, columnCount)
                : List.generate(columnCount, (i) => i)));

    if (rowIndices_.any((i) => i < 0 || i >= rowCount)) {
      throw Exception('Row indices are out of range');
    }

    if (colIndices_.any((i) => i < 0 || i >= columnCount)) {
      throw Exception('Column indices are out of range');
    }

    List<List<dynamic>> newData = [];

    for (int i = 0; i < rowIndices_.length; i++) {
      List<dynamic> row = [];
      for (int j = 0; j < colIndices_.length; j++) {
        row.add(_data[rowIndices_[i]][colIndices_[j]]);
      }
      newData.add(row);
    }

    return Matrix(newData);
  }

  /// Returns a subMatrix that is a portion of the original matrix.
  ///
  /// The parameters [startRow] and [endRow] specify the starting and ending row indices,
  /// while the optional parameters [startCol] and [endCol] specify the starting and ending
  /// column indices.
  ///
  /// Example:
  /// ```
  /// Matrix mat = Matrix.fromList([
  ///   [4, 5, 6, 7],
  ///   [9, 9, 8, 6],
  ///   [1, 1, 2, 9]
  /// ]);
  ///
  /// Matrix subMat = mat.slice(1, 2, 1, 2);
  /// print(mat);
  /// ```
  /// Output:
  /// ```
  /// // Matrix: 2x2
  /// // ┌ 9 8 ┐
  /// // └ 1 2 ┘
  /// ```
  Matrix slice(int startRow, int endRow, [int? startCol, int? endCol]) {
    if (startRow < 0 ||
        startRow >= rowCount ||
        endRow < 0 ||
        endRow >= rowCount) {
      throw RangeError("Row indices are out of range.");
    }

    startCol ??= 0;
    endCol ??= columnCount - 1;

    if (startCol < 0 ||
        startCol >= columnCount ||
        endCol < 0 ||
        endCol >= columnCount) {
      throw RangeError("Column indices are out of range.");
    }

    List<List<dynamic>> subData = [];
    for (int i = startRow; i <= endRow; i++) {
      subData.add(_data[i].sublist(startCol, endCol + 1));
    }
    return Matrix.fromList(subData);
  }

  /// Sets the values of the subMatrix at the specified position.
  ///
  /// The parameters [startRow] and [startCol] specify the starting row and column indices,
  /// and [subMatrix] is the subMatrix to be inserted.
  ///
  /// Example:
  /// ```dart
  /// Matrix mat = Matrix.fromList([
  ///   [4, 5, 6, 7],
  ///   [9, 9, 8, 6],
  ///   [1, 1, 2, 9]
  /// ]);
  ///
  /// Matrix subMat = Matrix.fromList([
  ///   [3, 3],
  ///   [3, 3]
  /// ]);
  ///
  /// mat.setSubMatrix(1, 1, subMat);
  /// print(mat);
  ///
  /// Output:
  /// Matrix: 3x4
  /// ┌ 4 5 6 7 ┐
  /// │ 9 3 3 6 │
  /// └ 1 3 3 9 ┘
  /// ```
  void setSubMatrix(int startRow, int startCol, Matrix subMatrix) {
    int rows = subMatrix.rowCount;
    int cols = subMatrix.columnCount;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        _data[startRow + i][startCol + j] = subMatrix[i][j];
      }
    }
  }

  /// Splits the matrix into smaller matrices along the specified axis.
  ///
  /// [axis]: The axis along which to split the matrix (0 for rows, 1 for columns).
  /// [splits]: The number of equally sized subMatrices to split the matrix into.
  ///
  /// Returns a list of new matrices resulting from the split.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// var splitMatrixList = matrix.split(0, 3);
  /// print(splitMatrixList);
  /// // Output:
  /// // [ 1  2 ]
  /// // [ 3  4 ]
  /// // [ 5  6 ]
  /// ```
  List<Matrix> split(int axis, int splits) {
    if (axis < 0 || axis > 1) {
      throw Exception("Invalid axis value, axis must be 0 or 1");
    }

    if (splits <= 0) {
      throw Exception("Splits must be a positive integer");
    }

    if (axis == 0 && rowCount % splits != 0) {
      throw Exception("Number of rows is not divisible by splits");
    }

    if (axis == 1 && columnCount % splits != 0) {
      throw Exception("Number of columns is not divisible by splits");
    }

    List<Matrix> result = [];

    if (axis == 0) {
      int chunkSize = rowCount ~/ splits;
      for (int i = 0; i < rowCount; i += chunkSize) {
        List<List<dynamic>> chunkData = toList().sublist(i, i + chunkSize);
        result.add(Matrix(chunkData));
      }
    } else {
      int chunkSize = columnCount ~/ splits;
      for (int j = 0; j < columnCount; j += chunkSize) {
        List<List<dynamic>> chunkData = List.generate(rowCount, (_) => []);
        for (int i = 0; i < rowCount; i++) {
          chunkData[i].addAll(this[i].sublist(j, j + chunkSize));
        }
        result.add(Matrix(chunkData));
      }
    }

    return result;
  }

  /// Swaps the position of two rows in the current matrix.
  ///
  /// [row1]: The index of the first row to be swapped.
  /// [row2]: The index of the second row to be swapped.
  ///
  /// Throws an exception if either row index is out of range.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// matrix.swapRows(0, 1);
  /// print(matrix);
  /// // Output:
  /// // 3 4
  /// // 1 2
  /// ```
  void swapRows(int row1, int row2) {
    if (row1 < 0 || row1 >= rowCount || row2 < 0 || row2 >= rowCount) {
      throw Exception('Row indices are out of range');
    }

    List<dynamic> tempRow = _data[row1];
    _data[row1] = _data[row2];
    _data[row2] = tempRow;
  }

  /// Swaps the position of two columns in the current matrix.
  ///
  /// [col1]: The index of the first column to be swapped.
  /// [col2]: The index of the second column to be swapped.
  ///
  /// Throws an exception if either column index is out of range.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// matrix.swapColumns(0, 1);
  /// print(matrix);
  /// // Output:
  /// // 2 1
  /// // 4 3
  /// ```
  void swapColumns(int col1, int col2) {
    if (col1 < 0 || col1 >= columnCount || col2 < 0 || col2 >= columnCount) {
      throw Exception('Column indices are out of range');
    }

    for (int i = 0; i < rowCount; i++) {
      dynamic tempValue = _data[i][col1];
      _data[i][col1] = _data[i][col2];
      _data[i][col2] = tempValue;
    }
  }

  /// Replicates the current matrix to create a new matrix with the desired dimensions.
  ///
  /// The function copies the elements of the current matrix to fill the new matrix of size
  /// `numRows` x `numCols`. The new matrix is created by repeating the input matrix along
  /// the rows and columns.
  ///
  /// [numRows] The desired number of rows in the output matrix.
  /// [numCols] The desired number of columns in the output matrix.
  ///
  /// Returns a new matrix of size `numRows` x `numCols` with the replicated elements of the current matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix a = Matrix([
  ///   [1, 2],
  ///   [3, 4],
  /// ]);
  ///
  /// Matrix replicated = a.replicateMatrix(4, 6);
  /// print(replicated);
  /// ```
  ///
  /// Output:
  /// ```
  /// Matrix: 4x6
  /// ┌ 1  2  1  2  1  2 ┐
  /// │ 3  4  3  4  3  4 │
  /// │ 1  2  1  2  1  2 │
  /// └ 3  4  3  4  3  4 ┘
  /// ```
  Matrix replicateMatrix(int numRows, int numCols) {
    // Create a new matrix with the desired dimensions
    Matrix result = Matrix.zeros(numRows, numCols);

    // Replicate the elements of the input matrix along the required dimensions
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        result[i][j] = this[i % rowCount][j % columnCount];
      }
    }

    return result;
  }

  /// Determines whether the current matrix and matrix [b] are compatible for broadcasting.
  ///
  /// Two matrices are compatible for broadcasting if, for each dimension, the dimension
  /// sizes are either equal or one of them is 1.
  ///
  /// [b] The matrix to be checked for compatibility with the current matrix.
  ///
  /// Returns `true` if the matrices are compatible for broadcasting, and `false` otherwise.
  bool isCompatibleForBroadcastWith(Matrix b) {
    return (rowCount == b.rowCount || rowCount == 1 || b.rowCount == 1) &&
        (columnCount == b.columnCount ||
            columnCount == 1 ||
            b.columnCount == 1);
  }

  /// Broadcasts the current matrix with matrix [b].
  ///
  /// If the matrices are compatible for broadcasting, it replicates the input matrices
  /// along the required dimensions to produce two matrices with the same shape.
  ///
  /// [b] The matrix to be broadcasted with the current matrix.
  ///
  /// Returns a list of two matrices, the first one being the broadcasted version
  /// of the current matrix, and the second one being the broadcasted version of matrix [b].
  ///
  /// Example:
  /// ```dart
  /// Matrix a = Matrix([
  ///   [1, 2, 3],
  /// ]);
  ///
  /// Matrix b = Matrix([
  ///   [1],
  ///   [2],
  ///   [3],
  /// ]);
  ///
  /// List<Matrix> broadcasted = a.broadcast(b);
  /// print(broadcasted[0]);
  /// ```
  ///
  /// Output:
  /// ```
  /// Matrix: 3x3
  /// ┌ 1  2  3 ┐
  /// │ 1  2  3 │
  /// └ 1  2  3 ┘
  ///
  /// print(broadcasted[1]);
  /// ```
  ///
  /// Output:
  /// ```
  /// Matrix: 3x3
  /// ┌ 1  1  1 ┐
  /// │ 2  2  2 │
  /// └ 3  3  3 ┘
  /// ```
  List<Matrix> broadcast(Matrix b) {
    // Check compatibility
    if (!isCompatibleForBroadcastWith(b)) {
      throw Exception('Matrices are not compatible for broadcasting.');
    }

    // Determine the dimensions of the output matrices
    int numRows = math.max(rowCount, b.rowCount);
    int numCols = math.max(columnCount, b.columnCount);

    // Broadcast and replicate the input matrices
    Matrix aBroadcasted = replicateMatrix(numRows, numCols);
    Matrix bBroadcasted = b.replicateMatrix(numRows, numCols);

    // Return the broadcasted matrices
    return [aBroadcasted, bBroadcasted];
  }

  /// Applies the given function [func] to each element in the matrix and returns a new matrix with the results.
  ///
  /// [func] should be a function that takes a single argument and returns a value.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix.fromList([[1, 2], [3, 4], [5, 6]]);
  /// var squaredMatrix = matrix.apply((x) => x * x);
  /// print(squaredMatrix); // Output: [[1, 4], [9, 16], [25, 36]]
  /// ```
  Matrix apply(Function(dynamic) func) {
    List<List<dynamic>> newData = List.generate(
        rowCount, (i) => List.generate(columnCount, (j) => func(_data[i][j])));

    return Matrix(newData);
  }
}
