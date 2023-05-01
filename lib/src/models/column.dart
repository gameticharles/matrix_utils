part of matrix_utils;

/// Column class extends Matrix and represents a single column in a matrix.
///
/// Inherits all Matrix properties and methods, but the data is stored in an Nx1 matrix.
class Column extends Matrix {
  /// Constructs a Column object from a list of dynamic data.
  ///
  /// [data]: List of dynamic data elements representing a single column.
  ///
  /// Example:
  /// ```dart
  /// var column = Column([1, 2, 3]);
  /// print(column);
  /// // Output:
  /// // 1
  /// // 2
  /// // 3
  /// ```
  Column(List<dynamic> data) : super(data.map((x) => [x]).toList());

  /// Returns the first element of the column.
  ///
  /// Example:
  /// ```dart
  /// var column = Column([1, 2, 3]);
  /// print(column.first); // Output: 1
  /// ```
  dynamic get first => _data[0][0];

  /// Returns the last element of the column.
  ///
  /// Example:
  /// ```dart
  /// var column = Column([1, 2, 3]);
  /// print(column.last); // Output: 3
  /// ```
  dynamic get last => _data[_data.length - 1][0];

  /// Returns the sum of all elements in the column.
  ///
  /// Example:
  /// ```dart
  /// var column = Column([1, 2, 3]);
  /// print(column.sum); // Output: 6
  /// ```
  dynamic get sum =>
      _data.map((row) => row[0]).reduce((value, element) => value + element);

  /// Returns the average of all elements in the column.
  ///
  /// Example:
  /// ```dart
  /// var column = Column([1, 2, 3]);
  /// print(column.average); // Output: 2.0
  /// ```
  dynamic get average => sum / _data.length;

  /// Returns the leading diagonals from a column.
  ///
  /// Example:
  /// ```dart
  /// var column = Column([1, 2, 3]);
  /// print(column.toDiagonal);
  /// // 1 0 0
  /// // 0 2 0
  /// // 0 0 3
  /// ```
  Diagonal toDiagonal() {
    List<dynamic> diagonal = [];
    for (int i = 0; i < _data.length; i++) {
      diagonal.add(_data[i][0]);
    }
    return Diagonal(diagonal);
  }
}
