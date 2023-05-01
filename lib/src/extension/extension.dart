part of matrix_utils;

extension MatrixListExtension on List {
  /// The shape of an array is the number of elements in each dimension.
  List get shape => Matrix(this).shape;

  /// Used to get a copy of an given array collapsed into one dimension
  Row get flatten => Matrix(this).flatten();

  /// Reverse the axes of an array and returns the modified array.
  Matrix get transpose => Matrix(this).transpose();

  /// Create a matrix with the list
  Matrix toMatrix() => Matrix(this);

  /// Function returns the sum of array elements
  double get sum => Matrix(this).sum();

  /// To find a diagonal element from a given matrix and gives output as one dimensional matrix
  List<dynamic> get diagonal => Matrix(this).diagonal();

  /// Reshaping means changing the shape of an array.
  List reshape(int row, int column) => Matrix().reshape(row, column).toList();

  /// find min value of given matrix
  List min({int? axis}) => Matrix(this).min();

  /// find max value of given matrix
  List max({int? axis}) => Matrix(this).max();

  /// flip (`reverse`) the matrix along the given axis and returns the modified array.
  List flip({int axis = 0}) => Matrix(this).reverse(axis).toList();
}
