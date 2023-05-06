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

  // /// Assigns the value to the specified column index of the Row.
  // operator []=(int index, dynamic value) {
  //   if (_data.isNotEmpty && value.length != _data[0].length) {
  //     throw Exception('Row has different length than the other rows');
  //   }
  //   if (index < 0 || index >= _data[0].length) {
  //     throw Exception('Index is out of range');
  //   }
  //   _data[0][index] = value;
  // }

  // /// Retrieves the specified column from the matrix.
  // List<dynamic> operator [](int index) {
  //   if (index < 0 || index >= _data[0].length) {
  //     throw Exception('Index is out of range');
  //   }
  //   return _data[0][index];
  // }

  /// Creates a new Row object with the specified number of columns filled with the specified value.
  ///
  /// [cols]: The number of columns in the new Row object.
  /// [value]: The value used to fill each element in the new Row object.
  ///
  /// Throws [Exception] if the specified number of columns is less than 1.
  ///
  /// Returns a new Row object with the specified number of columns filled with the specified value.
  ///```dart
  /// Row filledRow = Row.fill(5, 3);
  /// print(filledRow);
  /// ```
  ///
  factory Row.fill(int cols, dynamic value) {
    if (cols < 1) {
      throw Exception("Columns must be greater than 0");
    }

    List<dynamic> row = List.generate(cols, (index) => value);

    return Row(row);
  }

  /// Get the list of the elements that are in the matrix
  List<dynamic> get asList => _data;

  /// Returns the first element of the row.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// print(row.first); // Output: 1
  /// ```
  dynamic get firstItem => _data[0][0];

  /// Returns the last element of the row.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// print(row.last); // Output: 3
  /// ```
  dynamic get lastItem => _data[0][_data[0].length - 1];

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
