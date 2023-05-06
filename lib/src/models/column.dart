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

  // /// Assigns the value to the specified row index of the Row.
  // operator []=(int index, dynamic value) {
  //   if (_data.isNotEmpty && value.length != _data[0].length) {
  //     throw Exception('Row has different length than the other rows');
  //   }
  //   if (index < 0 || index >= _data.length) {
  //     throw Exception('Index is out of range');
  //   }
  //   _data[index][0] = value;
  // }

  // /// Retrieves the specified row from the matrix.
  // List<dynamic> operator [](int index) {
  //   if (index < 0 || index >= _data.length) {
  //     throw Exception('Index is out of range');
  //   }
  //   return _data[index][0];
  // }

  /// Creates a new Column object with the specified number of rows filled with the specified value.
  ///
  /// [rows]: The number of rows in the new Column object.
  /// [value]: The value used to fill each element in the new Column object.
  ///
  /// Throws [Exception] if the specified number of rows is less than 1.
  ///
  /// Returns a new Column object with the specified number of rows filled with the specified value.
  ///```dart
  /// Column filledRow = Column.fill(5, 3);
  /// print(filledRow);
  /// ```
  ///
  factory Column.fill(int rows, dynamic value) {
    if (rows < 1) {
      throw Exception("Rows must be greater than 0");
    }

    List<dynamic> row = List.generate(rows, (index) => value);

    return Column(row);
  }

  /// Get the list of the elements that are in the matrix
  List<dynamic> get asList => flatten();

  /// Returns the first element of the column.
  ///
  /// Example:
  /// ```dart
  /// var column = Column([1, 2, 3]);
  /// print(column.first); // Output: 1
  /// ```
  dynamic get firstItem => _data[0][0];

  /// Returns the last element of the column.
  ///
  /// Example:
  /// ```dart
  /// var column = Column([1, 2, 3]);
  /// print(column.last); // Output: 3
  /// ```
  dynamic get lastItem => _data[_data.length - 1][0];

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
