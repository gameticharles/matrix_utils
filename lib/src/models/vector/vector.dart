part of matrix_utils;

class Vector {
  final List<double> _data;

  Vector(int length) : _data = List<double>.filled(length, 0);

  Vector.fromList(List<double> data) : _data = data;

  double operator [](int index) => _data[index];

  void operator []=(int index, double value) {
    _data[index] = value;
  }

  int get length => _data.length;

  double dot(Vector other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for dot product.");
    }
    double result = 0;
    for (int i = 0; i < length; i++) {
      result += this[i] * other[i];
    }
    return result;
  }

  Vector operator +(Vector other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for addition.");
    }
    Vector result = Vector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] + other[i];
    }
    return result;
  }

  Vector operator -(Vector other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for subtraction.");
    }
    Vector result = Vector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] - other[i];
    }
    return result;
  }

  Vector operator *(double scalar) {
    Vector result = Vector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] * scalar;
    }
    return result;
  }

  Vector operator /(double scalar) {
    Vector result = Vector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] / scalar;
    }
    return result;
  }

  double norm() {
    double sum = 0;
    for (int i = 0; i < length; i++) {
      sum += this[i] * this[i];
    }
    return math.sqrt(sum);
  }

  Vector normalize() {
    double normValue = norm();
    if (normValue == 0) {
      throw ArgumentError("Cannot normalize a zero vector.");
    }
    return this / normValue;
  }

  @override
  String toString() {
    return _data.toString();
  }
}
