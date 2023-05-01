part of matrix_utils;

/// Row class extends Matrix and represents a single row in a matrix.
///
/// Inherits all Matrix properties and methods, but the data is stored in a 1xN matrix.
class Row extends Matrix {
  /// Constructs a Row object from a list of dynamic data.
  ///
  /// [data]: List of dynamic data elements representing a single row.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// print(row);
  /// // Output: 1 2 3
  /// ```
  Row(List<dynamic> data) : super([data]);

  /// Returns the first element of the row.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// print(row.first); // Output: 1
  /// ```
  dynamic get first => _data[0][0];

  /// Returns the last element of the row.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// print(row.last); // Output: 3
  /// ```
  dynamic get last => _data[0][_data[0].length - 1];

  /// Returns the sum of all elements in the row.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// print(row.sum); // Output: 6
  /// ```
  double get sum => _data[0].reduce((value, element) => value + element);

  /// Returns the average of all elements in the row.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// print(row.average); // Output: 2.0
  /// ```
  double get average => sum / _data[0].length;

  /// Returns the leading diagonals from a row.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// print(row.toDiagonal);
  /// // 1 0 0
  /// // 0 2 0
  /// // 0 0 3
  /// ```
  Matrix toDiagonal() {
    List<dynamic> diagonal = [];
    for (int i = 0; i < _data[0].length; i++) {
      diagonal.add(_data[0][i]);
    }
    return Diagonal(diagonal);
  }
}
