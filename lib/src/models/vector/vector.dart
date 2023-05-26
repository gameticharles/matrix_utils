part of matrix_utils;

class Vector {
  final List<num> _data;

  Vector(int length, {bool isDouble = true})
      : _data = List<num>.filled(length, isDouble ? 0.0 : 0);

  Vector.fromList(List<num> data) : _data = data;

  num operator [](int index) => _data[index];

  void operator []=(int index, num value) {
    _data[index] = value;
  }

  List<num> toList() => _data;

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

  static Vector random(int length,
      {double min = 0,
      double max = 1,
      bool isDouble = true,
      math.Random? random,
      int? seed}) {
    if (seed != null) {
      random = math.Random(seed);
    }
    List<num> data = List.generate(
      length,
      (_) => (isDouble
          ? random!.nextDouble() * (max - min) + min
          : random!.nextInt(max.toInt() - min.toInt()) + min.toInt()),
    );

    return Vector.fromList(data);
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
